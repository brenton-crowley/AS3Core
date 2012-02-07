/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 10:03
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.state {

    import au.com.brentoncrowley.interfaces.IState;
    import au.com.brentoncrowley.interfaces.IState;
    import au.com.brentoncrowley.state.states.DefaultState;
    import au.com.brentoncrowley.state.states.TransitionState;

    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    import org.osflash.signals.Signal;

    public class StateManager implements IState {

        public static const ON_STATE_TARGET_SET:String = "onStateTargetSet";
        public static const ON_STATE_TRANSITION_OUT_COMPLETE:String = "onStateTransitionOutComplete";
        public static const ON_STATE_TRANSITION_COMPLETE:String = "onStateTransitionComplete";

        public static var instance:StateManager = new StateManager();

        public var signal:Signal;

        private var registeredStates:Dictionary;
        private var _currentState:Class;
        private var _state:IState;
        private var _targetState:IState;
        private var _previousState:IState;
        private var _stateHistory:Array;
        private var isPreviousStateChange:Boolean;


        public function StateManager() {
            if (instance) {
                throw new Error(this, "Cannot Instantiate, Class is a Singleton");
            }
            init();
        }

        private function init():void {
            _stateHistory = [];
            this.signal = new Signal(String);
            this.registeredStates = new Dictionary();
        }

        public function setDefaultState(defaultState:Class = null):void {
            this.registerState(new TransitionState());
            this.registerState(new DefaultState());
            _state = this.getRegisteredState(defaultState ? defaultState : DefaultState);

            trace("============= [DEFAULT STATE] ============= ", _state);
            signal.dispatch(ON_STATE_TRANSITION_COMPLETE);
        }

        public function registerState(state:IState):void {
            var className:Class = getClassName(state);
            this.registeredStates[className] = state;
            trace(this, "--> [Register State] ----> ", className);
        }

        public function getRegisteredState(id:Class):IState {
            return this.registeredStates[id];
        }

        public function setPreviousState():void {
            if(_stateHistory.length == 0) return trace(this, "No Previous State Exists");
            isPreviousStateChange = true;
            setTargetState(getClassName(IState(_stateHistory.shift())));
        }

        public function setTargetState(id:Class):void {
            var incomingState:IState = getRegisteredState(id);

            if(!incomingState)                                  return trace(this, "targetState doesn't exist:", incomingState);
            if(_state == getRegisteredState(TransitionState))   return trace(this, "state is currently in transition");
            if(_state == incomingState)                         return trace(this, "state is already:", incomingState);
            if(!hasValidTransition(incomingState))              return;

            _previousState = _state;
            _state = getRegisteredState(TransitionState);
            _targetState = incomingState;
            
            startStateChange();

            trace("<<<<<<<<<<<<< [PREVIOUS STATE] <<<<<<<<<<<< ", _previousState);
            trace("============= [CURRENT STATE] ============= ", _state);
            trace(">>>>>>>>>>>>> [TARGET STATE] >>>>>>>>>>>>>> ", getRegisteredState(id));
            signal.dispatch(ON_STATE_TARGET_SET);
        }

        public function gotoPreviousState():void {
            
        }

        public function hasValidTransition(targetState:IState):Boolean {
            return _state.hasValidTransition(targetState);
        }

        public function startStateChange():void {
            trace("------------- [START STATE CHANGE] -------- ");
            transitionCurrentStateOut();
        }

        public function transitionCurrentStateOut():void {
            trace("------------- [TRANSITION OUT] --previous-- ", _previousState);

            _previousState.transitionCurrentStateOut();
        }

        public function transitionTargetStateIn():void {
            signal.dispatch(ON_STATE_TRANSITION_OUT_COMPLETE);
            trace("------------- [TRANSITION IN] ---target---- ", this.targetState);

            _previousState.transitionTargetStateIn();
        }

        public function completeStateChange():void {
            _state = _targetState;

            setStateHistory();

            trace("------------- [COMPLETE STATE CHANGE] ----- ");
            trace("************* [NEW STATE] ***************** ", _state);
//            trace("::::::::::::: [HISTORY] ::::::::::::::::::: ", _stateHistory);
            signal.dispatch(ON_STATE_TRANSITION_COMPLETE);
        }

        private function setStateHistory():void {
            if(!isPreviousStateChange)_stateHistory.unshift(_previousState);
            else isPreviousStateChange = false;
        }

        public function get currentState():Class {
            return getClassName(_state);
        }

        public function get targetState():IState {
            return _targetState;
        }

        public function getClassName(state:IState):Class {
            return Class(getDefinitionByName(getQualifiedClassName(state)));
        }

        public function get previousState():IState {
            return _previousState;
        }
    }
}
