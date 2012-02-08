/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/8/12
 * Time: 13:15
 * To change this template use File | Settings | File Templates.
 */
package com.example.clicktargets {

    import au.com.brentoncrowley.interfaces.IClickTarget;
    import au.com.brentoncrowley.interfaces.ICommand;
    import au.com.brentoncrowley.managers.commands.CommandSlot;

    public class RemoteButtonClick implements IClickTarget {

        private var _command:ICommand;
        private var _commandSlot:CommandSlot;

        public function RemoteButtonClick(command:ICommand, commandSlot:CommandSlot)  {
            _command = command;
            _commandSlot = commandSlot;
        }

        public function executeClick():void {
            trace(this, _command);
            _commandSlot.setCommand(_command);
            _commandSlot.execute();
        }
    }
}
