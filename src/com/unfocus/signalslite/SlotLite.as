package com.unfocus.signalslite
{
	/**
	 * Holds the listener to be called by the Signal (and provides properties for a simple linked list).
	 * @author Kevin Newman
	 */
	public class SlotLite {
		public var next:SlotLite;
		public var prev:SlotLite;
		public var listener:Function;
	}

}