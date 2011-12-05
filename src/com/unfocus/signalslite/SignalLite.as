package com.unfocus.signalslite
{
	/**
	 * A lite version of Robert Penner's AS3 Signals.
	 * @author Kevin Newman
	 */
	public class SignalLite
	{
		/**
		 * The empty first slot in a linked set.
		 */
		protected var first:SlotLite = new SlotLite;
		
		/**
		 * The last Slot is initially a reference to the same slot as the first.
		 */
		protected var last:SlotLite = first;
		
		/**
		 * Add a listener for this Signal.
		 * @param listener Function The function to be called when the signal fires.
		 */
		public function add( listener:Function ):void
		{
			if ( has( listener ) ) return;
			
			last.next = new SlotLite;
			last.next.prev = last;
			last = last.next;
			last.listener = listener;
		}
		
		/**
		 * Checks if the Signal contains a specific listener.
		 * @param	listener The listener to check for.
		 * @return Whether or not the listener is in the queue for this signal.
		 */
		public function has( listener:Function ):Boolean
		{
			if ( first === last ) return false;
			
			var node:SlotLite = first;
			while ( node.next )
			{
				node = node.next;
				if ( !node.next ) break;
				if ( node.next.listener === listener ) {
					return true;
				}
			}
			return false;
		}
		
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
		 * My mother told a listener once. Once.
		 * @param	listener
		 */
		public function once( listener:Function ):void
		{
			add( function oneTime( ...rest ):void {
				remove( oneTime );
				listener.apply( null, rest );
				listener = null;
			} );
		}
		
		/**
		 * Remove a listener for this Signal.
		 */
		public function remove( listener:Function ):void
		{
			if ( first === last ) return;
			
			var node:SlotLite = first;
			
			while ( node.next )
			{
				node = node.next;
				
				if ( node.listener === listener )
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
		
		/**
		 * Dispatches an event.
		 */
		public function dispatch( ...rest ):void
		{
			var node:SlotLite = first;
			while ( node = node.next ) {
				node.listener.apply( null, rest );
			}
		}
		
	}
}
