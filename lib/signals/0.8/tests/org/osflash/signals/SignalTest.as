package org.osflash.signals
{
	import asunit.asserts.*;
	import asunit.framework.IAsync;

	import org.osflash.signals.events.GenericEvent;
	import org.osflash.signals.events.IEvent;

	import flash.display.Sprite;

	public class SignalTest
	{	
	    [Inject]
	    public var async:IAsync;
	    
		public var completed:Signal;
		
		[Before]
		public function setUp():void
		{
			completed = new Signal();
		}

		[After]
		public function tearDown():void
		{
			completed.removeAll();
			completed = null;
		}

		[Test]
		public function numListeners_is_0_after_creation():void
		{
			assertEquals(0, completed.numListeners);
		}
		
		//////
		
		[Test]
		public function dispatch_should_pass_event_to_listener_but_not_set_signal_or_target_properties():void
		{
			completed.add(async.add(checkGenericEvent, 10));
			completed.dispatch(new GenericEvent());
		}
		
		protected function checkGenericEvent(e:GenericEvent):void
		{
			assertNull('event.signal is not set by Signal', e.signal);
			assertNull('event.target is not set by Signal', e.target);
		}
		
		//////
		
		[Test]
		public function add_two_listeners_and_dispatch_should_call_both():void
		{
			completed.add(async.add(checkGenericEvent, 10));
			completed.add(async.add(checkGenericEvent, 10));
			completed.dispatch(new GenericEvent());
		}

		//////

		[Test]
		public function addOnce_and_dispatch_should_remove_listener_automatically():void
		{
			completed.addOnce(newEmptyHandler());
			completed.dispatch(new GenericEvent());
			assertEquals('there should be no listeners', 0, completed.numListeners);
		}
		
		//////
		
		[Test]
		public function add_listener_then_remove_then_dispatch_should_not_call_listener():void
		{
			completed.add(failIfCalled);
			completed.remove(failIfCalled);
			completed.dispatch(new GenericEvent());
		}
		
		private function failIfCalled(e:IEvent):void
		{
			fail('This event handler should not have been called.');
		}
		
		//////
		
		[Test]
		public function add_listener_then_remove_function_not_in_listeners_should_do_nothing():void
		{
			completed.add(newEmptyHandler());
			completed.remove(newEmptyHandler());
			assertEquals(1, completed.numListeners);
		}
		
		//////

		[Test]
		public function add_2_listeners_remove_2nd_then_dispatch_should_call_1st_not_2nd_listener():void
		{
			completed.add(async.add(checkGenericEvent, 10));
			completed.add(failIfCalled);
			completed.remove(failIfCalled);
			completed.dispatch(new GenericEvent());
		}
		//////
		[Test]
		public function add_2_listeners_should_yield_numListeners_of_2():void
		{
			completed.add(newEmptyHandler());
			completed.add(newEmptyHandler());
			assertEquals(2, completed.numListeners);
		}

		private function newEmptyHandler():Function
		{
			return function(e:*):void {};
		}
		

		//////
		[Test]
		public function add_2_listeners_then_remove_1_should_yield_numListeners_of_1():void
		{
			var firstFunc:Function = newEmptyHandler();
			completed.add(firstFunc);
			completed.add(newEmptyHandler());
			
			completed.remove(firstFunc);
			
			assertEquals(1, completed.numListeners);
		}
		
		[Test]
		public function add_2_listeners_then_removeAll_should_yield_numListeners_of_0():void
		{
			completed.add(newEmptyHandler());
			completed.add(newEmptyHandler());
			
			completed.removeAll();
			
			assertEquals(0, completed.numListeners);
		}
		
		[Test]
		public function add_same_listener_twice_should_only_add_it_once():void
		{
			var func:Function = newEmptyHandler();
			completed.add(func);
			completed.add(func);
			assertEquals(1, completed.numListeners);
		}
		
		[Test]
		public function addOnce_same_listener_twice_should_only_add_it_once():void
		{
			var func:Function = newEmptyHandler();
			completed.addOnce(func);
			completed.addOnce(func);
			assertEquals(1, completed.numListeners);
		}
		
		//////
		[Test]
		public function dispatch_non_IEvent_without_error():void
		{
			completed.addOnce(checkSprite);
			// Sprite doesn't have a target property,
			// so if the signal tried to set .target,
			// an error would be thrown and this test would fail.
			completed.dispatch(new Sprite());
		}
		
		private function checkSprite(sprite:Sprite):void
		{
			assertTrue(sprite is Sprite);
		}
		//////
		[Test]
		public function dispatch_2_listeners_1st_listener_removes_itself_then_2nd_listener_is_still_called():void
		{
			completed.add(selfRemover);
			// async.add verifies the second listener is called
			completed.add(async.add(newEmptyHandler(), 10));
			completed.dispatch();
		}
		
		private function selfRemover():void
		{
			completed.remove(selfRemover);
		}
		//////
		[Test]
		public function dispatch_2_listeners_1st_listener_removes_all_then_2nd_listener_is_still_called():void
		{
			completed.add(async.add(allRemover, 10));
			completed.add(async.add(newEmptyHandler(), 10));
			completed.dispatch();
		}
		
		//////
		[Test]
		public function can_use_anonymous_listeners():void
		{
			var listeners:Array = [];
			
			for ( var i:int = 0; i < 100;  i++ )
			{
				listeners.push(completed.add(function():void{}));
			}

			assertTrue("there should be 100 listeners", completed.numListeners == 100);

			for each( var fnt:Function in listeners )
			{
				completed.remove(fnt);
			}
			assertTrue("all anonymous listeners removed", completed.numListeners == 0);
		}
		
		//////
		[Test]
		public function can_use_anonymous_listeners_in_addOnce():void
		{
			var listeners:Array = [];
			
			for ( var i:int = 0; i < 100;  i++ )
			{
				listeners.push(completed.addOnce(function():void{}));
			}

			assertTrue("there should be 100 listeners", completed.numListeners == 100);

			for each( var fnt:Function in listeners )
			{
				completed.remove(fnt);
			}
			assertTrue("all anonymous listeners removed", completed.numListeners == 0);
		}
		
		private function allRemover():void
		{
			completed.removeAll();
		}
		//////
		[Test]
		public function adding_a_listener_during_dispatch_should_not_call_it():void
		{
			completed.add(async.add(addListenerDuringDispatch, 10));
			completed.dispatch(new GenericEvent());
		}
		
		private function addListenerDuringDispatch():void
		{
			completed.add(failIfCalled);
		}
		//////
		[Test]
		public function removed_listener_should_be_returned():void
		{
			var listener:Function = completed.add(function():void{});
			
			assertTrue("Listener is returned", listener == completed.remove(listener));
	}
	}
}
