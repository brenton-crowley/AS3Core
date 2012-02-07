package au.com.dtdigital.core.state {
	import au.com.dtdigital.core.state.State;
	import au.com.dtdigital.core.state.StateEvent;
	import au.com.dtdigital.core.state.Transition;
	import au.com.dtdigital.core.state.TransitionStep;
	import au.com.dtdigital.core.state.TransitionStepEvent;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;	

	public class StateMachine extends EventDispatcher {

		private var states:Dictionary;
		private var transitioning:Boolean;
		private var currentState:State;
		private var targetState:State;
		private var currentTransition:Transition;
		private var currentTransitionStep:TransitionStep;
		private var acceptStateHistory:Array;
	
		public function StateMachine(initialStateId:String) {
			this.states = new Dictionary();
			this.createState(initialStateId);
			this.currentState = this.getState(initialStateId);
			this.targetState = this.getState(initialStateId);			
			this.transitioning = false;
			this.acceptStateHistory = new Array();
		}
	
		/*
		 * To be called on setup to give the machine a list of transitions between the states.
		 * 
		 * @param startStateId:String  The beginning state of the transition
		 * @param endStateId:String  The new state once the transition has finished
		 * @param transition:Transition  The transition between the two
		 * 
		 * @return void
		 * 
		 */
		public function addTransition(startStateId:String, endStateId:String, transition:Transition):void {
			transition.setNextStateId(endStateId);
			this.getState(startStateId, true).addTransition(this.getState(endStateId, true), transition);	
		}
	
		private function setCurrentStateId(currentStateId:String):void {
			this.currentState = this.getState(currentStateId);
			this.dispatchEvent(new StateEvent(StateEvent.CHANGE, currentStateId));
			if (this.currentState.getId() == this.targetState.getId()) {
				this.accept();
			}
			else {
				this.transition();
			}
		}
	
		/*
		 * To be called by an external class (navigation for example) to set a new target state.
		 * Once called the machine will begin transitions to the desired state
		 * 
		 * @param targetStateId:String  The desired state
		 * 
		 * @return void
		 * 
		 */		
		public function setTargetStateId(targetStateId:String):void {
			this.targetState = this.getState(targetStateId);
			this.transition();
		}
	
		public function getTargetStateId():String {
			return this.targetState.getId();
		}
	
		private function transition():void {
			if (!this.transitioning) {
				this.currentTransition = this.getTransition(this.currentState, this.targetState);
				if (this.currentTransition != null) {
					this.transitioning = true;
					this.currentTransition.resetIndex();
					this.beginNextTransitionStep();
				}
				else {
					throw new Error("No transition exists between the states \"" + this.currentState.getId() + "\" and \"" + this.targetState.getId() + "\"");
				}
			}
		}
		
		private function getTransition(startState:State, targetState:State):Transition {
			var path:Array = this.findShortestPath(startState, targetState, null, new Array(), new Dictionary());
			if (path != null) {
				var currentState:State = path.shift();
				var nextState:State = path.shift();
				return currentState.getTransition(nextState);
			}
			else {
				return null;
			}
		}
		
		private function findShortestPath(currentState:State, targetState:State, shortestPath:Array, currentPath:Array, currentVisitedStates:Dictionary):Array {
			var workingPath:Array = this.duplicateArray(currentPath); new Array(currentPath.length);
			workingPath.push(currentState);
			var workingVisitedStates:Dictionary = this.duplicateDictionary(currentVisitedStates);
			workingVisitedStates[currentState.getId()] = true;			
			if (currentState.getTransition(targetState) != null) {
				workingPath.push(targetState);
				shortestPath = getShorterPath(shortestPath, workingPath);
			}
			else {
				for each (var transition:Transition in currentState.getTransitions()) {
					if (!workingVisitedStates[transition.getNextStateId()]) {
						shortestPath = this.findShortestPath(this.getState(transition.getNextStateId()), targetState, shortestPath, workingPath, workingVisitedStates);
					}
				}
			}
			return shortestPath;
		}
		
		private function duplicateArray(array:Array):Array {
			var duplicate:Array = new Array(array.length);
			for (var i:uint = 0; i < array.length; i++) {
				duplicate[i] = array[i];
			}
			return duplicate;
		}
		
		private function duplicateDictionary(dictionary:Dictionary):Dictionary {
			var duplicate:Dictionary = new Dictionary();
			for (var key:Object in dictionary) {
			   duplicate[key] = dictionary[key];
			}
			return duplicate;
		}
		
		private function getShorterPath(shortestPath:Array, workingPath:Array):Array {
			if (shortestPath == null) {
				return workingPath;
			}
			else {
				if (workingPath.length < shortestPath.length) {
					return workingPath;
				}
				else {
					return shortestPath;
				}
			}
		}
	
		private function beginNextTransitionStep():void {
			if (this.currentTransition.hasNextTransitionStepId()) {
				this.currentTransitionStep = this.currentTransition.getNextTransitionStep();
				this.dispatchEvent(new TransitionStepEvent(TransitionStepEvent.BEGIN, this.currentTransitionStep));
				this.currentTransitionStep.begin();
			}
			else {
				this.transitioning = false;
				this.setCurrentStateId(this.currentTransition.getNextStateId());
			}
		}
	
	
		/*
		 * To be called by an external class when a transition step is finished	
		 * 
		 * @param func:Function  The function that has just been executed to completion
		 * 
		 * @return void
		 * 
		 */	
		public function completeTransitionStep(func:Function):void {
			// TODO make the func param optional?
			if (func == this.currentTransitionStep.func) {
				this.dispatchEvent(new TransitionStepEvent(TransitionStepEvent.COMPLETE, this.currentTransitionStep));
				this.beginNextTransitionStep();
			}
			else {
				throw new Error("An unexpected transition was completed");
			}
		}
	
		private function accept():void {
			this.acceptStateHistory.push(this.currentState.getId());
			this.dispatchEvent(new StateEvent(StateEvent.ACCEPT, this.currentState.getId()));
		}
		
		/*
		 * Returns a list of all previous states. Useful for providing "back button" functionality	
		 * 
		 * @return Array The list of all previous accept states
		 * 
		 */			
		public function getAcceptStateHistory():Array {
			return this.acceptStateHistory;
		}

		public function getCurrentStateId():String {
			return this.currentState.getId();
		}
	
		private function getState(stateId:String, createIfMissing:Boolean = false):State {
			if (this.states[stateId] != null) {
				return this.states[stateId];
			}
			else if (createIfMissing) {
				return this.createState(stateId);
			}
			else {
				throw new Error("State \"" + stateId + "\" does not exist");
			}
		}
		
		private function createState(stateId:String):State {
			var state:State = new State(stateId);
			this.states[stateId] = state;
			return state;
		}
	}
}