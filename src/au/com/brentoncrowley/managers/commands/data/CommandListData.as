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
    import au.com.brentoncrowley.managers.commands.cmds.SequenceCompletedCommand;
    import au.com.brentoncrowley.managers.commands.cmds.SequenceStartCommand;

    public class CommandListData {

        private var _commandSlotData:CommandSlotData;
        private var _commandDatas:Array;
        private var _object:ICommandObject;

        public function CommandListData(object:ICommandObject, commandList:Array) {
            _object = object;
            _commandSlotData = new CommandSlotData(_object);
            _commandDatas = [];
            generateCommandListData(commandList);
            _commandSlotData.commandData = _commandDatas[0];
        }


        public function setToFirstCommand():void {
            if(_commandDatas){
                _commandSlotData.commandData = _commandDatas[0];
            }
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

        }

        public function setNextCommandData():void {
            var nextCommandData:CommandData = _commandSlotData.commandData.nextCommandData;
            _commandSlotData.commandData = nextCommandData ? nextCommandData : _commandSlotData.commandData;
        }

        public function setPreviousCommandData():void {
            var previousCommandData:CommandData = _commandSlotData.commandData.previousCommandData;
            _commandSlotData.commandData = _commandSlotData.commandData = previousCommandData ? previousCommandData : _commandSlotData.commandData;

        }

        public function get commandSlotData():CommandSlotData {
            return _commandSlotData;
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
        }

        public function get object():ICommandObject {
            return _object;
        }
    }
}
