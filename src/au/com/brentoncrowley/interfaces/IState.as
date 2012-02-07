/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 10:10
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.interfaces {

    public interface IState {

        function startStateChange():void;

        function transitionCurrentStateOut():void;

        function transitionTargetStateIn():void;

        function completeStateChange():void;

        function hasValidTransition(targetState:IState):Boolean;

    }
}
