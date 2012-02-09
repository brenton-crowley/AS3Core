/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/9/12
 * Time: 14:30
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.utils {

    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.KeyboardEvent;

    public class KeyTracker extends EventDispatcher {

        private var stage:Stage;
		private var keysDown:Object;
		private var triggerKeys:Array;

		/*
		 * @param stage:Stage - reference to stage
		 * @param triggerKeys:Array (optional) - array of keycodes, dispatches SELECT event if all triggerKeys are pressed
		 */
		 public function KeyTracker(stage:Stage, triggerKeys:Array = null) {
			this.stage = stage;
			this.triggerKeys = triggerKeys;
			this.keysDown = new Object();
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyPress);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyRelease);
		}

		/*
		 * check if key is currently down
		 *
		 * @param keyCode:uint - keycode of key to check
		 */
		public function isDown(keyCode:uint):Boolean {
			return Boolean(keyCode in this.keysDown);
		}

		private function onKeyPress(evt:KeyboardEvent):void {
			this.keysDown[evt.keyCode] = true;
			this.checkTriggerKeys();
		}

		private function onKeyRelease(evt:KeyboardEvent):void {
			delete this.keysDown[evt.keyCode];
		}

		private function checkTriggerKeys():void {
			if (this.triggerKeys != null) {
				var len:int = this.triggerKeys.length;
				var isTriggered:Boolean = true;
				for (var i:int = 0;i < len; i++) {
					if(!this.isDown(this.triggerKeys[i])) {
						isTriggered = false;
						break;
					}
				}
				if(isTriggered) {
					this.dispatchEvent(new Event(Event.SELECT));
				}
			}
		}
    }
}
