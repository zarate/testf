package org.osflash.signals.natives
{
	import asunit.asserts.*;
	import asunit.framework.IAsync;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;

	import org.osflash.signals.IPrioritySignal;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;

	public class NativeSignalTest
	{
	    [Inject]
	    public var async:IAsync;
	
		private var clicked:NativeSignal;
		private var sprite:IEventDispatcher;

		[Before]
		public function setUp():void
		{
			sprite = new Sprite();
			clicked = new NativeSignal(sprite, 'click', MouseEvent);
		}

		[After]
		public function tearDown():void
		{
			clicked.removeAll();
			clicked = null;
		}
		
		protected function verifyNoListeners():void
		{
			assertFalse('the EventDispatcher should not have listeners for the event', sprite.hasEventListener('click'));
			assertEquals('the NativeSignal should have no listeners', 0, clicked.numListeners);
		}
		//////
		public function testInstantiated():void
		{
			assertTrue("NativeSignal instantiated", clicked is NativeSignal);
			assertTrue('implements IPrioritySignal', clicked is IPrioritySignal);
			assertTrue('implements INativeDispatcher', clicked is INativeDispatcher);
			assertFalse('sprite has no click event listener to start', sprite.hasEventListener('click'));
			assertSame('target round-trips through constructor', sprite, clicked.target);
		}
		//////
		[Test]
		public function signal_add_then_EventDispatcher_dispatch_should_call_signal_listener():void
		{
			clicked.add( async.add(onClicked) );
			sprite.dispatchEvent(new MouseEvent('click'));
		}
		
		private function onClicked(e:MouseEvent):void
		{
			assertSame(sprite, e.currentTarget);
		}
		//////
		[Test]
		public function when_signal_adds_listener_then_target_should_have_listener():void
		{
			clicked.add(emptyHandler);
			assertEquals(1, clicked.numListeners);
			assertTrue(sprite.hasEventListener('click'));
		}
		
		private function emptyHandler(e:MouseEvent):void {}
		
		[Test]
		public function when_signal_adds_then_removes_listener_then_target_should_not_have_listeners():void
		{
			clicked.add(emptyHandler);
			clicked.remove(emptyHandler);
			verifyNoListeners();
		}
		
		[Test]
		public function when_signal_removes_all_listeners_then_target_should_not_have_listeners():void
		{
			clicked.add(emptyHandler);
			clicked.add( function(e:*):void {} );
			clicked.removeAll();
			verifyNoListeners();
		}
		
		[Test]
		public function when_addOnce_and_removeAll_listeners_then_target_should_not_have_listeners():void
		{
			clicked.addOnce(emptyHandler);
			clicked.addOnce( function(e:*):void {} );
			clicked.removeAll();
			verifyNoListeners();
		}
		//////
		
		[Test]
		public function add_listener_then_remove_function_not_in_listeners_should_do_nothing():void
		{
			clicked.add(newEmptyHandler());
			clicked.remove(newEmptyHandler());
			assertEquals(1, clicked.numListeners);
		}
		
		private function newEmptyHandler():Function
		{
			return function(e:*):void {};
		}
		
		//////
		[Test]
		public function addOnce_and_dispatch_from_signal_should_remove_listener_automatically():void
		{
			clicked.addOnce( async.add(emptyHandler) );
			clicked.dispatch(new MouseEvent('click'));
			verifyNoListeners();
		}
		//////
		[Test]
		public function addOnce_normal_priority_and_dispatch_from_EventDispatcher_should_remove_listener_automatically():void
		{
			var normalPriority:int = 0;
			clicked.addOnceWithPriority( async.add(emptyHandler) , normalPriority);
			sprite.dispatchEvent(new MouseEvent('click'));
			verifyNoListeners();
		}
		//////
		[Test]
		public function addOnce_lowest_priority_and_dispatch_from_EventDispatcher_should_remove_listener_automatically():void
		{
			var lowestPriority:int = int.MIN_VALUE;
			clicked.addOnceWithPriority( async.add(emptyHandler) , lowestPriority);
			sprite.dispatchEvent(new MouseEvent('click'));
			verifyNoListeners();
		}
		//////
		[Test]
		public function addOnce_highest_priority_and_dispatch_from_EventDispatcher_should_remove_listener_automatically():void
		{
			var highestPriority:int = int.MAX_VALUE;
			clicked.addOnceWithPriority( async.add(emptyHandler) , highestPriority);
			sprite.dispatchEvent(new MouseEvent('click'));
			verifyNoListeners();
		}
		//////
		[Test(expects="ArgumentError")]
		public function adding_listener_without_args_should_throw_ArgumentError():void
		{
			clicked.add(function():void {});
		}

		[Test(expects="ArgumentError")]
		public function adding_listener_with_two_args_should_throw_ArgumentError():void
		{
			clicked.add(function(a:*, b:*):void {});
		}

		[Test(expects="ArgumentError")]
		public function dispatch_wrong_event_class_should_throw_ArgumentError():void
		{
			clicked.dispatch(new Event('click'));
		}

		[Test(expects="ArgumentError")]
		public function dispatch_event_with_type_not_matching_signal_name_should_throw_ArgumentError():void
		{
			var wrongType:String = 'rollOver';
			clicked.dispatch(new MouseEvent(wrongType));
		}

		[Test(expects="ArgumentError")]
		public function dispatch_null_should_throw_ArgumentError():void
		{
			clicked.dispatch(null);
		}

		[Test]
		public function eventClass_defaults_to_native_Event_class():void
		{
			var added:NativeSignal = new NativeSignal(sprite, Event.ADDED);
			assertSame(Event, added.eventClass);
		}
		
		[Test]
		public function eventClass_roundtrips_through_constructor():void
		{
			var clicked:NativeSignal = new NativeSignal(sprite, MouseEvent.CLICK, MouseEvent);
			assertSame(MouseEvent, clicked.eventClass);
		}
		
		[Test]
		public function valueClasses_contains_only_eventClass():void
		{
			var clicked:NativeSignal = new NativeSignal(sprite, MouseEvent.CLICK, MouseEvent);
			assertEquals(1, clicked.valueClasses.length);
			assertSame(MouseEvent, clicked.valueClasses[0]);
			assertSame(clicked.eventClass, clicked.valueClasses[0]);
		}
		
		[Test]
		public function setting_eventClass_to_null_defaults_it_to_Event():void
		{
			clicked.eventClass = null;
			// This was causing a null exception: Issue #32.
			clicked.dispatch(new Event('click'));
			assertSame(Event, clicked.eventClass);
		}
		
		[Test]
		public function setting_valueClasses_to_multiple_item_array_puts_the_first_item_in_eventClass():void
		{
			// You wouldn't actually do this; you'd set eventClass instead.
			// But valueClasses is in the ISignal interface and thus needs to be tested.
			clicked.valueClasses = [TimerEvent, MouseEvent];
			assertSame(TimerEvent, clicked.eventClass);
		}	
		
		[Test]
		public function setting_valueClasses_to_empty_array_defaults_eventClass_to_Event():void
		{
			clicked.valueClasses = [];
			assertSame(Event, clicked.eventClass);
		}			

		[Test]
		public function setting_valueClasses_to_null_defaults_eventClass_to_Event():void
		{
			clicked.valueClasses = null;
			assertSame(Event, clicked.eventClass);
		}			
		
		//////
		// Captures Issue #5 - You can't addOnce to a signal from a function called by the same signal.
		[Test]
		public function addOnce_in_handler_and_dispatch_should_call_new_listener():void
		{
			clicked.addOnce( async.add(addOnceInHandler, 10) );
			clicked.dispatch(new MouseEvent('click'));
		}
		
		protected function addOnceInHandler(e:MouseEvent):void
		{
			clicked.addOnce( async.add(secondAddOnceListener, 10) );
			clicked.dispatch(new MouseEvent('click'));
		}
		
		protected function secondAddOnceListener(e:MouseEvent):void
		{
		}
		
		//////
		// Captures Issue #14
		[Test]
		public function addOnce_same_handler_in_handler_and_dispatch_should_call_it_again():void
		{
			assertEquals(0, clicked.numListeners);
			
			clicked.addOnce( onClickAddOnceAgain );
			
			assertEquals(1, clicked.numListeners);
			
			clicked.dispatch(new MouseEvent('click'));
		}
		
		protected function onClickAddOnceAgain(e:MouseEvent):void
		{
			assertEquals(0, clicked.numListeners);
			
			clicked.addOnce( onClickAddOnceAgain );
			
			assertEquals(1, clicked.numListeners);
		}
		
		
		//////
		[Test]
		public function can_use_anonymous_listeners():void
		{
			var listeners:Array = [];
			
			for ( var i:int = 0; i < 100;  i++ )
			{
				listeners.push(clicked.add(function(e:MouseEvent):void{}));
			}
			
			assertTrue("there should be 100 listeners", clicked.numListeners == 100);
			
			for each( var fnt:Function in listeners )
			{
				clicked.remove(fnt);
			}
			assertTrue("all anonymous listeners removed", clicked.numListeners == 0);
		}
		
		//////
		[Test]
		public function can_use_anonymous_listeners_in_addOnce():void
		{
			var listeners:Array = [];
			
			for ( var i:int = 0; i < 100;  i++ )
			{
				listeners.push(clicked.addOnce(function(e:MouseEvent):void{}));
			}
			
			assertTrue("there should be 100 listeners", clicked.numListeners == 100);
			
			for each( var fnt:Function in listeners )
			{
				clicked.remove(fnt);
			}
			assertTrue("all anonymous listeners removed", clicked.numListeners == 0);
		}
		
		//////
		[Test]
		public function removed_listener_should_be_returned():void
		{
			var listener:Function = clicked.add(function(e:MouseEvent):void{});
			
			assertTrue("Listener is returned", listener == clicked.remove(listener));
		}
		////// Captures Issue #24
		[Test]
		public function setting_target_to_a_different_object_should_remove_all_listeners_from_1st_target():void
		{
			clicked.add(emptyHandler);
			clicked.target = new EventDispatcher();
			assertFalse(sprite.hasEventListener('click'));
		}
		//////
		[Test]
		public function setting_target_to_the_same_object_should_not_remove_listeners():void
		{
			clicked.add(emptyHandler);
			var numListenersBefore:uint = clicked.numListeners;
			clicked.target = sprite;
			assertEquals(numListenersBefore, clicked.numListeners);
		}
	}
}
