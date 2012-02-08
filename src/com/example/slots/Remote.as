/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/8/12
 * Time: 13:56
 * To change this template use File | Settings | File Templates.
 */
package com.example.slots {

    import au.com.brentoncrowley.interfaces.IClickTarget;
    import au.com.brentoncrowley.managers.commands.CommandSlot;
    import au.com.brentoncrowley.ui.buttons.ClickTargetButton;

    import com.example.clicktargets.RemoteButtonClick;
    import com.example.clicktargets.UndoClick;
    import com.example.commands.GlobalUndoCommand;
    import com.example.commands.MasterOffCommand;
    import com.example.commands.MasterOnCommand;
    import com.example.commands.TurnOffCommand;
    import com.example.commands.TurnOnCommand;

    import flash.display.Sprite;
    import flash.events.Event;

    public class Remote extends Sprite {

        public var slot1:RemoteSlot;
        public var slot2:RemoteSlot;
        public var slot3:RemoteSlot;

        public var masterOn:ClickTargetButton;
        public var masterOff:ClickTargetButton;
        public var masterUndoButton:ClickTargetButton;

        private var commandSlot:CommandSlot;

        public function Remote() {

            commandSlot = new CommandSlot();

            initButtons()
        }

        private function initButtons():void {
            initButton(masterOn, new RemoteButtonClick(new MasterOnCommand([new TurnOnCommand(slot1.light), new TurnOnCommand(slot2.light), new TurnOnCommand(slot3.light)]), commandSlot));
            initButton(masterOff, new RemoteButtonClick(new MasterOffCommand([new TurnOffCommand(slot1.light), new TurnOffCommand(slot2.light), new TurnOffCommand(slot3.light)]), commandSlot));
            initButton(masterUndoButton, new UndoClick(new GlobalUndoCommand()));
        }

        private function initButton(button:ClickTargetButton, clickTarget:IClickTarget):void {
            button.clickTarget = clickTarget;
            button.initButton();
        }
    }
}
