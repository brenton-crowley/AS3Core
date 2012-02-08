/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/7/12
 * Time: 16:37
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.managers.commands.data {

    import au.com.brentoncrowley.interfaces.ICommand;

    public class CommandData {

        private var _command:ICommand;
        private var _nextCommandData:CommandData;
        private var _previousCommandData:CommandData;
        private var _previousCommand:ICommand;

        public function CommandData(command:ICommand) {
            _command = command;
        }

        public function get command():ICommand {
            return _command;
        }

        public function set previousCommandData(value:CommandData):void {
            _previousCommandData = value;
            _previousCommand = _previousCommandData.command;
        }

        public function get previousCommand():ICommand {
            return _previousCommand;
        }

        public function get id():String {
            return command.id;
        }

        public function get nextCommandData():CommandData {
            return _nextCommandData;
        }

        public function set nextCommandData(value:CommandData):void {
            _nextCommandData = value;
        }

        public function get previousCommandData():CommandData {
            return _previousCommandData;
        }

        public function dispose():void {
            _command = null;
            if(_nextCommandData) _nextCommandData.dispose();
            if(_previousCommandData) _previousCommandData.dispose();
            if(_previousCommand) _previousCommand = null;
        }
    }
}
