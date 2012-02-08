/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/8/12
 * Time: 14:52
 * To change this template use File | Settings | File Templates.
 */
package com.example.clicktargets {

    import au.com.brentoncrowley.interfaces.IClickTarget;
    import au.com.brentoncrowley.interfaces.ICommand;

    public class UndoClick implements IClickTarget {

        private var _undoSlotCommand:ICommand;

        public function UndoClick(undoSlotCommand:ICommand) {
            _undoSlotCommand = undoSlotCommand;
        }

        public function executeClick():void {
            _undoSlotCommand.undo();
        }
    }
}
