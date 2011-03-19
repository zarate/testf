package
{
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Juan Delgado
	 */
	public class SignalsTest extends Sprite
	{
		public function SignalsTest()
		{
//			trace("Create the dispatcher");
//			var signalDispatcher : SignalDispatcher = new SignalDispatcher();
//			
//			trace("Subscribe to the signal");
//			signalDispatcher.signal.addOnce(signalCallback);
//			
//			trace("Call something that will trigger a signal");
//			signalDispatcher.doSomething();
			
			trace("Create the regular event dispatcher")
			var eventDispatcher : RegularEventDispatcher = new RegularEventDispatcher();
			
			trace("Subscribe to the event")
			eventDispatcher.addEventListener(RegularEventDispatcher.MY_EVENT, eventListener);
			
			trace("Call something that will trigger the event");
			eventDispatcher.doSomething();
			
			trace("I have finished");
		}

		private function signalCallback() : void
		{
			trace("Signal callback");
		}
		
		private function eventListener(event : Event) : void
		{
			trace("Event callback")
		}
	}
}
import org.osflash.signals.Signal;

import flash.events.Event;
import flash.events.EventDispatcher;

internal class SignalDispatcher
{
	public var signal : Signal = new Signal();
	
	public function doSomething() : void
	{
		trace("Now I dispatch the signal");
		signal.dispatch();
	}
}

internal class RegularEventDispatcher extends EventDispatcher
{
	public static const MY_EVENT : String = "myEvent";
	
	public function doSomething() : void
	{
		trace("Now I dispatch the event");
		dispatchEvent(new Event(MY_EVENT));
	}
}