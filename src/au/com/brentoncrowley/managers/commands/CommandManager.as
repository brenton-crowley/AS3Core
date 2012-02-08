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
    import au.com.brentoncrowley.managers.commands.cmds.GlobalUndoCompleteCommand;
    import au.com.brentoncrowley.managers.commands.cmds.NoCommand;
    import au.com.brentoncrowley.managers.commands.cmds.SequenceCompletedCommand;
    import au.com.brentoncrowley.managers.commands.cmds.SequenceStartCommand;
    import au.com.brentoncrowley.managers.commands.data.CommandData;
    import au.com.brentoncrowley.managers.commands.data.CommandListData;
    import au.com.brentoncrowley.managers.commands.data.CommandSlotData;
    import au.com.brentoncrowley.managers.commands.data.CommandSlotData;

    import flash.utils.Dictionary;

    import org.osflash.signals.Signal;

    public class CommandManager {

        public static const ON_SEQUENCE_COMPLETE:String = "onSequenceComplete";
        public static const ON_SEQUENCE_START:String = "onSequenceStart";
        public static const ON_SEQUENCE_UNDO_TO_START_REACHED:String = "onSequenceStartReached";
        public static const ON_GLOBAL_UNDO_COMPLETE:String = "onGlobalUndoComplete";

        private static var _instance:CommandManager = new CommandManager();

        public var signal:Signal;

        private var _slotHistory:Array;

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
            signal = new Signal(String, ICommandObject);
            _slotHistory = [];
            commandSlots = new Dictionary();
            commandLists = new Dictionary();
        }

        public function registerSlot(object:ICommandObject, defaultCommand:ICommand = null):void {
            var commandData:CommandData = new CommandData(defaultCommand ? defaultCommand : new NoCommand());
            var commandSlotData:CommandSlotData = new CommandSlotData(object);
            commandSlotData.commandData = commandData;
            commandSlots[object] = commandSlotData;
        }

        public function unregisterSlot(object:ICommandObject):void {
            var commandSlotData:CommandSlotData = commandSlots[object];
            commandSlotData.dispose();
            commandSlotData = null;
            commandSlots[object = null];
        }

        public function setCommandInSlot(object:ICommandObject, command:ICommand):void {
            var commandSlotData:CommandSlotData = commandSlots[object];
            var commandData:CommandData = new CommandData(command);
            commandSlotData.commandData = commandData;
        }

        public function getCommandInSlot(object:ICommandObject):ICommand {
            var commandSlotData:CommandSlotData = commandSlots[object];
            return commandSlotData.commandData.command;
        }

        public function executeSlotCommand(object:ICommandObject):void {
           var commandSlotData:CommandSlotData = commandSlots[object];
           updateSlotHistory(commandSlotData);
           execute(commandSlotData.commandData);
        }

        public function undoSlotCommand(object:ICommandObject):void {
            var commandSlotData:CommandSlotData = commandSlots[object];
//            removeFromHistory(commandSlotData);
            undo(commandSlotData.commandData);
        }

        private function removeFromHistory(commandSlotData:CommandSlotData):void {
            if(slotHistory.length == 0) return;
            var index:Number = 0;
            while(index != slotHistory.length - 1){
                var comparitiveCommandSlotData:CommandSlotData = slotHistory[index];
                if(comparitiveCommandSlotData == commandSlotData){
                    trace("LENGTH BEFORE SPLICE:", slotHistory.length);
                    slotHistory.splice(index, 1);
                    trace("LENGTH AFTER SPLICE:", slotHistory.length);
                    trace("*********************************** REMOVED FROM HISTORY", commandSlotData.commandData.command, comparitiveCommandSlotData.commandData.command);
                    break;
                }
                index++;

            }
        }

        public function globalUndo():void {
            var undoCommandSlotData:CommandSlotData = getUndoCommandSlotData();
            var commandSlot:CommandSlot = undoCommandSlotData.object as CommandSlot;
            commandSlot ? commandSlot.undo() : undo(undoCommandSlotData.commandData);
            trace(this, "********************************** SLOT HISTORY:", _slotHistory);
        }

        public function clearSlotHistory():void {
            _slotHistory = [];
        }

        private function updateSlotHistory(commandSlotData:CommandSlotData):void {
            _slotHistory.unshift(commandSlotData);
            trace(this, "********************************** SLOT HISTORY:", _slotHistory);
        }

        private function getUndoCommandSlotData():CommandSlotData {
            trace("########### getUndoCommandSlotData");
            var commandSlotData:CommandSlotData = _slotHistory.shift();
            commandSlotData = commandSlotData ? commandSlotData : new CommandSlotData(null), new CommandData(new GlobalUndoCompleteCommand());
            return commandSlotData;
        }

        public function registerList(object:ICommandObject, commandList:Array):void {
            commandList = commandList ? commandList : [new NoCommand()];
            var commandListData:CommandListData = new CommandListData(object, commandList);
            commandLists[object] = commandListData;

            trace(this, " COMMAND LIST REGISTERED - ***OBJECT***:", object, "***COMMANDS***", commandList);
        }

        public function unregisterList(object:ICommandObject):void {
            var commandListData:CommandListData= commandLists[object];
            commandListData.dispose();
            commandListData = null;
            commandLists[object = null];
        }

        public function startListCommandSequence(object:ICommandObject):void {
            trace("------------- > [START COMMAND SEQUENCE]:", object);
            var commandListData:CommandListData = commandLists[object];
            commandListData.setToFirstCommand();
            executeListCommand(object);
        }

        public function executeListCommand(object:ICommandObject):void {
            var commandListData:CommandListData = commandLists[object];
            var commandDataToExecute:CommandData = commandListData.commandSlotData.commandData;
            commandListData.setNextCommandData();
            execute(commandDataToExecute);

        }

        public function undoListCommand(object:ICommandObject):void {
            var commandListData:CommandListData = commandLists[object];
            var commandDataToExecute:CommandData = commandListData.commandSlotData.commandData;
            commandListData.setPreviousCommandData();
            undo(commandDataToExecute);

        }

        private function execute(commandData:CommandData):void {
            try {
                if(!(commandData.command is SequenceCompletedCommand) && !(commandData.command is SequenceStartCommand)) trace("------------- > [EXECUTE COMMAND]:", "COMMAND:", commandData.command);
                commandData.command.execute();
            } catch(error:Error) {
                trace("ERROR - executeCommandSlot:", error.getStackTrace());
            }
        }

        private function undo(commandData:CommandData):void {
            try {
                if(!(commandData.command is SequenceCompletedCommand) && !(commandData.command is SequenceStartCommand)) trace("------------- > [UNDO COMMAND]:", "COMMAND:", commandData.command, "SLOT LENGTH:", slotHistory.length);
                commandData.command.undo();
            } catch(error:Error) {
                trace("ERROR - undoCommandSlot:", error.getStackTrace());
            }
        }

        public function get slotHistory():Array {
            return _slotHistory;
        }
    }
}