package au.com.dtdigital.core.dtdbug {
	
	import flash.events.Event;	
	import flash.utils.Timer;	
	import flash.text.TextFormat;	
	import flash.text.TextField;
	import flash.events.TimerEvent;	

	/**
	 * @author JCope
	 */
	public class FPSDisplay extends TextField {
		
		private static const TIMER_DELAY:Number = 1000;
		private static const FORMAT_FONT:String = "Verdana";
		private static const FPS_PREFIX:String = "FPS: ";

		private var frames:uint = 0;
		private var format:TextFormat = new TextFormat();
		private var timer:Timer;		

		public function FPSDisplay() {
			this.timer = new Timer(TIMER_DELAY);
			this.format.font = FORMAT_FONT;
			this.defaultTextFormat = format;
			this.text = FPS_PREFIX;
			this.width = 60;
			this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);           
		}

		private function onAddedToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage); 
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemoveFromStage); 
			this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
			this.timer.addEventListener(TimerEvent.TIMER, tick);
			this.timer.start();
		}

		private function onRemoveFromStage(event:Event):void {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemoveFromStage); 
			this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage); 
			this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
			this.timer.removeEventListener(TimerEvent.TIMER, tick);
			this.timer.stop();			
		}

		private function onEnterFrame(event:Event):void {												
			this.frames++;
		}

		private function tick(event:TimerEvent):void {
			this.text = FPS_PREFIX + this.frames;
			this.frames = 0;            
		}
	}
}
