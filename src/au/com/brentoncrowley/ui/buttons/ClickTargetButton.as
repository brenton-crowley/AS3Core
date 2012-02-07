/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 11:16
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.ui.buttons {

    import au.com.brentoncrowley.interfaces.IClickTarget;

    public class ClickTargetButton extends AbstractButton {

        public var clickTarget:IClickTarget;

        public function ClickTargetButton() {
        }


        override public function initButton():void {
            super.initButton();

            activate();
        }

        override protected function onMouseClick():void {

            if(clickTarget) clickTarget.executeClick();

            super.onMouseClick();
        }
    }
}
