/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/8/12
 * Time: 11:37
 * To change this template use File | Settings | File Templates.
 */
package com.example.clicktargets {

    import au.com.brentoncrowley.interfaces.IClickTarget;
    import au.com.brentoncrowley.managers.commands.CommandManager;

    import au.com.brentoncrowley.managers.commands.CommandList;

    public class UndoListCommandTarget implements IClickTarget {

        private var _commandList:CommandList;

        public function UndoListCommandTarget(commandList:CommandList) {
            super();
            _commandList = commandList;
        }


        public function executeClick():void {
            _commandList.undoCurrentCommand();
        }
    }
}
