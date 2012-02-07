/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/7/12
 * Time: 16:52
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.managers.commands.cmds {

    import au.com.brentoncrowley.interfaces.ICommand;

    public class NoCommand implements ICommand{

        public function NoCommand() {
        }

        public function execute():void {
        }

        public function undo():void {
        }
    }
}
