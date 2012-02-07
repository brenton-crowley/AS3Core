/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/7/12
 * Time: 11:13
 * To change this template use File | Settings | File Templates.
 */
package com.example.clicktargets {

    import au.com.brentoncrowley.interfaces.IClickTarget;
    import au.com.brentoncrowley.managers.state.StateManager;

    public class SetPreviousStateClick implements IClickTarget {

        public function executeClick():void {
            StateManager.instance.setPreviousState();
        }

    }
}
