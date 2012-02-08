/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/8/12
 * Time: 9:40
 * To change this template use File | Settings | File Templates.
 */
package com.example.commands {

    import au.com.brentoncrowley.interfaces.ICommandObject;
    import au.com.brentoncrowley.managers.commands.CommandManager;
    import au.com.brentoncrowley.managers.commands.cmds.AbstractCommand;

    public class FirstCommand extends AbstractCommand{

        private static var idCounter:Number = 0;

        private var _commandList:ICommandObject;

        public function FirstCommand(commandList:ICommandObject) {
            _commandList = commandList;
            idCounter++;
        }

        override public function execute():void {
//            trace("ID:", idCounter);
//            CommandManager.instance.executeListCommand(_commandList);
        }


        override public function undo():void {
//            trace(this, "IDCOUNTER:", idCounter, "UNDO - ID:", id);
        }
    }
}
