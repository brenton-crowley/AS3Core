/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 10:27
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.managers.state.transitions {

    public class InstantStateTransition extends AbstractStateTransition {

        override public function startTransition():void {
            super.startTransition();
            this.completeTransition();
        }

    }
}
