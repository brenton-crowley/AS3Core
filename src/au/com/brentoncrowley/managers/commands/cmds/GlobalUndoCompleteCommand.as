/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/8/12
 * Time: 15:43
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.managers.commands.cmds {

    import au.com.brentoncrowley.managers.commands.CommandManager;

    public class GlobalUndoCompleteCommand extends AbstractCommand{

        public function GlobalUndoCompleteCommand() {
        }

        override public function undo():void {
            CommandManager.instance.signal.dispatch(CommandManager.ON_GLOBAL_UNDO_COMPLETE);
        }
    }
}
