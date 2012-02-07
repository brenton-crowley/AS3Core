/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 12:16
 * To change this template use File | Settings | File Templates.
 */
package com.example.states {

    import au.com.brentoncrowley.state.states.AbstractState;

    public class StateC extends AbstractState {

        public function StateC() {
            super();
        }

        override protected function defineTransitions():void {
            addStateTransitionTo(StateD, new HideStateCTransition(), new RevealStateDTransition());
        }
    }
}
