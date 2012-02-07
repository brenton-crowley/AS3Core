/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 15:33
 * To change this template use File | Settings | File Templates.
 */
package com.example.states {

    import au.com.brentoncrowley.managers.state.transitions.AbstractStateTransition;

    public class RevealStateATransition extends AbstractStateTransition {

        public function RevealStateATransition() {
        }


        override public function startTransition():void {
            super.startTransition();
            completeTransition();
        }

    }
}
