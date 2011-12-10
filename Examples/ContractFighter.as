package  
{
	/**
	 * An experimental ContractFighter implementing Signal by Contract.
	 * @author Kevin Newman
	 */
	public class ContractFighter 
	{
		protected const punched:PunchSignal = new PunchSignal;
		protected const kicked:KickSignal = new KickSignal;
		
		public function addListener( listener:* ):void
		{
			if ( listener is IGetPunched ) {
				
				punched.addSlot(
					new PunchableSlot( listener as IGetPunched )
				);
			}
			if ( listener is IGetKicked ) {
				kicked.addSlot(
					new KickableSlot( listener as IGetKicked )
				);
			}
		}
		
		public function punch():void
		{
			punched.dispatch();
		}
		
		public function kick():void
		{
			kicked.dispatch();
		}
		
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

internal class KickSignal extends SignalTyped
{
	function KickSignal() {
		last = first = new KickableSlot( null );
	}
	
	internal function dispatch():void
	{
		var node:KickableSlot = first as KickableSlot;
		while ( node = (node.next as KickableSlot) ) {
			node.kickable.gotKicked();
		}
	}
}

// A custom slot that will store the runnable object.
internal class PunchableSlot extends SlotLite
{
	internal var punchable:IGetPunched;
	
	function PunchableSlot( punchable:IGetPunched )
	{
		this.punchable = punchable;
	}
}
internal class KickableSlot extends SlotLite
{
	internal var kickable:IGetKicked;
	
	function KickableSlot( kickable:IGetKicked )
	{
		this.kickable = kickable;
	}
}
