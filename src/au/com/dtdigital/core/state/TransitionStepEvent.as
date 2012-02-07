package au.com.dtdigital.core.state {
	import au.com.dtdigital.core.state.TransitionStep;
	
	import flash.events.Event;	

	/**
	 * @author OCampbell
	 */
	public class TransitionStepEvent extends Event {
		
		public static const BEGIN:String = "beginTransitionStep";
		public static const COMPLETE:String = "completeTransitionStep";
		
		public var transitionStep:TransitionStep;
		public var data:*;
		
		public function TransitionStepEvent(type:String, transitionStep:TransitionStep, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.transitionStep = transitionStep;
		}		
	}
}
