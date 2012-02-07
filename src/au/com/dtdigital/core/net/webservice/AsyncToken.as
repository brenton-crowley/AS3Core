/**
 * @author Johan Öbrink - Man Machine
 * @version 0.1
 * 
 * This class provides a place to set additional or token-level data for asynchronous rpc operations. 
 * It also allows an IResponder to be attached for an individual call. The AsyncToken can be referenced 
 * in ResultEvent and FaultEvent from the token property.
 * Flash 9 version of mx.rpc.AsyncToken
 * 
 * Use, spread, modify, improve.
 * Man Machine (2007)
 * http://www.man-machine.se
 * johan@man-machine.se
 * 
 * Mensch Machine - Ein Wesen und ein Ding
*/

package au.com.dtdigital.core.net.webservice
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import au.com.dtdigital.core.net.webservice.events.FaultEvent;
	import au.com.dtdigital.core.net.webservice.events.ResultEvent;
	
	[Event(name="result", type="se.manmachine.rpc.events.ResultEvent")]
	[Event(name="fault", type="se.manmachine.rpc.events.FaultEvent")]
	public class AsyncToken extends EventDispatcher
	{
		private var _responders:Array = [];
		private var _result:*;
		
		public function AsyncToken() {
			super();
		}
		
		/** Adds a responder to an Array of responders. */
		public function addResponder(responder:IResponder):void {
			if(responder == null) return;
			for each(var responderInList:IResponder in _responders) {
				if(responderInList == responder) return;
			}
			_responders.push(responder);
		}
		
		/** Removes a responder from an Array of responders. */
		public function removeResponder(responder:IResponder):void {
			if(responder == null) return;
			for(var i:int=0; i < _responders.length; i++) {
				if(_responders[i] == responder) {
					_responders = _responders.splice(i, 1);
				}
			}
		}
		
		/** Determines if this token has at least one mx.rpc.IResponder registered. */
		public function hasResponder():Boolean { return _responders.length > 0; }
		
		/** An array of IResponder handlers that will be called when the asynchronous request completes. */
		public function get responders():Array { return _responders; }
		
		/** The result that was returned by the associated RPC call. */
		public function get result():* { return _result; }
		
		public override function dispatchEvent(event:Event):Boolean {
			var responder:IResponder;
			if(event is ResultEvent) {
				var re:ResultEvent = event as ResultEvent;
				_result = re.result;
				for each(responder in responders) {
					responder.result(re.result);
				}
			} else if(event is FaultEvent) {
				var fe:FaultEvent = event as FaultEvent;
				for each(responder in responders) {
					responder.fault(fe.fault);
				}
			}
			return super.dispatchEvent(event);
		}
	}
}