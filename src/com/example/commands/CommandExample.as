/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/8/12
 * Time: 9:08
 * To change this template use File | Settings | File Templates.
 */
package com.example.commands {

    import au.com.brentoncrowley.interfaces.IClickTarget;
    import au.com.brentoncrowley.managers.commands.CommandList;
    import au.com.brentoncrowley.ui.buttons.ClickTargetButton;
    import au.com.brentoncrowley.ui.display.AbstractMain;

    import com.example.clicktargets.ExecuteListCommandTarget;
    import com.example.clicktargets.UndoListCommandTarget;
    import com.example.slots.Remote;

    public class CommandExample extends AbstractMain {

        public var undoButton:ClickTargetButton;
        public var executeButton:ClickTargetButton;

        public var remote:Remote;

        private var commandList:CommandList;

        public function CommandExample() {
            super();
        }

        override protected function init():void {
            super.init();
            
            createCommandList();

            initButton(undoButton, new UndoListCommandTarget(commandList));
            initButton(executeButton, new ExecuteListCommandTarget(commandList));
        }

        private function createCommandList():void {
            commandList = new CommandList();
            var commandSequence:Array = [
                new FirstCommand(commandList),
                new SecondCommand(commandList)
            ];
            commandList.commandSequence = commandSequence;
            commandList.registerWithCommandCentre();

        }

        private function initButton(button:ClickTargetButton, clickTarget:IClickTarget):void {
            button.clickTarget = clickTarget;
            button.initButton();
        }
    }
}
