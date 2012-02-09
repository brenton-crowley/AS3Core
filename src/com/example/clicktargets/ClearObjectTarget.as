/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/9/12
 * Time: 11:41
 * To change this template use File | Settings | File Templates.
 */
package com.example.clicktargets {

    import au.com.brentoncrowley.interfaces.IClickTarget;
    import au.com.brentoncrowley.managers.commands.CommandList;

    public class ClearObjectTarget implements IClickTarget {
        private var _commandList:CommandList;

        public function ClearObjectTarget(commandList:CommandList) {
            _commandList = commandList;
        }

        public function executeClick():void {
            _commandList.dispose();
        }
    }
}
