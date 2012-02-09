/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/7/12
 * Time: 17:24
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.managers.commands.data {

    import au.com.brentoncrowley.interfaces.ICommand;
    import au.com.brentoncrowley.interfaces.ICommandObject;
    import au.com.brentoncrowley.managers.commands.CommandSlot;
    import au.com.brentoncrowley.managers.commands.cmds.SequenceCompletedCommand;
    import au.com.brentoncrowley.managers.commands.cmds.SequenceStartCommand;

    public class CommandListData {

        private var _commandSlotData:CommandSlotData;
        private var _commandDatas:Array;
        private var _object:ICommandObject;
        private var _commandList:Array;
        private var _currentCommandData:CommandData;

        public function CommandListData(object:ICommandObject, commandList:Array, commandSlotData:CommandSlotData) {
            _object = object;
            _commandList = commandList;
            _commandSlotData = commandSlotData;
            _commandSlotData.commandList = this;
            _commandDatas = [];
            generateCommandListData(commandList);
        }

        private function generateCommandListData(commandList:Array):void {
            commandList.unshift(new SequenceStartCommand(_object));
            commandList.push(new SequenceCompletedCommand(_object));
            var previousCommandData:CommandData;

            for (var i:int = 0; i < commandList.length; i++) {


                var command:ICommand = commandList[i];
                var commandData:CommandData = new CommandData(command);
//
                if (previousCommandData) {
                    commandData.previousCommandData = previousCommandData;
                    previousCommandData.nextCommandData = commandData;
                }
                _commandDatas.push(commandData);
                previousCommandData = commandData;
            }

            _currentCommandData =  _commandDatas[0];
        }

        public function startCommand():CommandData {
            _currentCommandData = _commandDatas[0];
            return _currentCommandData;
        }

        public function nextCommand():CommandData {
            var nextCommandData:CommandData = _currentCommandData.nextCommandData;
            _currentCommandData = nextCommandData ? nextCommandData : _currentCommandData;
            return _currentCommandData;
        }

        public function previousCommand():void {
            var previousCommandData:CommandData = _currentCommandData.previousCommandData;
            _currentCommandData = previousCommandData ? previousCommandData : _currentCommandData;
        }

        public function dispose():void {
            if(_commandSlotData){
                _commandSlotData.dispose();
                _commandSlotData = null
            }
            if(_commandDatas){
                while(_commandDatas.length != 0){
                    var commandData:CommandData = _commandDatas.shift();
                    commandData.dispose();
                    commandData = null;
                }
                _commandDatas = null;
            }

            _object = null;
            _currentCommandData = null;
            _commandList = null;
        }

        public function get object():ICommandObject {
            return _object;
        }


    }
}
