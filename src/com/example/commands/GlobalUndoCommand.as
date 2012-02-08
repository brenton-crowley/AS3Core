/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/8/12
 * Time: 15:37
 * To change this template use File | Settings | File Templates.
 */
package com.example.commands {

    import au.com.brentoncrowley.managers.commands.CommandManager;
    import au.com.brentoncrowley.managers.commands.cmds.AbstractCommand;

    public class GlobalUndoCommand extends AbstractCommand {

        public function GlobalUndoCommand() {
        }

        override public function undo():void {
            CommandManager.instance.globalUndo();
        }
    }
}
