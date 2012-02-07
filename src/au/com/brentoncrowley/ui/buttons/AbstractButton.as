/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 11:08
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.ui.buttons {

    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class AbstractButton extends Sprite {

        public function AbstractButton() {
            init();
        }

        // sets init values for internal use
        protected function init():void {

        }

        // enables the user to call this methods to init the state of the button. Useful for when it actions need to be performed once added to stage.
        public function initButton():void {

        }

        protected function activate():void {
            if (!this.hasEventListener(MouseEvent.CLICK)) this.addEventListener(MouseEvent.CLICK, onMouseEvent);
            if (!this.hasEventListener(MouseEvent.MOUSE_OVER)) this.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
            if (!this.hasEventListener(MouseEvent.MOUSE_OUT)) this.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
            this.buttonMode = true;

        }

        protected function deactivate():void {
            if (this.hasEventListener(MouseEvent.CLICK)) this.removeEventListener(MouseEvent.CLICK, onMouseEvent);
            if (this.hasEventListener(MouseEvent.MOUSE_OVER)) this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
            if (this.hasEventListener(MouseEvent.MOUSE_OUT)) this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
            this.buttonMode = false;
        }

        private function onMouseEvent(event:MouseEvent):void {
            switch (event.type) {
                case MouseEvent.CLICK:
                    onMouseClick();
                    break;
                case MouseEvent.MOUSE_OVER:
                    onMouseOver();
                    break;
                case MouseEvent.MOUSE_OUT:
                    onMouseOut();
                    break;
                default:
            }
        }

        protected function onMouseClick():void {
        }

        protected function onMouseOver():void {
        }

        protected function onMouseOut():void {
        }
    }
}
