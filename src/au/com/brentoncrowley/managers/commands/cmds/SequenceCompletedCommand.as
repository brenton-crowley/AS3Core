/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/8/12
 * Time: 10:09
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.managers.commands.cmds {

    import au.com.brentoncrowley.interfaces.ICommandObject;
    import au.com.brentoncrowley.managers.commands.CommandManager;

    public class SequenceCompletedCommand extends AbstractCommand {

        private var _object:ICommandObject;
        private var isComplete:Boolean;

        public function SequenceCompletedCommand(object:ICommandObject) {
            _object = object;
        }

        override public function execute():void {
            if(!isComplete){
                trace("------------- > [SEQUENCE COMPLETE FOR]:", _object);
                isComplete = true;
                CommandManager.instance.signal.dispatch(CommandManager.ON_SEQUENCE_COMPLETE, _object);
            }else{
                trace("------------- > [ERROR - END REACHED]: - Cannot execute any more commands on", _object);
            }

        }


        override public function undo():void {
            CommandManager.instance.undoListCommand(_object);
            isComplete = false;
        }
    }
}
