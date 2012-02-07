package au.com.dtdigital.core.utils {
	import flash.events.Event;	
	import flash.display.MovieClip;

	/**
	 * @author Michael Battle
	 */
	public class AbstractMovieClip extends MovieClip {

		public function AbstractMovieClip() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		
		protected function init():void {
			// override	
		}

		
		protected function dispose():void {
			// override	
		}

		private function onAddedToStage(event:Event):void {
			init();
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
		}

		
		private function onRemovedFromStage(event:Event):void {
			dispose();
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
	}
}
