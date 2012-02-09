/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/8/12
 * Time: 12:10
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.managers.commands {

    import au.com.brentoncrowley.interfaces.ICommand;
    import au.com.brentoncrowley.interfaces.ICommandObject;
    import au.com.brentoncrowley.managers.commands.cmds.NoCommand;

    public class CommandSlot implements ICommandObject {

        private var _command:ICommand;

        public function CommandSlot() {

            registerWithCommandCentre();
        }

        public function onCommandManagerSignalUpdate(updateType:String, object:ICommandObject = null):void {
            switch (updateType) {
                
                default:
            }
        }

        public function registerWithCommandCentre():void {
            CommandManager.instance.signal.add(onCommandManagerSignalUpdate);
            CommandManager.instance.registerSlot(this);
        }

        public function withdrawFromCommandCentre():void {
            CommandManager.instance.signal.remove(onCommandManagerSignalUpdate);
            CommandManager.instance.withdrawSlot(this);
        }

        public function setCommand(command:ICommand):void {
           _command = command;
           CommandManager.instance.setCommandInSlot(this, _command);
        }

        public function execute():void {
            CommandManager.instance.executeSlotCommand(this);
        }

        public function undo():void {
            CommandManager.instance.undoSlotCommand(this);
        }

        public function dispose():void {
            _command = null;
            withdrawFromCommandCentre();
        }
    }
}
