package test
{
	import test.common.Test;

	/**
	 * @author Juan Delgado
	 */
	public class MathTest extends Test
	{
		private static const TOTAL_ITERATIONS : int = 10000000;
		
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
		
		override public function getName() : String
		{
			return "MathTest";
		}
	}
}
