/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 12:14
 * To change this template use File | Settings | File Templates.
 */
package com.example.states {

    import au.com.brentoncrowley.state.states.AbstractState;

    import com.example.transitions.RevealStateBTransition;

    public class StateA extends AbstractState {

        public function StateA(id:String) {
            super(id);
        }

        override protected function defineTransitions():void {
            addStateTransitionTo(States.STATE_B, new HideStateATransition(), new RevealStateBTransition());
        }



    }
}
