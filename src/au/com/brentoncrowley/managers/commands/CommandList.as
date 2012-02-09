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

    /**
     * A class that arbitrates communication between the CommandManager and the associated object that created the CommandList.s
     *
     * @author Brenton Crowley, brenton.crowley@gmail.com
     */

    public class CommandList implements ICommandObject {

        public const ON_MAX_UNDO:String = "onMaxUndo";
        public const ON_SEQUENCE_COMPLETE:String = "onSequenceComplete";

        public var signal:Signal;

        private var _commandSequence:Array;

        public function CommandList(commandSequence:Array = null) {
            _commandSequence = commandSequence;
            signal = new Signal(String);

            if(_commandSequence) registerWithCommandCentre();
            
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

        /**
         * Sets the command list that will be used to execute the sequence.
         *
         *
         */
        public function registerWithCommandCentre():void {
            if(!_commandSequence) throw new Error("The CommandList must contain a commandSequence before it can be registered. Please supply a list first.");
            CommandManager.instance.signal.add(onCommandManagerSignalUpdate);
            CommandManager.instance.registerList(this, _commandSequence);

        }

        public function withdrawFromCommandCentre():void {
            CommandManager.instance.signal.remove(onCommandManagerSignalUpdate);
            CommandManager.instance.withdrawList(this);
        }

        public function undoCurrentCommand():void {
            CommandManager.instance.undoListCommand(this);
        }

        public function executeNextCommand():void {
            CommandManager.instance.executeListCommand(this);
        }

        public function get commandSequence():Array {
            return _commandSequence;
        }

        /**
         * Sets the command list that will be used to execute the sequence.
         *
         * Exmaple:
         *
         * var commandSequence:Array = [
         *      new FirstCommand(),
         *      new SecondCommand(),
         *      new ThirdCommand(),
         *      new FourthCommand()
         * ];
         *
         *  @param commandSequence The object that will be withdrawn.
         */
        public function set commandSequence(commandSequence:Array):void {
            _commandSequence = commandSequence;
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
