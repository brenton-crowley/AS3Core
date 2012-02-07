/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 10:03
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.state {

    import au.com.brentoncrowley.interfaces.IState;
    import au.com.brentoncrowley.state.states.TransitionState;

    import flash.utils.Dictionary;

    import org.osflash.signals.Signal;

    public class StateManager {

        public static const ON_STATE_TRANSITION_START:String = "onStateTransitionStart";
        public static const ON_STATE_TRANSITION_OUT_COMPLETE:String = "onStateTransitionOutComplete";
        public static const ON_STATE_TRANSITION_COMPLETE:String = "onStateTransitionComplete";

        private static const TRANSITION_STATE:String = "transitionState";

        private static var _instance:StateManager = new StateManager();

        public var signal:Signal;

        private var isPreviousStateChange:Boolean;
        private var registeredStates:Dictionary;
        private var _state:IState;
        private var _targetState:IState;
        private var _previousState:IState;
        private var _stateHistory:Array;

        public function StateManager() {
            if (_instance) {
                throw new Error(this, "Cannot Instantiate, Class is a Singleton");
            }
            init();
        }

        public static function get instance():StateManager {
            return _instance;
        }

        private function init():void {
            _stateHistory = [];
            signal = new Signal(String);
            registeredStates = new Dictionary();
        }

        public function setDefaultState(defaultStateID:String = null):void {
            registerState(new TransitionState(TRANSITION_STATE));
            _state = getRegisteredState(defaultStateID);

            trace("============= [DEFAULT STATE] ============= ", _state);
            signal.dispatch(ON_STATE_TRANSITION_COMPLETE);
        }

        public function registerState(state:IState):void {
            registeredStates[state.id] = state;
            trace(this, "--> [Register State] ----> ", state.id);
        }

        public function getRegisteredState(stateID:String):IState {
            return registeredStates[stateID];
        }

        public function setPreviousState():void {
            if(_stateHistory.length == 0) return trace(this, "No Previous State Exists");
            isPreviousStateChange = true;
            setTargetState(IState(_stateHistory.shift()).id);
        }

        public function setTargetState(stateID:String):void {
            var incomingState:IState = getRegisteredState(stateID);

            if(!incomingState)                                  return trace(this, "targetState doesn't exist:", incomingState);
            if(_state == getRegisteredState(TRANSITION_STATE))  return trace(this, "state is currently in transition");
            if(instance._state == incomingState)                return trace(this, "state is already:", incomingState);
            if(!hasValidTransition(incomingState))              return;

            _previousState = _state;
            _state = getRegisteredState(TRANSITION_STATE);
            _targetState = incomingState;

            trace("<<<<<<<<<<<<< [PREVIOUS STATE] <<<<<<<<<<<< ", _previousState);
            trace("============= [CURRENT STATE] ============= ", _state);
            trace(">>>>>>>>>>>>> [TARGET STATE] >>>>>>>>>>>>>> ", getRegisteredState(stateID));

            startStateChange();
        }

        private function hasValidTransition(targetState:IState):Boolean {
            return _state.hasValidTransition(targetState);
        }

        private function startStateChange():void {
            trace("------------- [START STATE CHANGE] -------- ");
            signal.dispatch(ON_STATE_TRANSITION_START);
            transitionCurrentStateOut();
        }

        public function transitionCurrentStateOut():void {
            trace("------------- [TRANSITION OUT] --previous-- ", _previousState);
            _previousState.transitionCurrentStateOut();
        }

        public function transitionTargetStateIn():void {
            instance.signal.dispatch(ON_STATE_TRANSITION_OUT_COMPLETE);
            trace("------------- [TRANSITION IN] ---target---- ", _targetState);
            _previousState.transitionTargetStateIn();
        }

        public function completeStateChange():void {
            _state = instance._targetState;

            setStateHistory();

            trace("------------- [COMPLETE STATE CHANGE] ----- ");
            trace("************* [NEW STATE] ***************** ", _state);
//            trace("::::::::::::: [HISTORY] ::::::::::::::::::: ", _stateHistory);
            signal.dispatch(ON_STATE_TRANSITION_COMPLETE);
        }

        private function setStateHistory():void {
            if(!instance.isPreviousStateChange) instance._stateHistory.unshift(_previousState);
            else instance.isPreviousStateChange = false;
        }

        public function get state():IState {
            return _state;
        }

        public function get targetState():IState {
            return _targetState;
        }
    }
}
