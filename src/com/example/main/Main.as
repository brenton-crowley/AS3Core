/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 10:49
 * To change this template use File | Settings | File Templates.
 */
package com.example.main {

    import au.com.brentoncrowley.interfaces.IClickTarget;
    import au.com.brentoncrowley.state.StateManager;
    import au.com.brentoncrowley.ui.buttons.ClickTargetButton;
    import au.com.brentoncrowley.ui.display.AbstractMain;

    import com.example.clicktargets.SetPreviousStateClick;

    import com.example.clicktargets.SetStateClickTarget;
    import com.example.states.StateA;
    import com.example.states.StateB;
    import com.example.states.StateC;
    import com.example.states.StateD;
    import com.example.states.StateE;
    import com.example.states.StateF;

    import flash.text.TextField;

    public class Main extends AbstractMain {

        public var stateAButton:ClickTargetButton;
        public var stateBButton:ClickTargetButton;
        public var stateCButton:ClickTargetButton;
        public var stateDButton:ClickTargetButton;
        public var stateEButton:ClickTargetButton;
        public var stateFButton:ClickTargetButton;
        public var backButton:ClickTargetButton;

        public var outputField:TextField;

        public function Main() {
            super();
        }

        override protected function init():void {
            super.init();

            initStates();
            initButtons();

        }

        private function initStates():void {
            StateManager.instance.signal.add(onStateManagerSignalUpdate);
            StateManager.instance.registerState(new StateA());
            StateManager.instance.registerState(new StateB());
            StateManager.instance.registerState(new StateC());
            StateManager.instance.registerState(new StateD());
            StateManager.instance.registerState(new StateE());
            StateManager.instance.registerState(new StateF());
            StateManager.instance.setDefaultState(StateA);
        }

        private function onStateManagerSignalUpdate(updateType:String):void {

            switch (updateType) {
                case StateManager.ON_STATE_TRANSITION_COMPLETE:
                        updateField();
                    break;
                default:
            }

        }

        private function updateField():void {
            this.outputField.text = String(StateManager.instance.currentState);
        }

        private function initButtons():void {

            initButton(stateAButton, new SetStateClickTarget(StateA));
            initButton(stateBButton, new SetStateClickTarget(StateB));
            initButton(stateCButton, new SetStateClickTarget(StateC));
            initButton(stateDButton, new SetStateClickTarget(StateD));
            initButton(stateEButton, new SetStateClickTarget(StateE));
            initButton(stateFButton, new SetStateClickTarget(StateF));
            initButton(backButton,   new SetPreviousStateClick());

        }

        private function initButton(button:ClickTargetButton, clickTarget:IClickTarget):void {
            button.clickTarget = clickTarget;
            button.initButton();
        }
    }
}
