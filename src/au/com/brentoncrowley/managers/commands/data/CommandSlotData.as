/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/7/12
 * Time: 17:07
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.managers.commands.data {

    import au.com.brentoncrowley.interfaces.ICommand;
    import au.com.brentoncrowley.interfaces.ICommandObject;
    import au.com.brentoncrowley.managers.commands.cmds.NoCommand;

    public class CommandSlotData {

        private var _commandData:CommandData;
        private var _object:ICommandObject;
//        private var _commandHistory:Vector.<CommandData>;

        public function CommandSlotData(object:ICommandObject, defaultCommandData:CommandData = null) {
            _object = object;
            _commandData = defaultCommandData ? defaultCommandData : new CommandData(new NoCommand());
//            _commandHistory = new Vector.<CommandData>();
        }

        public function get commandData():CommandData {
            return _commandData;
        }

        public function set commandData(commandData:CommandData):void {
//            updateCommandHistory();
            _commandData = commandData;
        }

//        private function updateCommandHistory():void {
//            if(_commandData) _commandHistory.unshift(commandData);
//
//        }
//
//        public function get commandHistory():Vector.<CommandData> {
//            return _commandHistory;
//        }
        public function dispose():void {
            if(commandData){
                commandData.dispose();
                commandData = null;
            }

            if(_object){
                _object = null;
            }
        }

        public function get object():ICommandObject {
            return _object;
        }
    }
}
