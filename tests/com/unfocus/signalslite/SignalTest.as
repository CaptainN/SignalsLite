package com.unfocus.signalslite
{
	import org.flexunit.*;
	import org.flexunit.asserts.*;
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	public class SignalTest
	{
		private var signal:SignalLite;
		
		private function listener():void { }
		private function listener2():void { }
		
		[Before]
		public function construct():void {
			signal = new SignalLite();
		}
		
		[After]
		public function destruct():void {
			signal = null;
		}
		
		[Test( description = "should dispatch with instance of sprite.")]
		public function dispatch_with_argument():void
		{
			function checkSprite(spriteArg:Sprite):void {
				assertStrictlyEquals( sprite, spriteArg );
			}
			var sprite:Sprite = new Sprite();
			
			signal.add( checkSprite );
			signal.dispatch( sprite );
		}
		
		[Test( description = "should have no listeners - length of 0")]
		public function no_listeners():void {
			assertEquals( 0, signal.length );
		}
		
		[Test( description = "should have 1 listeners - length of 1")]
		public function add_one_listener():void {
			signal.add( listener );
			assertEquals(  1, signal.length );
		}
		
		[Test( description = "should `has` listener")]
		public function has_listener():void {
			signal.add( listener );
			assertTrue( signal.has( listener ) );
		}
		
		[Test( description = "should have second and third listeners")]
		public function has_second_and_third_listeners():void {
			signal.add( listener );
			signal.add( listener2 );
			function listener3():void { }
			signal.add( listener3 );
			assertTrue( signal.has( listener2 ), signal.has( listener3 ) );
		}
		
		[Test( description = "should have 1 listeners after adding 1 twice - length of 1")]
		public function add_one_listener_two_times():void {
			signal.add( listener );
			signal.add( listener );
			assertEquals( 1, signal.length );
		}
		
		[Test( description = "should have 2 listeners - length of 2")]
		public function add_two_listeners():void
		{
			signal.add( listener );
			signal.add( listener2 );
			assertEquals( 2, signal.length );
		}
		
		[Test( description = "should dispatch twice (2 listeners)")]
		public function two_listeners_receive_signal():void
		{
			var count:int;
			signal.add( function lis1():void {
				++count;
			});
			signal.add( function lis2():void {
				++count;
			});
			signal.dispatch();
			
			assertEquals( 2, count );
		}
		
		[Test( description = "should have 0 listeners after removing")]
		public function remove_listener():void
		{
			signal.add( listener );
			signal.remove( listener );
			
			assertEquals( 0, signal.length );
		}
		
		[Test( description = "should only dispatch listener once")]
		public function once_listener():void
		{
			var count:int;
			signal.once( function list():void {
				++count;
			});
			signal.dispatch();
			signal.dispatch();
			
			assertEquals( 1, count );
		}
		
		[Test( description = "once listener should receive dispatched argument")]
		public function once_listener_with_argument():void
		{
			var sprite:Sprite = new Sprite;
			signal.once( function list( spriteArg:Sprite):void {
				assertStrictlyEquals( sprite, spriteArg );
			});
			signal.dispatch( sprite );
		}
		
	}
}
