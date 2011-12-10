package  
{
	import com.unfocus.signalslite.SignalLite;
	import org.osflash.signals.Signal;
	
	/**
	 * Example dispatching with SignalLite.
	 * @author 
	 */
	public class LiteFighter
	{
		public const punched:SignalLite = new SignalLite();
		public const kicked:SignalLite = new SignalLite();
		
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
