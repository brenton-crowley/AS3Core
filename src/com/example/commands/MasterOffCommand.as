/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/8/12
 * Time: 14:15
 * To change this template use File | Settings | File Templates.
 */
package com.example.commands {

    import au.com.brentoncrowley.interfaces.ICommand;
    import au.com.brentoncrowley.managers.commands.cmds.AbstractCommand;

    public class MasterOffCommand extends AbstractCommand{

        private var _commands:Array;

        public function MasterOffCommand(commands:Array) {
            _commands = commands;
        }


        override public function execute():void {
            for (var i:int = 0; i < _commands.length; i++) {
                var command:ICommand = _commands[i];
                command.execute();
            }
        }

        override public function undo():void {
            for (var i:int = 0; i < _commands.length; i++) {
                var command:ICommand = _commands[i];
                command.undo();
            }
        }
    }
}
