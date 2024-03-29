/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 12:17
 * To change this template use File | Settings | File Templates.
 */
package com.example.states {

    import au.com.brentoncrowley.managers.state.states.AbstractState;

    public class StateF extends AbstractState {
        public function StateF(id:String) {
            super(id);
        }


        override protected function defineTransitions():void {
            addStateTransitionTo(States.STATE_A, new HideStateFTransition(), new RevealStateATransition());
            addStateTransitionTo(States.STATE_E, new HideStateFTransition(), new RevealStateETransition());
        }
    }
}
