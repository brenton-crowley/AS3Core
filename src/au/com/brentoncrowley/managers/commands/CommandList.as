/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/8/12
 * Time: 9:10
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.managers.commands {

    import au.com.brentoncrowley.interfaces.ICommandObject;
    import au.com.brentoncrowley.managers.commands.CommandManager;

    public class CommandList implements ICommandObject {

        private var _commandSequence:Array;

        public function CommandList() {

            CommandManager.instance.signal.add(onCommandManagerSignalUpdate);
        }

        public function onCommandManagerSignalUpdate(updateType:String, object:ICommandObject = null):void {
            switch (updateType) {
                case CommandManager.ON_SEQUENCE_UNDO_TO_START_REACHED:
                    break;
                case CommandManager.ON_SEQUENCE_COMPLETE:
                    if(object && object == this){
                        }
                    break;
                default:
            }
        }


        public function registerWithCommandCentre():void {
            CommandManager.instance.registerList(this, _commandSequence);
        }

        public function unregisterWithCommandCentre():void {
            CommandManager.instance.unregisterList(this);
        }

        public function get commandSequence():Array {
            return _commandSequence;
        }

        public function set commandSequence(value:Array):void {
            _commandSequence = value;
        }

        public function startSequence():void {
            CommandManager.instance.startListCommandSequence(this);
        }
    }
}
