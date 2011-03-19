package org.osflash.signals
{
	import asunit.asserts.*;
	import asunit.framework.IAsync;

	import org.osflash.signals.events.GenericEvent;

	public class DeluxeSignalWithCustomEventTest
	{	
	    [Inject]
	    public var async:IAsync;
	    
		public var messaged:DeluxeSignal;

		[Before]
		public function setUp():void
		{
			messaged = new DeluxeSignal(this, MessageEvent);
		}

		[After]
		public function tearDown():void
		{
			messaged.removeAll();
			messaged = null;
		}
		//////
		[Test]
		public function valueClasses_roundtrip_through_constructor():void
		{
			assertSame(MessageEvent, messaged.valueClasses[0]);
		}
		
		[Test]
		public function valueClasses_roundtrip_through_setter():void
		{
			messaged.valueClasses = [GenericEvent];
			assertSame(GenericEvent, messaged.valueClasses[0]);
			assertEquals(1, messaged.valueClasses.length);
		}

		[Test]
		public function valueClasses_setter_clones_the_array():void
		{
			var newValueClasses:Array = [GenericEvent];
			messaged.valueClasses = newValueClasses;
			assertNotSame(newValueClasses, messaged.valueClasses);
		}
		
		[Test]
		public function add_one_listener_and_dispatch():void
		{
			messaged.add(async.add(onMessage, 50));
			messaged.dispatch(new MessageEvent('ok'));
		}
		
		protected function onMessage(e:MessageEvent):void
		{
			assertEquals('source of the event', messaged, e.signal);
			assertEquals('target of the event', this, e.target);
			assertEquals('message value in the event', 'ok', e.message);
		}
		//////
		[Test(expects="ArgumentError")]
		public function dispatch_wrong_event_type_should_throw_ArgumentError():void
		{
			messaged.dispatch(new GenericEvent());
		}

		[Test(expects="ArgumentError")]
		public function signal_with_eventClass_adding_listener_without_args_should_throw_ArgumentError():void
		{
			messaged.add(function():void {});
		}
	}
}

import org.osflash.signals.events.GenericEvent;
import org.osflash.signals.events.IEvent;

////// PRIVATE CLASSES //////


class MessageEvent extends GenericEvent implements IEvent
{
	public var message:String;
	
	public function MessageEvent(message:String)
	{
		super();
		this.message = message;
	}
	
	override public function clone():IEvent
	{
		return new MessageEvent(message);
	}
	
}

