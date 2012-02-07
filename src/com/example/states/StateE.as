/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 12:16
 * To change this template use File | Settings | File Templates.
 */
package com.example.states {

    import au.com.brentoncrowley.managers.state.states.AbstractState;

    public class StateE extends AbstractState {
        public function StateE(id:String) {
            super(id);
        }


        override protected function defineTransitions():void {
            addStateTransitionTo(States.STATE_D, new HideStateETransition(), new RevealStateDTransition());
            addStateTransitionTo(States.STATE_F, new HideStateETransition(), new RevealStateFTransition());
        }
    }
}
