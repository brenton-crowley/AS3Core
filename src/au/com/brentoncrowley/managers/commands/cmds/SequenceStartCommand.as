/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/8/12
 * Time: 10:31
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.managers.commands.cmds {

    import au.com.brentoncrowley.interfaces.ICommandObject;
    import au.com.brentoncrowley.managers.commands.CommandManager;

    public class SequenceStartCommand extends AbstractCommand {

        private var _object:ICommandObject;
        private var hasStarted:Boolean;

        public function SequenceStartCommand(object:ICommandObject) {
            _object = object;
        }

        override public function execute():void {
            hasStarted = true;
            CommandManager.instance.signal.dispatch(CommandManager.ON_SEQUENCE_START, _object);
            CommandManager.instance.executeListCommand(_object);
        }


        override public function undo():void {
            if(hasStarted){
                trace("------------- > [SEQUENCE START REACHED] for:", _object);
                hasStarted = false;
                CommandManager.instance.signal.dispatch(CommandManager.ON_SEQUENCE_UNDO_TO_START_REACHED, _object);
            }else{
                trace("------------- > [ERROR - START REACHED]: - Cannot undo any more commands on", _object);
            }

        }
    }
}
