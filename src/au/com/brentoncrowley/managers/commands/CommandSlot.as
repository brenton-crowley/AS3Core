/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/8/12
 * Time: 12:10
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.managers.commands {

    import au.com.brentoncrowley.interfaces.ICommand;
    import au.com.brentoncrowley.interfaces.ICommandObject;
    import au.com.brentoncrowley.managers.commands.cmds.NoCommand;

    public class CommandSlot implements ICommandObject {

        private var undoHistory:Array;
        private var _command:ICommand;

        public function CommandSlot() {
            undoHistory = [];
           CommandManager.instance.signal.add(onCommandManagerSignalUpdate);
            CommandManager.instance.registerSlot(this);
        }

        public function onCommandManagerSignalUpdate(updateType:String, object:ICommandObject = null):void {
            switch (updateType) {
                
                default:
            }
        }


        public function registerWithCommandCentre():void {
            CommandManager.instance.registerSlot(this);
        }

        public function unregisterWithCommandCentre():void {
            CommandManager.instance.unregisterSlot(this);
        }

        public function setCommand(command:ICommand):void {
           _command = command;
           CommandManager.instance.setCommandInSlot(this, _command);
        }

        public function execute():void {
            updateHistory();
            CommandManager.instance.executeSlotCommand(this);
        }

        private function updateHistory():void {
            undoHistory.unshift(_command);
//            trace(this, "UNDO HISTORY", undoHistory);
        }

        public function undo():void {
            var undoCommand:ICommand = getUndoCommand();
            setCommand(undoCommand);
//            trace(this, "UNDO:", undoCommand, "HISTORY:", undoHistory);
            CommandManager.instance.undoSlotCommand(this);
        }

        private function getUndoCommand():ICommand {
            var command:ICommand = undoHistory.shift();
            command = command ? command : new NoCommand();
            return command;
        }

        public function get id():String {
            return "";
        }
    }
}
