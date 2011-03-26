package
{
	import net.hires.debug.Stats;

	import nl.funkymonkey.android.deviceinfo.NativeDeviceInfo;
	import nl.funkymonkey.android.deviceinfo.NativeDeviceProperties;

	import test.common.ITest;
	import test.common.TestResult;
	import test.common.TestRunner;

	import ui.LogField;

	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;

	// ::forcedImports::

	/**
	 * @author Juan Delgado
	 */
	public class TestF extends Sprite
	{
		private var logField : LogField;
		
		private var runner : TestRunner;
		
		private var stats : Stats;
		
		private var timer : Timer;
		
		private var testsXml : String;
		
		private var resultsGateway : String;
		
		private var countDown : int = 4;
		
		private const RESULTS_GATEWAY : String = ""; // TO BE DEFINED
		
		private const VERSION : String = "0.1";
		
		private const DEFAULT_TESTS_XML : String = "tests.xml";
		
		// Tests are defined in a XML, we need
		// to force the compiler to compile these classes.
		// See tools/preprocess for more info
// ::forcedVars::
		
		public function TestF()
		{
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			logField = new LogField();
			addChild(logField);
			
			logField.x = (stage.stageWidth - logField.width) >> 1;			logField.y = (stage.stageHeight - logField.height) >> 1;

			log("Welcome to TestF (v" + VERSION + ")\n");
			log("This log field goes away when tests start and comes back when they finish.\n");
			
			var flashVars : Object = LoaderInfo(root.loaderInfo).parameters;

			testsXml = (flashVars["fv_testsXml"] != null) ? flashVars["fv_testsXml"] : DEFAULT_TESTS_XML;
			resultsGateway = (flashVars["fv_resultsGateway"] != null) ? flashVars["fv_resultsGateway"] : RESULTS_GATEWAY;
			
			loadTests();
		}

		private function loadTests() : void
		{
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, testXmlLoaded);
			loader.addEventListener(IOErrorEvent.IO_ERROR, testXmlFailed);
			loader.load(new URLRequest(testsXml));
		}

		private function testXmlFailed(event : IOErrorEvent) : void
		{
			log("Cannot load tests xml: " + DEFAULT_TESTS_XML);
		}

		private function testXmlLoaded(event : Event) : void
		{
			runner = new TestRunner();
			runner.finishedSignal.addOnce(testsFinished);
			runner.updateSignal.add(runnerUpdate);
			
			var testsXml : XML = new XML(event.target["data"]);
			
			var testList : XMLList = testsXml.test;
			
			log(testList.length() + " tests found\n");
			
			for each(var testXml : XML in testList)
			{
				var testClassPath : String;
				
				var testParams : Vector.<String> = null;
				
				var xmlValue : String = testXml.toString();
				
				if(xmlValue.indexOf(" ") == -1)
				{
					testClassPath = xmlValue;
				}
				else
				{
					var bits : Array = xmlValue.split(" ");
					
					testClassPath = bits.shift();
					
					testParams = new Vector.<String>();
					
					while(bits.length > 0)
					{
						testParams.push(bits.shift());
					}
				}
				
				var ClassReference : Class = Class(getDefinitionByName(testClassPath));
				
				var testCase : ITest = ITest(new ClassReference());
				testCase.setParams(testParams);
				
				runner.addTest(testCase);
			}
			
			addChild(runner);
			
			swapChildren(runner, logField);

			timer = new Timer(1000, countDown);
			timer.addEventListener(TimerEvent.TIMER, updateCountDown);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, startTests);
			timer.start();
		}

		private function startTests(event : TimerEvent) : void
		{
			stats = new Stats();
			addChild(stats);
			
			stats.x = (stage.stageWidth - stats.width) >> 1;
			stats.y = (stage.stageHeight - stats.height) >> 1;

			logField.visible = false;
			
			runner.run();
		}

		private function updateCountDown(event : TimerEvent) : void
		{
			log("Starting in " + --countDown);
		}

		private function runnerUpdate(testCase : ITest, update : String) : void
		{
			log(update);
		}

		private function testsFinished(testCase : ITest) : void
		{
			removeChild(stats);
			
			runner.updateSignal.remove(runnerUpdate);

			postResults();

			var results : Vector.<TestResult> = runner.getResults();
			
			for each(var result : TestResult in results)
			{
				log("***** " + result.name + " (" + result.time + "ms) *****\n");
				log(result.result);
				log("\n");
			}
			
			runner.dispose();
			runner = null;
			
			log("TestF FINISHED");
			
			logField.visible = true;
		}

		private function postResults() : void
		{
			if(resultsGateway == "" || resultsGateway == null)
			{
				log("No result gateway found.\n");
				return;
			}
			
			log("Posting results to: " + resultsGateway + "\n");

			var variables : URLVariables = new URLVariables();
			variables.result = "";
			
			var results : Vector.<TestResult> = runner.getResults();
			
			for each(var result : TestResult in results)
			{
				variables.result += result.name + "|" + result.time + "|" + result.result + "__________";
			}
			
			variables.version = VERSION;
			
			variables.manufacturer = "xx";
			variables.model = "xx";
			
			try
			{
				NativeDeviceInfo.parse();
	
				variables.manufacturer = NativeDeviceProperties.PRODUCT_MANUFACTURER.value;
				variables.model = NativeDeviceProperties.PRODUCT_MODEL.value;
			}
			catch(e : Error)
			{
				log("Cannot find manufacturer and model \n");
			}
			
			var request : URLRequest = new URLRequest(resultsGateway);
			request.method = URLRequestMethod.POST;
			request.data = variables;
			
			var loader : URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			loader.load(request);
		}

		private function log(text : String) : void
		{
			logField.log(text);
		}
	}
}
