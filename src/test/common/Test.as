package test.common
{

	import org.osflash.signals.Signal;

	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	/**
	 * Base class for all the tests. Would take care of
	 * keeping track of time, holding parameters, and
	 * creating header/footer, etc.
	 * 
	 * @see test.common.events.TestEvent
	 * @see test.common.ITest
	 * 	 * @author Juan Delgado
	 */
	public class Test extends Sprite implements ITest
	{
		/**
		 * Holds the result of the test as a String. Extending
		 * classes should update it as required.
		 */
		protected var result : String = "";
		
		/**
		 * Time in milliseconds at which the test started.
		 */
		protected var initTime : int;
		
		/**
		 * Time in milliseconds at which the test finished.
		 */
		protected var endTime : int;
		
		/**
		 * Parameters for the test. Optional.
		 */
		protected var params : Vector.<String>;
		
		/**
		 * @inheritDoc
		 */
		protected var _finishedSignal : Signal = new Signal(ITest);
		
		/**
		 * @inheritDoc
		 */				protected var _updateSignal : Signal = new Signal(ITest, String);
		
		/**
		 * @inheritDoc
		 */		
		public function getResult() : TestResult
		{
			return new TestResult(getName(), endTime - initTime, result);
		}

		/**
		 * Extending classes must call super before executing their own code.
		 * @inheritDoc
		 */
		public function run() : void
		{
			initTime = getTimer();
		}
		
		/**
		 * @inheritDoc
		 */
		public function dispose() : void
		{
		}
		
		/**
		 * Extending classes must override.
		 * @inheritDoc
		 */
		public function getName() : String
		{
			throw "Please override";
			return null;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function setParams(params : Vector.<String>) : void
		{
			this.params = params;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get finishedSignal() : Signal
		{
			return _finishedSignal;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get updateSignal() : Signal
		{
			return _updateSignal;
		}
		
		/**
		 * Extending classes call stop() to stop the test. Calling stop
		 * would stop the timer, generate the result and dispatch an event.
		 * 
		 * Extending classes should call stop() after their own clean up.
		 * 
		 * @see test.common.events.TestEvent
		 */
		protected function stop() : void
		{
			endTime = getTimer();
			
			_finishedSignal.dispatch(this);
		}
	}
}
