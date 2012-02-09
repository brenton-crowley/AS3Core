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

        //--------------------------------------------------------------------------------------------------------------
        //--------------------------------------------------------------------------------------------------------------
        //------------------------------ METHODS FOR COMMAND SLOTS
        //--------------------------------------------------------------------------------------------------------------
        //--------------------------------------------------------------------------------------------------------------

        public function registerSlot(object:ICommandObject, defaultCommand:ICommand = null):void {
            var commandData:CommandData = new CommandData(defaultCommand ? defaultCommand : new NoCommand());
            var commandSlotData:CommandSlotData = new CommandSlotData(object);
            commandSlotData.commandData = commandData;
            commandSlots[object] = commandSlotData;
        }

        public function withdrawSlot(object:ICommandObject):void {
            try{
                var commandSlotData:CommandSlotData = commandSlots[object];
                clearHistoryReferences(commandSlotData);
                commandSlotData.dispose();
                commandSlotData = null;
                delete commandSlots[object];
            }catch (error:Error){}
        }

        private function clearHistoryReferences(commandSlotData:CommandSlotData):void {
            var index:uint = _slotHistory.indexOf(commandSlotData);
            while(_slotHistory.indexOf(commandSlotData) != -1){
                _slotHistory.splice(index, 1);
            }
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
            try {
                var commandSlotData:CommandSlotData = commandSlots[object];
                var lastCommandDataInHistory:CommandData = commandSlotData.getLastHistoryCommand();
                // TODO Maybe some notification that there are no more steps to undo.
                if(lastCommandDataInHistory){
                    setCommandInSlot(object, lastCommandDataInHistory.command);
                    removeFromHistory(commandSlotData);
                    undo(commandSlotData.commandData);

                }

            }catch (error:Error){}
        }

        //--------------------------------------------------------------------------------------------------------------
        //--------------------------------------------------------------------------------------------------------------
        //------------------------------ METHODS FOR COMMAND LISTS
        //--------------------------------------------------------------------------------------------------------------
        //--------------------------------------------------------------------------------------------------------------

        public function registerList(object:ICommandObject, commandList:Array):void {
            registerSlot(object);
            commandList = commandList ? commandList : [new NoCommand()];
            var commandListData:CommandListData = new CommandListData(object, commandList, commandSlots[object]);
            commandLists[object] = commandListData;
            trace(this, " COMMAND LIST REGISTERED - ***OBJECT***:", object, "***COMMANDS***", commandList);
        }

        public function withdrawList(object:ICommandObject):void {
            try{
                var commandListData:CommandListData= commandLists[object];
                withdrawSlot(object);
                commandListData.dispose();
                commandListData = null;
                delete commandLists[object];
            }catch (error:Error){}
        }

        public function startListCommandSequence(object:ICommandObject):void {
            trace("------------- > [START COMMAND SEQUENCE]:", object);
            var commandListData:CommandListData = commandLists[object];
            setCommandInSlot(object, commandListData.startCommand().command);
            executeSlotCommand(object);
        }

        public function executeListCommand(object:ICommandObject):void {
            try{
                var commandListData:CommandListData = commandLists[object];
                setCommandInSlot(object, commandListData.nextCommand().command);
                executeSlotCommand(object);
            }catch (error:Error){}
        }

        public function undoListCommand(object:ICommandObject):void {
            try{
                undoSlotCommand(object);
                var commandListData:CommandListData = commandLists[object];
                commandListData.previousCommand();
            }catch (error:Error){}

        }

        //--------------------------------------------------------------------------------------------------------------
        //--------------------------------------------------------------------------------------------------------------
        //------------------------------ SHARED METHODS
        //--------------------------------------------------------------------------------------------------------------
        //--------------------------------------------------------------------------------------------------------------

        public function globalUndo():void {
            var commandSlotData:CommandSlotData = _slotHistory[0];
            // TODO Maybe some notification that there are no more steps to undo.
            if(commandSlotData){
                if(commandSlotData.commandList == null) undoSlotCommand(commandSlotData.object);
                else undoListCommand(commandSlotData.object);
            }
        }

        private function updateSlotHistory(commandSlotData:CommandSlotData):void {
            _slotHistory.unshift(commandSlotData);
            commandSlotData.addCommandToHistory();
        }

        private function removeFromHistory(commandSlotData:CommandSlotData):void {
            if(slotHistory.length == 0) return;
            var index:uint = _slotHistory.indexOf(commandSlotData);
            _slotHistory.splice(index, 1);

        }

        public function clearGlobalSlotHistory():void {
            _slotHistory = [];
        }

        public function get slotHistory():Array {
            return _slotHistory;
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
    }
}