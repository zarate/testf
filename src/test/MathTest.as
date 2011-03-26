package test
{
	import test.common.Test;

	import flash.utils.getTimer;

	/**
	 * @author Juan Delgado
	 */
	public class MathTest extends Test
	{
		private static const TOTAL_ITERATIONS : int = 10000000;
		
		override public function getName() : String
		{
			return "MathTest";
		}
		
		override public function run() : void
		{
			super.run()
			
			for(var i : int = 0; i < TOTAL_ITERATIONS; i++)
			{
				var a : Number = Math.random();
				var b : Number = Math.random();
				
				var c : Number = a + b;
			}
			
			stop();
		}
		
		override protected function stop() : void
		{
			// Overriding stop here so I can add the end time as part of the human
			// readable result before dispatching the _finishedSignal signal.
			
			endTime = getTimer();

			result = humanReadableResult = "Adding " + TOTAL_ITERATIONS + " numbers took " + (endTime - initTime) + " ms";
			
			_finishedSignal.dispatch(this);
		}
	}
}
