/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 12:16
 * To change this template use File | Settings | File Templates.
 */
package com.example.states {

    import au.com.brentoncrowley.state.states.AbstractState;

    import com.example.transitions.RevealStateBTransition;

    public class StateD extends AbstractState {

        public function StateD(id:String) {
            super(id);
        }

        override protected function defineTransitions():void {
            addStateTransitionTo(States.STATE_B, new HideStateDTransition(), new RevealStateBTransition());
            addStateTransitionTo(States.STATE_E, new HideStateDTransition(), new RevealStateETransition());
        }
    }
}
