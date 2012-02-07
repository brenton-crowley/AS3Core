/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 10:12
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.state.states {

    import au.com.brentoncrowley.interfaces.IState;
    import au.com.brentoncrowley.interfaces.ITransition;
    import au.com.brentoncrowley.state.StateManager;
    import au.com.brentoncrowley.state.transitions.AbstractStateTransition;
    import au.com.brentoncrowley.state.transitions.InstantStateTransition;

    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getQualifiedSuperclassName;

    public class AbstractState implements IState {

        protected var inTransition:ITransition;
        protected var outTransition:ITransition;
        protected var transition:ITransition;
        protected var stateManager:StateManager;
        protected var inTransitions:Dictionary;
        protected var outTransitions:Dictionary;

        public function AbstractState() {
            inTransitions = new Dictionary();
            inTransitions.name = "inTransitions";
            outTransitions = new Dictionary();
            outTransitions.name = "outTransitions";
            stateManager = StateManager.instance;

            defineTransitions();
        }

        protected function defineTransitions():void {
//            addInTransitions();
//            addOutTransitions();
        }

        protected function addStateTransitionTo(targetState:Class, outTransition:AbstractStateTransition,  inTransition:AbstractStateTransition):void {
//            trace(this, "(targetState is getClassName(this):",(targetState == getClassName(this)), targetState, getClassName(this));
            if((targetState == getClassName(this))) throw new Error("*** INVALID TRANSITION IN *** " + this + " REASON: Cannot transition to itself. The state provided in the targetState parameter is most likely equal to this state. THIS: " + getClassName(this) + " TARGET: " + targetState);
            addOutTransitionTo(targetState, outTransition);
            addInTransitionTo(targetState, inTransition);
        }

        private function addInTransitionTo(targetState:Class, transition:AbstractStateTransition):void {
            addTransition(this.inTransitions, targetState, transition);
        }

        private function addOutTransitionTo(targetState:Class, transition:AbstractStateTransition):void {
            addTransition(this.outTransitions, targetState, transition);
        }

        private function addTransition(transitions:Dictionary, state:Class, transition:AbstractStateTransition):void {
            var superStateClass:Class = Class(getDefinitionByName(getQualifiedSuperclassName(state)));
            var superTransitionClass:Class = Class(getDefinitionByName(getQualifiedSuperclassName(transition)));
            //TODO Create a validate method that recursively loops to the desired super class
            if ((superStateClass != AbstractState) && (superTransitionClass != AbstractStateTransition)) {
                throw new Error(state + " Must extend " + superStateClass + " AND " + transition + " must extend " + superTransitionClass);
            } else {
                if (!transitions[state]) {
                    transitions[state] = transition;
                    //trace(this, "[ADD TRANSITION]", "When targetState is:", state, "transition:", transition, " extends:", getDefinitionByName(getQualifiedSuperclassName(state)));
                } else {
                    throw new Error(this + " " + transitions.name + " Already Contains a transition on this state - TRANSITION: " + transition);
                }
            }
        }

        private function onStateTransitionSignalUpdate(updateType:String):void {
            switch (updateType) {
                case AbstractStateTransition.ON_STATE_TRANSITION_START:
                    break;
                case AbstractStateTransition.ON_STATE_TRANSITION_PAUSE:
                    break;
                case AbstractStateTransition.ON_STATE_TRANSITION_STOP:
                    break;
                case AbstractStateTransition.ON_STATE_TRANSITION_COMPLETE:

                    updateTransition();

                    break;
                default:
            }
        }

        private function updateTransition():void {
            switch (this.transition) {
                case this.outTransition:
//						trace(this, "updateTransion: OUT", this.outTransition, this.transition, (this.outTransition == this.transition));
                    this.outTransition = removeTransition();
                    //transitionTargetStateIn();
                    this.stateManager.transitionTargetStateIn();
                    break;
                case this.inTransition:
//						trace(this, "updateTransion: IN", this.inTransition, this.transition, (this.inTransition == this.transition));
                    this.inTransition = removeTransition();
                    this.completeStateChange();
                    break;
                default:
            }
        }

        //only used in state Manager
        public final function startStateChange():void {
        }

        public function transitionCurrentStateOut():void {
//			trace(this, "transitionPreviousStateOut to targetState");
            this.transition = getOutTransition(this.stateManager.targetState);
            initTransition();
            this.outTransition = this.transition;
            this.transition.startTransition();
        }

        public function transitionTargetStateIn():void {
//			trace(this, "transitionTargetStateIn from previousState:", this.stateManager.previousState);
            this.transition = getInTransition(this.stateManager.targetState);
            initTransition();
            this.inTransition = this.transition;
            this.transition.startTransition();
        }

        private function getInTransition(state:IState):ITransition {
            return lookUpTransition(this.inTransitions, state);
        }

        private function getOutTransition(state:IState):ITransition {
            return lookUpTransition(this.outTransitions, state);
        }


        public function completeStateChange():void {
            stateManager.completeStateChange();
        }

        private function initTransition():void {

            transition.signal.add(onStateTransitionSignalUpdate);

        }

        private function removeTransition():ITransition {
            transition.signal.removeAll();
            return null;
        }


        protected function getClassName(state:IState):Class {
            return Class(getDefinitionByName(getQualifiedClassName(state)));
        }

        private function lookUpTransition(transitions:Dictionary, state:IState):ITransition {
            var transition:ITransition = ITransition(transitions[getClassName(state)]);
            if (transition) {
                return transition;
            } else {

//                trace("---> *** WARNING *** <---" + this + " Could not find " + getClassName(state) + " in [this." + transitions.name + "] instance. Check to see if the transition was defined in the 'definedTransitions()' method of " + this);
//                trace("---> " + InstantStateTransition + "was used in place and has been set");
//                transition = new InstantStateTransition();
//                transitions[getClassName(state)] = transition;
                return null;
            }

        }

        public function hasValidTransition(targetState:IState):Boolean {
            var hasValidInTransition:Boolean = (getInTransition(targetState) != null);
            var hasValidOutTransition:Boolean = (getOutTransition(targetState) != null);
            var hasValidTransition:Boolean = (hasValidInTransition && hasValidOutTransition);
            if(hasValidTransition) return hasValidTransition;
            else throw new Error(getInvalidTransitionErrorMessage(hasValidInTransition, hasValidOutTransition, targetState));
        }

        private function getInvalidTransitionErrorMessage(hasValidInTransition:Boolean, hasValidOutTransition:Boolean, targetState:IState):String {
            var message:String = "***************** INVALID TRANSITION ***************** \r";
            message += "The requested state change could not be completed since no valid transition exists \r";
            message += "---------- > [ATTEMPTED TRANSITION]: " + this + " to " + targetState + "\r";
            if(!hasValidOutTransition) message += "---------- > [NO OUT TRANSITION]: You must define an OUT transition for " + this + " in " + this + "\r";
            if(!hasValidInTransition) message += "---------- > [NO IN TRANSITION]: You must define an IN transition for " + targetState + " in " + this + "\r";

            message += "---------- > [EXAMPLE]: addStateTransitionTo(" + String(getClassName(targetState)).substring(String(getClassName(targetState)).indexOf(" ") + 1, String(getClassName(targetState)).lastIndexOf("]"))  + ", new defineOutTransition(), new defineInTransition()); \r";
            message += "---------- > This should be placed in " + this + " inside the overridden 'defineTransition() method'\r";
            return message;
        }
    }

}
