/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/7/12
 * Time: 16:26
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.managers.commands {

    import au.com.brentoncrowley.interfaces.ICommand;
    import au.com.brentoncrowley.interfaces.ICommandObject;
    import au.com.brentoncrowley.managers.commands.cmds.NoCommand;
    import au.com.brentoncrowley.managers.commands.data.CommandData;
    import au.com.brentoncrowley.managers.commands.data.CommandListData;
    import au.com.brentoncrowley.managers.commands.data.CommandSlotData;

    import flash.utils.Dictionary;

    public class CommandManager {

        private static var _instance:CommandManager = new CommandManager();

        private var commandSlots:Dictionary;
        private var commandLists:Dictionary;

        public function CommandManager() {
            init();
            if (_instance) {
                throw new Error("Cannot create since CommandManager is a Singleton");
            }
        }

        public static function get instance():CommandManager {
            return _instance;
        }

        private function init():void {
            commandSlots = new Dictionary();
            commandLists = new Dictionary();
        }

        public function registerSlot(object:ICommandObject, defaultCommand:ICommand = null):void {
            var commandData:CommandData = new CommandData(defaultCommand ? defaultCommand : new NoCommand());
            var commandSlotData:CommandSlotData = new CommandSlotData();
            commandSlotData.commandData = commandData;
            commandSlots[object] = commandSlotData;
        }

        public function setCommandInSlot(object:ICommandObject, command:ICommand):void {
            var commandSlotData:CommandSlotData = commandSlots[object];
            var commandData:CommandData = new CommandData(command);
            commandSlotData.commandData = commandData;
        }

        public function executeSlotCommand(object:ICommandObject):void {
           var commandSlotData:CommandSlotData = commandSlots[object];
           execute(commandSlotData.commandData);
        }

        public function undoSlotCommand(object:ICommandObject):void {
            var commandSlotData:CommandSlotData = commandSlots[object];
            undo(commandSlotData.commandData);
        }


        public function registerList(object:ICommandObject, commandList:Array):void {
            commandList = commandList ? commandList : [new NoCommand()];
            var commandListData:CommandListData = new CommandListData(commandList);
            commandLists[object] = commandListData;
        }

        public function executeNextCommandInList(object:ICommandObject):void {
            var commandListData:CommandListData = commandLists[object];
            commandListData.setNextCommandData();
            execute(commandListData.commandSlotData.commandData);
        }

        public function undoCurrentCommandInList(object:ICommandObject):void {
            var commandListData:CommandListData = commandLists[object];
            var commandData:CommandData = commandListData.commandSlotData.commandData;
            commandListData.setPreviousCommandData();
            undo(commandData);

        }

        private function execute(commandData:CommandData):void {
            try {
                trace("------------- > [EXECUTE COMMAND]:", "COMMAND:", commandData.command);
                commandData.command.execute();
            } catch(error:Error) {
                trace("ERROR - executeCommandSlot:", error.getStackTrace());
            }
        }

        private function undo(commandData:CommandData):void {
            try {
                trace("------------- > [UNDO COMMAND]:", "COMMAND:", commandData.command);
                commandData.command.undo();
            } catch(error:Error) {
                trace("ERROR - undoCommandSlot:", error.getStackTrace());
            }
        }
    }
}