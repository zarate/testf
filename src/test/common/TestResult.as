package test.common
{
	/**
	 * The result of a test.
	 * 
	 * @author Juan Delgado
	 */
	public class TestResult
	{
		/**
		 * Time in milliseconds that took the test to run.
		 */
		public var time : int;
		
		/**
		 * The result of the test.
		 */
		public var result : String;
		
		/**
		 * The name of the test.
		 */
		public var name : String;
		
		public function TestResult(name : String, time : int, result : String)
		{
			this.name = name;
			this.time = time;
			this.result = result;
		}
		
		public function toString() : String
		{
			return "TestResult [name: " + name + ", time: " + time + ", result: " + result + "]";
		}
	}
}
