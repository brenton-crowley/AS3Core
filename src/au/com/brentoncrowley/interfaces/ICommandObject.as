/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/7/12
 * Time: 16:48
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.interfaces {

    public interface ICommandObject {

        function registerWithCommandCentre():void;
        function withdrawFromCommandCentre():void;
        function onCommandManagerSignalUpdate(updateType:String, object:ICommandObject = null):void;
        function dispose():void;

    }
}
