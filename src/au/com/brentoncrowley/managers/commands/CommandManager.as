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

    /**
     * The CommandManager has the ability to create command slots and command sequences.
     * There is a built-in CommandSlot object that can be used that will take care of all communication with the CommandManager. Alternatively Custom objects can be defined.
     * There is a built-in CommandList object that can be used that will take care of all communication with the CommandManager. Alternatively Custom objects can be defined.
     *
     * For a CommandSlot
     * [Step 1] - Register a CommandSlot. Optionally set a default command. CommandManger.instance.registerSlot(object, new DefaultCommand());
     * [Step 2] - Set a command in the slot. CommandManger.instance.setCommand(object, new DefaultCommand());
     * [Step 3] - Execute or undo the action of the command. CommandManager.instance.executeSlotCommand(object);
     *
     * For a CommandList
     * [Step 1] - Register a CommandLs=ist. Optionally set a list (recommended). CommandManger.instance.registerList(object, [new DefaultCommand()]);
     * [Step 2] - Execute or undo the action of the command. CommandManager.instance.executeListCommand(object);
     *
     * @author Brenton Crowley, brenton.crowley@gmail.com
     */
        
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

        /**
         * Registers an ICommandObject to the Command Manager. Once it has ben registered it can have its current
         * command changed and will execute upon the call of the execute() method.
         *
         *  @param object The object that will be registered.
         *  @param defaultCommand An initial command to set on the object. If none is provided then a NoCommand() will be set as the deafault
         */

        public function registerSlot(object:ICommandObject, defaultCommand:ICommand = null):void {
            var commandData:CommandData = new CommandData(defaultCommand ? defaultCommand : new NoCommand());
            var commandSlotData:CommandSlotData = new CommandSlotData(object);
            commandSlotData.commandData = commandData;
            commandSlots[object] = commandSlotData;
        }

        /**
         * Removes an object from the CommandManager and all of its commands.
         *
         *  @param object The object that will be withdrawn.
         */
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

        /**
         * Sets a command inside an object's command slot.
         *
         *  @param object The object key that the command will be associated with.
         *  @param command The command that will be placed in the object's slot.
         */
        public function setCommandInSlot(object:ICommandObject, command:ICommand):void {
            var commandSlotData:CommandSlotData = commandSlots[object];
            var commandData:CommandData = new CommandData(command);
            commandSlotData.commandData = commandData;
        }

        /**
         * Returns the command that is currently in the supplied object's slot.
         *
         *  @param object The object key that is used to find the command in the CommandManager.
         *
         *  @return ICommand
         */
        public function getCommandInSlot(object:ICommandObject):ICommand {
            var commandSlotData:CommandSlotData = commandSlots[object];
            return commandSlotData.commandData.command;
        }

        /**
         * Executes the command that is currently in the object slot.
         *
         *  @param object The object key that is used to find the command in the CommandManager.
         */
        public function executeSlotCommand(object:ICommandObject):void {
           var commandSlotData:CommandSlotData = commandSlots[object];
           updateSlotHistory(commandSlotData);
           execute(commandSlotData.commandData);
        }

        /**
         * Undoes the command that is currently sitting in the supplied object's slot.
         *
         *  @param object The object key that is used to find the command in the CommandManager.
         */

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

        /**
         * Registers an ICommandObject Sequence to the CommandManager. Once it has ben registered it is able to queue a sequence of supplied commands.
         *
         *  @param object The object that will be registered.
         *  @param commandList The command list that will be used to execute the sequence.
         */
        public function registerList(object:ICommandObject, commandList:Array):void {
            registerSlot(object);
            commandList = commandList ? commandList : [new NoCommand()];
            var commandListData:CommandListData = new CommandListData(object, commandList, commandSlots[object]);
            commandLists[object] = commandListData;
            trace(this, " COMMAND LIST REGISTERED - ***OBJECT***:", object, "***COMMANDS***", commandList);
        }

        /**
         * Removes an object from the CommandManager and all of its commands.
         *
         *  @param object The object that will be withdrawn.
         */
        public function withdrawList(object:ICommandObject):void {
            try{
                var commandListData:CommandListData= commandLists[object];
                withdrawSlot(object);
                commandListData.dispose();
                commandListData = null;
                delete commandLists[object];
            }catch (error:Error){}
        }

        /**
         * Set the current command on the object to the first and begins execution on that object's sequence.
         *
         *  @param object The object key identifier that is used to find the object's sequence.
         */
        public function startListCommandSequence(object:ICommandObject):void {
            trace("------------- > [START COMMAND SEQUENCE]:", object);
            var commandListData:CommandListData = commandLists[object];
            setCommandInSlot(object, commandListData.startCommand().command);
            executeSlotCommand(object);
        }

        /**
         * Executes the next command in the command sequence.
         *
         *  @param object The object key identifier that is used to find the object's sequence.
         */
        public function executeListCommand(object:ICommandObject):void {
            try{
                var commandListData:CommandListData = commandLists[object];
                setCommandInSlot(object, commandListData.nextCommand().command);
                executeSlotCommand(object);
            }catch (error:Error){}
        }

        /**
         * Will undo the current command in the command sequence and sets the current command to the previous
         *
         *  @param object The object key identifier that is used to find the object's sequence.
         */
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

        /**
         * Will undo the last command that was executed. Take caution with using this as will execute the last command in a sequence and in a slot.
         *
         */
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

        /**
         * Clears the history of the CommandManager.
         *
         */
        public function clearGlobalSlotHistory():void {
            _slotHistory = [];
        }

        /**
         * Return the slot history. Useful to see if the maximum amount of undo actions have been completed.
         *
         */
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
                if(!(commandData.command is SequenceCompletedCommand) && !(commandData.command is SequenceStartCommand)) trace("------------- > [UNDO COMMAND]:", "COMMAND:", commandData.command);
                commandData.command.undo();
            } catch(error:Error) {
                trace("ERROR - undoCommandSlot:", error.getStackTrace());
            }
        }
    }
}