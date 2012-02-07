/**
 * @author Johan Öbrink - Man Machine
 * @version 0.1
 * 
 * The event that indicates an RPC operation has successfully returned a result.
 * Flash 9 version of mx.rpc.events.ResultEvent
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
	
	public class ResultEvent extends AbstractEvent
	{
		public static const RESULT:String = "result";
		
		protected var _result:Object;
		
		public function ResultEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true, result:Object = null, token:AsyncToken = null)
		{
			super(type, bubbles, cancelable);
			_result = result;
			_token = token;
		}
		
		/** Result that the RPC call returns. */
		public function get result():* { return _result; }
		
		public override function clone():Event {
			return new ResultEvent(type, bubbles, cancelable, result, token);
		}
		
	}
}