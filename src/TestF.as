package
{

	import net.hires.debug.Stats;

	import nl.funkymonkey.android.deviceinfo.NativeDeviceInfo;
	import nl.funkymonkey.android.deviceinfo.NativeDeviceProperties;

	import test.common.ITest;
	import test.common.TestResult;
	import test.common.TestRunner;

	import ui.LogField;

	import xa.File;
	import xa.System;

	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.ui.Keyboard;
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
		
		private const FV_TESTS_XML : String = "fv_testsXml";
		
		private const FV_RESULTS_GATEWAY : String = "fv_resultsGateway";
		
		private const VERSION : String = "0.1";
		
		private const DEFAULT_TESTS_XML : String = "tests.xml";
		
		private const FLASH_VARS_FILENAME : String = "flashvars.conf";
		
		// Tests are defined in a XML, we need
		// to force the compiler to compile the tests classes.
		// Also RESULTS_GATEWAY is defined at compile time.
		// See wiki for more info:
		// TODO: create wiki!!
		
// ::forcedVars::
		
		public function TestF()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		private function addedToStage(event : Event) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			logField = new LogField();
			addChild(logField);
			
			logField.x = (stage.stageWidth - logField.width) >> 1;
			logField.y = (stage.stageHeight - logField.height) >> 1;

			log("Welcome to TestF (v" + VERSION + ")\n");
			log("This log field goes away when tests start and comes back when they finish.\n");
			
			readFlashVars();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			
			loadTests();
		}

		private function readFlashVars() : void
		{
			// Read the full explanation of what we do here in the wiki:
			// https://github.com/zarate/testf/wiki/Flashvars
			
			// Most likely your IDE is highlihgting an error because
			// it cannot find RESULTS_GATEWAY, right?
			// Read how we preprocess the code in the wiki:
			// https://github.com/zarate/testf/wiki/Building-from-sources
			testsXml = DEFAULT_TESTS_XML;
			resultsGateway = RESULTS_GATEWAY;
			
			try
			{	
				var flashVarsFilePath : String = flash.filesystem.File.applicationStorageDirectory.nativePath + xa.System.getSeparator() + FLASH_VARS_FILENAME;
				
				if(!xa.File.isFile(flashVarsFilePath))
				{
					flashVarsFilePath = "/sdcard" + flashVarsFilePath;
				}
				
				if(xa.File.isFile(flashVarsFilePath))
				{
					log("FlashVars file found: " + flashVarsFilePath);
					
					const fvLines : Array = xa.File.read(flashVarsFilePath).split("\n");
					
					for each(var line : String in fvLines)
					{
						if(line.charAt(0) != "#" && line.indexOf("=") != -1)
						{
							const bits : Array = line.split("=");
							
							switch(bits[0])
							{
								case FV_RESULTS_GATEWAY:
								
									resultsGateway = bits[1];
									
									log("Found gateway URL in local FlashVars: " + resultsGateway);
									break;
									
								case FV_TESTS_XML:
								
									testsXml = bits[1];
									
									log("Found tests xml URL in local FlashVars: " + testsXml);
									break;
							}
						}
					}
				}
				else
				{
					log("No FlashVars file found");
				}

			}
			catch(e : Error)
			{
				var flashVars : Object = LoaderInfo(root.loaderInfo).parameters;
				
				if(flashVars[FV_TESTS_XML] != null)
				{
					testsXml = flashVars[FV_TESTS_XML];
				}
				
				if(flashVars[FV_RESULTS_GATEWAY] != null)
				{
					resultsGateway = flashVars[FV_RESULTS_GATEWAY];
				}
			}
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
				const humanReadableResult : String = (result.humanReadableResult != "") ? result.humanReadableResult : result.result; 
				
				log("***** " + result.name + " (" + result.time + "ms) *****\n");
				log(humanReadableResult);
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

		private function keyDown(event : KeyboardEvent) : void
		{
			switch(event.keyCode)
			{
				case Keyboard.DOWN:
				
					logField.scrollDown();
					break;
					
				case Keyboard.UP:
					
					logField.scrollUp();
					break;
			}
		}

		private function log(text : String) : void
		{
			logField.log(text);
		}
	}
}
