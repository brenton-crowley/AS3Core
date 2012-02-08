/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/8/12
 * Time: 12:13
 * To change this template use File | Settings | File Templates.
 */
package com.example.commands {

    import au.com.brentoncrowley.managers.commands.cmds.AbstractCommand;

    import flash.display.Sprite;

    public class TurnOnCommand extends AbstractCommand {

        private var _light:Sprite;

        public function TurnOnCommand(light:Sprite) {
            _light = light;
        }


        override public function execute():void {
            _light.visible = true;
        }

        override public function undo():void {
            _light.visible = false;
        }
    }
}
