/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 15:52
 * To change this template use File | Settings | File Templates.
 */
package com.example.transitions {

    import au.com.brentoncrowley.managers.state.transitions.AbstractStateTransition;

    import com.greensock.TweenLite;

    public class RevealStateBTransition extends AbstractStateTransition{

        public function RevealStateBTransition() {
        }

        override public function startTransition():void {
            super.startTransition();
            TweenLite.delayedCall(4, completeTransition);
        }
    }
}
