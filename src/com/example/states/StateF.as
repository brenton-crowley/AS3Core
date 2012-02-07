/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 12:17
 * To change this template use File | Settings | File Templates.
 */
package com.example.states {

    import au.com.brentoncrowley.state.states.AbstractState;

    public class StateF extends AbstractState {
        public function StateF() {
            super();
        }


        override protected function defineTransitions():void {
            addStateTransitionTo(StateA, new HideStateFTransition(), new RevealStateATransition());
            addStateTransitionTo(StateE, new HideStateFTransition(), new RevealStateETransition());
        }
    }
}
