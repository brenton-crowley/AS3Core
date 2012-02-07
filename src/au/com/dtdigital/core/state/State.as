package au.com.dtdigital.core.state {
	import au.com.dtdigital.core.state.Transition;
	
	import flash.utils.Dictionary;	

	public class State {
	
		private var id:String;
		private var transitions:Dictionary;
	
		public function State(id:String) {
			this.id = id;
			this.transitions = new Dictionary();
		}
		
		public function toString():String {
			return this.id;
		}
	
		public function getId():String {
			return this.id;
		}
	
		public function addTransition(endState:State, transition:Transition):void {
			this.transitions[endState.getId()] = transition;
		}
	
		public function getTransition(endState:State):Transition {
			return this.transitions[endState.getId()];
		}
		
		public function getTransitions():Dictionary {
			return this.transitions;
		}
	}	
}