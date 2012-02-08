/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/8/12
 * Time: 14:48
 * To change this template use File | Settings | File Templates.
 */
package com.example.commands {

    import au.com.brentoncrowley.managers.commands.CommandSlot;
    import au.com.brentoncrowley.managers.commands.cmds.AbstractCommand;

    public class UndoSlotCommand extends AbstractCommand{

        private var _commandSlot:CommandSlot;

        public function UndoSlotCommand(commandSlot:CommandSlot) {
            _commandSlot = commandSlot;
        }

        override public function undo():void {
            _commandSlot.undo();
        }
    }
}
