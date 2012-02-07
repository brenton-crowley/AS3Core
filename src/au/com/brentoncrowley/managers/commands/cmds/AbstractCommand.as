/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/7/12
 * Time: 16:54
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.managers.commands.cmds {

    import au.com.brentoncrowley.interfaces.ICommand;

    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    public class AbstractCommand implements ICommand{

        public function AbstractCommand() {
        }

        public function execute():void {}

        public function undo():void {}

        public function id():String {
            return getDefinitionByName(getQualifiedClassName(this)).toString();
        }
    }
}
