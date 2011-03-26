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
		 * The result of the test, for machine consumtion. Example: 4500.
		 */
		public var result : String;
		
		/**
		 * The result of the test, but for human consumption. Example: Total images: 4500.
		 */
		public var humanReadableResult : String;
		
		/**
		 * The name of the test.
		 */
		public var name : String;
		
		public function TestResult(name : String, time : int, result : String, humanReadableResult : String)
		{
			this.name = name;
			this.time = time;
			this.result = result;
			this.humanReadableResult = humanReadableResult;
		}
		
		public function toString() : String
		{
			return "TestResult [name: " + name + ", time: " + time + ", result: " + result + "]";
		}
	}
}
