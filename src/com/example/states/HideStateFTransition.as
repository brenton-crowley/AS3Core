/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 17:35
 * To change this template use File | Settings | File Templates.
 */
package com.example.states {

    import au.com.brentoncrowley.managers.state.transitions.AbstractStateTransition;

    public class HideStateFTransition extends AbstractStateTransition{

        public function HideStateFTransition() {
        }

        override public function startTransition():void {
            super.startTransition();
            completeTransition();
        }
    }
}
