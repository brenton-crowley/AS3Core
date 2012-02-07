/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/7/12
 * Time: 17:24
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.managers.commands.data {

    import au.com.brentoncrowley.interfaces.ICommand;

    public class CommandListData {

        private var _commandSlotData:CommandSlotData;
        private var _commandDatas:Array;

        public function CommandListData(commandList:Array) {
            _commandSlotData = new CommandSlotData();
            _commandDatas = [];
            generateCommandListData(commandList);
            _commandSlotData.commandData = _commandDatas[0];
        }

        private function generateCommandListData(commandList:Array):void {
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
            _commandSlotData.commandData = _commandSlotData.commandData.nextCommandData;
        }

        public function setPreviousCommandData():void {
            _commandSlotData.commandData = _commandSlotData.commandData.previousCommandData;

        }

        public function get commandSlotData():CommandSlotData {
            return _commandSlotData;
        }
    }
}
