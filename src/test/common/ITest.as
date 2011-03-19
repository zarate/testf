package test.common
{

	import org.osflash.signals.Signal;
	
	/**
	 * Main interface for the tests to implement.
	 * 
	 * @author Juan Delgado
	 */
	public interface ITest
	{
		/**
		 * Dispatched when the test has finished. Receives (ITest)
		 */
		function get finishedSignal() : Signal;
		
		/**
		 * Dispatched when the test sends a text update. Receives (ITest, String)
		 */		function get updateSignal() : Signal;
		
		/**
		 * Call it for the test to being.
		 */
		function run() : void;
		
		/**
		 * Call it to allow the test to clean up after run.
		 */
		function dispose() : void;
		
		/**
		 * @return The result of the test as a String.
		 */
		function getResult() : TestResult;
		
		/**
		 * @return The name of the test.
		 */
		function getName() : String;
		
		/**
		 * Some tests accept params to tweak how they work. This method
		 * would only store them for children to use.
		 * 
		 * @param params Vector of Strings to act as parameters.
		 */
		function setParams(params : Vector.<String>) : void;
	}
}
