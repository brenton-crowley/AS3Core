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

    import org.osflash.signals.Signal;

    public class CommandList implements ICommandObject {

        public const ON_MAX_UNDO:String = "onMaxUndo";
        public const ON_SEQUENCE_COMPLETE:String = "onSequenceComplete";

        public var signal:Signal;

        private var _commandSequence:Array;

        public function CommandList() {
            signal = new Signal(String);
            registerWithCommandCentre();
        }

        public function onCommandManagerSignalUpdate(updateType:String, object:ICommandObject = null):void {
            switch (updateType) {
                case CommandManager.ON_SEQUENCE_UNDO_TO_START_REACHED:
                        if(object && object == this){
                            signal.dispatch(ON_MAX_UNDO);
                        }
                    break;
                case CommandManager.ON_SEQUENCE_COMPLETE:
                    if(object && object == this){
                        signal.dispatch(ON_SEQUENCE_COMPLETE);
                    }
                    break;
                default:
            }
        }


        public function registerWithCommandCentre():void {
            CommandManager.instance.signal.add(onCommandManagerSignalUpdate);
            CommandManager.instance.registerList(this, _commandSequence);
        }

        public function withdrawFromCommandCentre():void {
            CommandManager.instance.signal.remove(onCommandManagerSignalUpdate);
            CommandManager.instance.withdrawList(this);
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

        public function dispose():void {
            withdrawFromCommandCentre();
            if(signal) signal.removeAll();
            signal = null;
        }
    }
}
