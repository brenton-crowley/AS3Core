/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 10:51
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.ui.display {

    import au.com.brentoncrowley.ns.externalMode;
    import au.com.brentoncrowley.ns.localMode;

    import flash.display.Sprite;
    import flash.events.Event;

    use namespace localMode;

    use namespace externalMode;

    public class AbstractMain extends Sprite{

        protected var mode:Namespace;

        public function AbstractMain() {
            mode = this.stage ? localMode : externalMode;
            if(mode == externalMode) addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            else mode::modeInit();
        }

        private function onAddedToStage(event:Event):void {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            mode::modeInit();

        }

        localMode function modeInit():void {
            init();
        }

        externalMode function modeInit():void {
            init();
        }

        protected function init():void {
            trace(this, "MODE:", mode);
        }
    }
}
