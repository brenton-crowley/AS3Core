package au.com.dtdigital.core.state {
	import au.com.dtdigital.core.state.TransitionStep;		

	public class Transition {
	
		private var nextStateId:String;
		private var transitionSteps:Array;
		private var index:Number;
	
		public function Transition(transitionSteps:Array) {
			this.transitionSteps = transitionSteps;
			this.index = 0;
		}
	
		public function resetIndex():void {
			this.index = 0;
		}
	
		public function setNextStateId(nextStateId:String):void {
			this.nextStateId = nextStateId;
		}
	
		public function getNextStateId():String {
			return this.nextStateId;
		}
	
		public function hasNextTransitionStepId():Boolean {
			return this.transitionSteps[this.index] != null;
		}
	
		public function getNextTransitionStep():TransitionStep {
			var transitionStep:TransitionStep = this.transitionSteps[this.index];
			this.index++;
			return transitionStep;
		}
	}
}