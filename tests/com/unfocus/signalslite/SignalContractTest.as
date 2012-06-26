package com.unfocus.signalslite
{
	import org.flexunit.*;
	import org.flexunit.asserts.*;
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	public class SignalContractTest
	{
		private var signal:SignalTyped;
		
		private var slot:SlotLite = new SlotLite();
		private var slot2:SlotLite = new SlotLite();
		
		[Before]
		public function construct():void {
			signal = new PunchSignal();
		}
		
		[After]
		public function destruct():void {
			signal = null;
		}
		
		/*[Test( description = "should dispatch with instance of sprite.")]
		public function dispatch_with_argument():void
		{
			function checkSprite(spriteArg:Sprite):void {
				assertStrictlyEquals( sprite, spriteArg );
			}
			var sprite:Sprite = new Sprite();
			
			signal.add( checkSprite );
			signal.dispatch( sprite );
		}*/
		
		[Test( description = "should have no slots - length of 0")]
		public function no_slots():void {
			assertEquals( 0, signal.length );
		}
		
		[Test( description = "should have 1 slot - length of 1")]
		public function add_one_slot():void {
			signal.addSlot( slot );
			assertEquals(  1, signal.length );
		}
		
		[Test( description = "should `has` slot")]
		public function has_slot():void {
			signal.addSlot( slot );
			assertTrue( signal.hasSlot( slot ) );
		}
		
		[Test( description = "should have second and third slots")]
		public function has_second_and_third_listeners():void {
			signal.addSlot( slot );
			signal.addSlot( slot2 );
			var slot3:SlotLite = new SlotLite();
			signal.addSlot( slot3 );
			assertTrue( signal.hasSlot( slot2 ), signal.hasSlot( slot3 ) );
		}
		
		[Test( description = "should have 1 slot after adding 1 twice - length of 1")]
		public function add_one_listener_two_times():void {
			signal.addSlot( slot );
			signal.addSlot( slot );
			assertEquals( 1, signal.length );
		}
		
		[Test( description = "should have 2 slot - length of 2")]
		public function add_two_listeners():void
		{
			signal.addSlot( slot );
			signal.addSlot( slot2 );
			assertEquals( 2, signal.length );
		}
		
		/*[Test( description = "should dispatch twice (2 listeners)")]
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
		}*/
		
		[Test( description = "should have 0 slots after removing")]
		public function remove_slot():void
		{
			signal.addSlot( slot );
			signal.removeSlot( slot );
			
			assertEquals( 0, signal.length );
		}
		
		/*[Test( description = "should only dispatch slot once")]
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
		}*/
		
	}
}

import com.unfocus.signalslite.SlotLite;
import com.unfocus.signalslite.SignalTyped;

internal class PunchSignal extends SignalTyped
{
	function PunchSignal() {
		last = first = new PunchableSlot( null );
	}
	
	internal function dispatch():void
	{
		var node:PunchableSlot = first as PunchableSlot;
		while ( node = (node.next as PunchableSlot) ) {
			node.punchable.gotPunched();
		}
	}
	
}

internal class PunchableSlot extends SlotLite
{
	internal var punchable:IGetPunched;
	
	function PunchableSlot( punchable:IGetPunched )
	{
		this.punchable = punchable;
	}
}

internal interface IGetPunched 
{
	function gotPunched():void;
}
