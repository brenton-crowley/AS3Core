/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/6/12
 * Time: 10:49
 * To change this template use File | Settings | File Templates.
 */
package com.example.main {

    import au.com.brentoncrowley.interfaces.IClickTarget;
    import au.com.brentoncrowley.managers.commands.CommandManager;
    import au.com.brentoncrowley.managers.state.StateManager;
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
    import com.example.states.States;

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
            StateManager.instance.registerState(new StateA(States.STATE_A));
            StateManager.instance.registerState(new StateB(States.STATE_B));
            StateManager.instance.registerState(new StateC(States.STATE_C));
            StateManager.instance.registerState(new StateD(States.STATE_D));
            StateManager.instance.registerState(new StateE(States.STATE_E));
            StateManager.instance.registerState(new StateF(States.STATE_F));
            StateManager.instance.setDefaultState(States.STATE_A);

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
            this.outputField.text = StateManager.instance.state.id;
        }

        private function initButtons():void {

            initButton(stateAButton, new SetStateClickTarget(States.STATE_A));
            initButton(stateBButton, new SetStateClickTarget(States.STATE_B));
            initButton(stateCButton, new SetStateClickTarget(States.STATE_C));
            initButton(stateDButton, new SetStateClickTarget(States.STATE_D));
            initButton(stateEButton, new SetStateClickTarget(States.STATE_E));
            initButton(stateFButton, new SetStateClickTarget(States.STATE_F));
            initButton(backButton,   new SetPreviousStateClick());


        }

        private function initButton(button:ClickTargetButton, clickTarget:IClickTarget):void {
            button.clickTarget = clickTarget;
            button.initButton();
        }
    }
}
