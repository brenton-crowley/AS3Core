/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/7/12
 * Time: 16:38
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.interfaces {

    public interface ICommand {

        function execute():void;
        function undo():void;
        function get id():String;

    }
}
