/**
 * @author Johan Öbrink - Man Machine
 * @version 0.1
 * 
 * The base class for events that RPC services dispatch.
 * Flash 9 version of mx.rpc.events.AbstractEvent
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

	public class AbstractEvent extends Event
	{
		protected var _token:AsyncToken;
		
		public function AbstractEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * The token that represents the call to the method.
		 */
		public function get token():AsyncToken { return _token; }
		
	}
}