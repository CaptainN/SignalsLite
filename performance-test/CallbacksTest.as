package
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
	
    import com.unfocus.signalslite.SignalLite;
	import com.unfocus.signalslite.SignalTyped;
	import com.unfocus.signalslite.SlotLite;
	
	import org.osflash.signals.*;
	
    [SWF(backgroundColor=0xEEEADB,frameRate=1000)]
	
    /**
    *   A test of various callback techniques
    *   @author Jackson Dunstan
    */
    public class CallbacksTest extends Sprite// implements Runnable
    {
        public var signal:Signal;
		public var signalLite:SignalLite;
		public var runnableSignal:RunnableSignal;
        public var funcs:Vector.<Function> = new Vector.<Function>();
        public var runnables:Vector.<Runnable> = new Vector.<Runnable>();
 
        public function CallbacksTest()
        {
            var logger:TextField = new TextField();
            logger.autoSize = TextFieldAutoSize.LEFT;
            addChild(logger);
 
            this.signal = new Signal();
			this.signalLite = new SignalLite();
			this.runnableSignal = new RunnableSignal();
 
            var i:int;
 
            const FUNC_CALL_REPS:int = 100000;
            const NUM_LISTENERS:int = 10;
            const EVENT_TYPE:String = "test";
            var runnable:Runnable = new MyRunnable();
            var func:Function = runnable.run;
 
            // Single call
 
            var beforeTime:int = getTimer();
            for (i = 0; i < FUNC_CALL_REPS; ++i)
            {
                func();
            }
            logger.appendText("Func call time: " + (getTimer()-beforeTime) + "\n");
 
            beforeTime = getTimer();
            for (i = 0; i < FUNC_CALL_REPS; ++i)
            {
                runnable.run();
            }
            logger.appendText("Runnable call time: " + (getTimer()-beforeTime) + "\n");
 
            addEventListener(EVENT_TYPE, onEvent0);
            beforeTime = getTimer();
            for (i = 0; i < FUNC_CALL_REPS; ++i)
            {
                dispatchEvent(new Event(EVENT_TYPE));
            }
            logger.appendText("Event (1 listener) time: " + (getTimer()-beforeTime) + "\n");
            removeEventListener(EVENT_TYPE, onEvent0);
 
            this.signal.add(onSignal0);
            beforeTime = getTimer();
            for (i = 0; i < FUNC_CALL_REPS; ++i)
            {
                this.signal.dispatch();
            }
            logger.appendText("Signal (1 listener) time: " + (getTimer()-beforeTime) + "\n");
            this.signal.remove(onSignal0);
			
            this.signalLite.add(onSignal0);
            beforeTime = getTimer();
            for (i = 0; i < FUNC_CALL_REPS; ++i)
            {
                this.signalLite.dispatch();
            }
            logger.appendText("SignalLite (1 listener) time: " + (getTimer()-beforeTime) + "\n");
            this.signalLite.remove(onSignal0);
			
			this.runnableSignal.addSlot(slot0);
            beforeTime = getTimer();
            for (i = 0; i < FUNC_CALL_REPS; ++i)
            {
                this.runnableSignal.dispatchRunnable();
            }
            logger.appendText("RunnableSignal (1 listener) time: " + (getTimer()-beforeTime) + "\n\n");
            this.runnableSignal.removeSlot(slot0);
			
            // Calling a list
 
            for (i = 0; i < NUM_LISTENERS; ++i)
            {
                this.funcs.push(func);
            }
            beforeTime = getTimer();
            for (i = 0; i < FUNC_CALL_REPS; ++i)
            {
                dispatchFuncs(this.funcs);
            }
            logger.appendText("Func call (" + NUM_LISTENERS + " listeners) time: " + (getTimer()-beforeTime) + "\n");
 
            for (i = 0; i < NUM_LISTENERS; ++i)
            {
                this.runnables.push(runnable);
            }
            beforeTime = getTimer();
            for (i = 0; i < FUNC_CALL_REPS; ++i)
            {
                dispatchRunnables(this.runnables);
            }
            logger.appendText("Runnable call (" + NUM_LISTENERS + " listeners) time: " + (getTimer()-beforeTime) + "\n");
 
            for (i = 0; i < NUM_LISTENERS; ++i)
            {
                addEventListener(EVENT_TYPE, this["onEvent"+i]);
            }
            beforeTime = getTimer();
            for (i = 0; i < FUNC_CALL_REPS; ++i)
            {
                dispatchEvent(new Event(EVENT_TYPE));
            }
            logger.appendText("Event (" + NUM_LISTENERS + " listeners) time: " + (getTimer()-beforeTime) + "\n");
 
            for (i = 0; i < NUM_LISTENERS; ++i)
            {
                this.signal.add(this["onSignal"+i]);
            }
			
            beforeTime = getTimer();
            for (i = 0; i < FUNC_CALL_REPS; ++i)
            {
                this.signal.dispatch();
            }
            logger.appendText("Signal (" + NUM_LISTENERS + " listeners) time: " + (getTimer() - beforeTime) + "\n");
			
            for (i = 0; i < NUM_LISTENERS; ++i)
            {
                this.signal.remove(this["onSignal"+i]);
            }
			
            for (i = 0; i < NUM_LISTENERS; ++i)
            {
                this.signalLite.add(this["onSignal"+i]);
            }
			
            beforeTime = getTimer();
            for (i = 0; i < FUNC_CALL_REPS; ++i)
            {
                this.signalLite.dispatch();
            }
            logger.appendText("SignalLite (" + NUM_LISTENERS + " listeners) time: " + (getTimer() - beforeTime) + "\n");
			
            for (i = 0; i < NUM_LISTENERS; ++i)
            {
                this.signalLite.remove(this["onSignal"+i]);
            }
			
			for (i = 0; i < NUM_LISTENERS; ++i)
            {
                this.runnableSignal.addSlot(this["slot"+i]);
            }
			
			beforeTime = getTimer();
            for (i = 0; i < FUNC_CALL_REPS; ++i)
            {
                this.runnableSignal.dispatchRunnable();
            }
            logger.appendText("RunnableSignal (" + NUM_LISTENERS + " listeners) time: " + (getTimer() - beforeTime) + "\n");
			
        }
 
        private function dispatchFuncs(funcs:Vector.<Function>): void
        {
            var len:int = funcs.length;
            for (var i:int = 0; i < len; ++i)
            {
                funcs[i]();
            }
        }
 
        private function dispatchRunnables(runnables:Vector.<Runnable>): void
        {
            var len:int = runnables.length;
            for (var i:int = 0; i < len; ++i)
            {
                Runnable(runnables[i]).run();
            }
        }
 
        private function onEvent0(ev:Event): void {}
        private function onEvent1(ev:Event): void {}
        private function onEvent2(ev:Event): void {}
        private function onEvent3(ev:Event): void {}
        private function onEvent4(ev:Event): void {}
        private function onEvent5(ev:Event): void {}
        private function onEvent6(ev:Event): void {}
        private function onEvent7(ev:Event): void {}
        private function onEvent8(ev:Event): void {}
        private function onEvent9(ev:Event): void {}
 
        private function onSignal0(): void {}
        private function onSignal1(): void {}
        private function onSignal2(): void {}
        private function onSignal3(): void {}
        private function onSignal4(): void {}
        private function onSignal5(): void {}
        private function onSignal6(): void {}
        private function onSignal7(): void {}
        private function onSignal8(): void {}
        private function onSignal9(): void {}
		
		private var slot0:RunnableSlot = new RunnableSlot();
		private var slot1:RunnableSlot = new RunnableSlot();
		private var slot2:RunnableSlot = new RunnableSlot();
		private var slot3:RunnableSlot = new RunnableSlot();
		private var slot4:RunnableSlot = new RunnableSlot();
		private var slot5:RunnableSlot = new RunnableSlot();
		private var slot6:RunnableSlot = new RunnableSlot();
		private var slot7:RunnableSlot = new RunnableSlot();
		private var slot8:RunnableSlot = new RunnableSlot();
		private var slot9:RunnableSlot = new RunnableSlot();
		
		public function run():void {}
    }
}

import com.unfocus.signalslite.*;

internal interface Runnable
{
    function run(): void;
}

internal class MyRunnable implements Runnable
{
    public function run(): void {}
}

// Example SignalTyped
internal class RunnableSignal extends SignalTyped
{
	public function RunnableSignal() {
		last = first = new RunnableSlot;
	}
	
	public function dispatchRunnable():void
	{
		var node:RunnableSlot = first as RunnableSlot;
		while ( node = (node.next as RunnableSlot) ) {
			node.runnable.run();
		}
	}
}

// A custom slot that will store the runnable object.
internal class RunnableSlot extends SlotLite {
	public var runnable:Runnable = new MyRunnable;
}
