/**
 * @author Johan Öbrink - Man Machine
 * @version 0.1
 * 
 * This event is dispatched when an RPC call has a fault.
 * Flash 9 version of mx.rpc.events.FaultEvent
 * 
 * Use, spread, modify, improve.
 * Man Machine (2007)
 * http://www.man-machine.se
 * johan@man-machine.se
 * 
 * Mensch Machine - Ein Wesen und ein Ding
*/

package au.com.dtdigital.core.net.webservice.events
{
	import flash.events.Event;
	
	import au.com.dtdigital.core.net.webservice.AsyncToken;
	import au.com.dtdigital.core.net.webservice.Fault;
	
	public class FaultEvent extends AbstractEvent
	{
		public static const FAULT:String = "fault";
		
		private var _fault:Fault;
		
		public function FaultEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=true, fault:Fault=null, token:AsyncToken=null) {
			super(type, bubbles, cancelable);
			_fault = fault;
			_token = token;
		}
		
		/**
		 * The Fault object that contains the details of what caused this event.
		 */
		public function get fault():Fault { return _fault; }
		
		public override function clone():Event {
			return new FaultEvent(type, bubbles, cancelable, fault, token);
		}
		
		
		/**
		 * Create a new FaultEvent. The fault is a required parameter while the call is optional.
		 */
		 public static function createEvent(fault:Fault, token:AsyncToken=null):FaultEvent {
			return new FaultEvent(FaultEvent.FAULT, false, true, fault, token);
		}
	}
}