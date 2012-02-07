/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 12:16
 * To change this template use File | Settings | File Templates.
 */
package com.example.states {

    import au.com.brentoncrowley.state.states.AbstractState;

    public class StateB extends AbstractState {
        public function StateB() {
            super();
        }


        override protected function defineTransitions():void {
            addStateTransitionTo(StateA, new HideStateBTransition(), new RevealStateATransition());
            addStateTransitionTo(StateC, new HideStateBTransition(), new RevealStateCTransition());
        }
    }
}
