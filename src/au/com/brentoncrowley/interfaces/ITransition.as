/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 10:15
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.interfaces {

    import org.osflash.signals.Signal;

    public interface ITransition {

        function startTransition():void;

        function pauseTransition():void;

        function stopTransition():void;

        function completeTransition():void;

        function get signal():Signal;

    }
}
