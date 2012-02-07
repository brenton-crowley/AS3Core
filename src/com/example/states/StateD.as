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

        public function StateD() {
            super();
        }

        override protected function defineTransitions():void {
            addStateTransitionTo(StateB, new HideStateDTransition(), new RevealStateBTransition());
            addStateTransitionTo(StateE, new HideStateDTransition(), new RevealStateETransition());
        }
    }
}
