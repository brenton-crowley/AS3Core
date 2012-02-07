package au.com.dtdigital.core.state {
	import flash.events.Event;	

	/**
	 * @author OCampbell
	 */
	public class StateEvent extends Event {
		
		public static const CHANGE:String = "changeState";
		public static const ACCEPT:String = "acceptState";
		
		public var stateId:String;
		
		public function StateEvent(type:String, stateId:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.stateId = stateId;
		}		
	}
}
