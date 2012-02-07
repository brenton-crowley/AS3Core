/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 11:25
 * To change this template use File | Settings | File Templates.
 */
package com.example.clicktargets {

    import au.com.brentoncrowley.interfaces.IClickTarget;
    import au.com.brentoncrowley.managers.state.StateManager;

    public class SetStateClickTarget implements IClickTarget{
        
        private var targetState:String;

        public function SetStateClickTarget(targetStateID:String) {
            this.targetState = targetStateID;
        }

        public function executeClick():void {
            StateManager.instance.setTargetState(targetState);
        }
    }
}
