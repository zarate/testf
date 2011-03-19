package test
{
	import flash.system.Capabilities;
	import test.common.Test;
	/**
	 * @author Juan Delgado
	 */
	public class SystemTest extends Test
	{
		override public function run() : void
		{
			super.run();
			
			result += "manufacturer: " + Capabilities.manufacturer + "\n";
			
			stop();
		}

		override public function getName() : String
		{
			return "SystemTest";
		}
	}
}