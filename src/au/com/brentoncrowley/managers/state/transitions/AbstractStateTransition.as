/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 10:25
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.managers.state.transitions {

    import au.com.brentoncrowley.interfaces.ITransition;

    import org.osflash.signals.Signal;

    public class AbstractStateTransition implements ITransition {

        public static const ON_STATE_TRANSITION_START:String = "onStateTransitionStart";
        public static const ON_STATE_TRANSITION_PAUSE:String = "onStateTransitionPause";
        public static const ON_STATE_TRANSITION_STOP:String = "onStateTransitionStop";
        public static const ON_STATE_TRANSITION_COMPLETE:String = "onStateTransitionComplete";

        private var _signal:Signal = new Signal(String);

        public function AbstractStateTransition() {

        }

        public function startTransition():void {
            trace("------------- [TRANSITION START] ---------- ", this);
            signal.dispatch(ON_STATE_TRANSITION_START);
        }

        public function pauseTransition():void {
            trace("------------- [TRANSITION PAUSE] ---------- ", this);
            signal.dispatch(ON_STATE_TRANSITION_PAUSE);
        }

        public function stopTransition():void {
            trace("------------- [TRANSITION STOP] ----------- ", this);
            signal.dispatch(ON_STATE_TRANSITION_STOP);
        }

        public function completeTransition():void {
            trace("------------- [TRANSITION COMPLETE] ------- ", this);
            signal.dispatch(ON_STATE_TRANSITION_COMPLETE);
        }

        public function get signal():Signal {
            return _signal;
        }

    }
}
