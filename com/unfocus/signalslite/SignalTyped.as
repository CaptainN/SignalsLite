package com.unfocus.signalslite
{
	/**
	 * Experimental support for typed signal dispatching. Provides a way to implement compile time listener signature checking and dispatches very quickly.
	 * <p>This class must be subclassed, with the dispatch method implemented, along with a custom SlotLite.</p>
	 * @author Kevin Newman
	 */
	public class SignalTyped
	{
		/**
		 * This should be set by the subclass, and be set to an instance of the type specific slot.
		 */
		protected var first:SlotLite; // empty slot
		
		/**
		 * The last Slot should initially reference the same slot as the first slot.
		 */
		protected var last:SlotLite;
		
		/**
		 * Gets the number of listeners.
		 */
		public function get length():int
		{
			var count:int;
			
			var node:SlotLite = first;
			while ( node = node.next ) {
				++count;
			}
			
			return count;
		}
		
		/**
		 * Add a slot to the signal queue.
		 * @param	slot
		 */
		public function addSlot( slot:SlotLite ):void
		{
			if ( hasSlot( slot ) ) return;
			
			last.next = slot;
			last.next.prev = last;
			last = last.next;
		}
		
		/**
		 * Checks to see if a specific slot has been added to the queue.
		 * @param	slot The slot instance to check for.
		 * @return Whether or not the slot is in the queue.
		 */
		public function hasSlot( slot:SlotLite ):Boolean
		{
			if ( first === last ) return false;
			
			var node:SlotLite = first;
			while ( node.next )
			{
				node = node.next;
				if ( !node.next ) break;
				if ( node.next === slot ) {
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Removes a slot from the SignalLite's queue.
		 * @param	slot
		 */
		public function removeSlot( slot:SlotLite ):void
		{
			if ( first === last ) return;
			
			var node:SlotLite = first;
			while ( node.next )
			{
				node = node.next;
				if ( node === slot )
				{
					node.prev.next = node.next;
					if ( node.next )
						node.next.prev = node.prev;
					if ( last === node )
						last = node.prev;
					break;
				}
			}
			
			if ( first === last ) {
				first.next = null;
			}
		}
		
	}
}
