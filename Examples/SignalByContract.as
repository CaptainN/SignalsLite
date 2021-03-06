package  
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
	
	import flash.globalization.NumberFormatter;
	import flash.globalization.LocaleID;
	
	/**
	 * ...
	 * @author Kevin Newman
	 */
	[SWF(backgroundColor=0xEEEADB,frameRate=1000)]
	public class SignalByContract extends Sprite implements IGetKicked, IGetPunched
	{
		private var punchCount:int;
		private var kickCount:int;
		
		private var display:TextField;
		
		public function SignalByContract() 
		{
			var fighter:ContractFighter = new ContractFighter;
			
			display = new TextField();
			display.autoSize = TextFieldAutoSize.LEFT;
			addChild(display);
			
			fighter.addListener( this );
			
			fighter.kick();
			fighter.punch();
			fighter.kick();
			fighter.kick();
			fighter.kick();
			
			display.appendText( "Got punched " + punchCount + " time" + (1===punchCount?"":"s") + "!\n" );
			display.appendText( "Got kicked " + kickCount + " time" + (1 === kickCount?"":"s") + "!\n" );
			
			// performance
			const FUNC_CALL_REPS:int = 1000000;
			//const NUM_LISTENERS:int = 10;
			
			var afterTime:int;
			var beforeTime:int = getTimer();
			for (var i:int = 0; i < FUNC_CALL_REPS; ++i)
			{
				fighter.punch();
				fighter.kick();
			}
			afterTime = getTimer();
			
			var formatter:NumberFormatter = new NumberFormatter( LocaleID.DEFAULT );
			formatter.useGrouping = true;
			formatter.trailingZeros = false;
			
			display.appendText("Two Signals dispatched " + formatter.formatInt( FUNC_CALL_REPS ) + " times: (1 listener) time: " + (afterTime - beforeTime) + "\n");
			display.appendText( "Got punched " + formatter.formatInt( punchCount ) + " time" + (1===punchCount?"":"s") + "!\n" );
			display.appendText( "Got kicked " + formatter.formatInt( kickCount ) + " time" + (1 === kickCount?"":"s") + "!\n" );
		}
		
		public function gotPunched():void
		{
			++punchCount;
		}
		
		public function gotKicked():void
		{
			++kickCount;
		}
		
	}
}
