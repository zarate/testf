package test.common
{

	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * @author Juan Delgado
	 */
	public class TestRunner extends Test implements ITest
	{
		private var tests : Vector.<ITest> = new Vector.<ITest>();
		
		private var results : Vector.<TestResult> = new Vector.<TestResult>();
		
		private var index : int;
		
		private var timer : Timer;
			
		public function addTest(testCase : ITest) : void
		{
			tests.push(testCase);
		}

		override public function run() : void
		{
			super.run();
			
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, delay);
			
			index = -1; // -1 cause nextTest() always adds up, so we start at 0
			nextTest();
		}

		override public function dispose() : void
		{
			tests = null;
			
			super.dispose();
		}

		override public function getName() : String
		{
			return "TestRunner";
		}
		
		override protected function stop() : void
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, delay);
			timer = null;
			
			super.stop();
		}

		public function getResults() : Vector.<TestResult>
		{
			return results;
		}

		private function nextTest() : void
		{
			index++;
			
			if(index < tests.length)
			{
				timer.start();
			}
			else
			{
				stop();
			}
		}
		
		private function delay(event : TimerEvent) : void
		{
			timer.stop();
			
			var testCase : ITest = tests[index];
			
			testCase.finishedSignal.addOnce(testFinised);
			testCase.updateSignal.add(testUpdate);

			addChild(Sprite(testCase));
			
			_updateSignal.dispatch(testCase, testCase.getName() + " started");
			
			try
			{
				testCase.run();
			}
			catch(e : Error)
			{
				// TODO: maybe we should print out the stack trace as well
				_updateSignal.dispatch(testCase, testCase.getName() + " crashed :/");
				testFinised(testCase);
			}
		}

		private function testUpdate(testCase : ITest, update : String) : void
		{
			_updateSignal.dispatch(testCase, update);
		}
		
		private function testFinised(testCase : ITest) : void
		{
			testCase.updateSignal.remove(testUpdate);
			removeChild(Sprite(testCase));

			results.push(testCase.getResult());
			
			_updateSignal.dispatch(testCase, testCase.getName() + " finished\n");
			
			testCase.dispose();
			
			nextTest();
		}		
	}
}
