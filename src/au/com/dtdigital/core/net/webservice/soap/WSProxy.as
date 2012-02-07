/**
 * @author Johan Öbrink - Man Machine
 * @version 0.1
 * 
 * This code is copied from Carlo Alducentes alducente.services.WebService and modified by me.
 * No permission is yet given by Carlo for this. The full, original copyright notice is included below.
 * 
 * //Use, spread, modify, improve. <-- Commented, ok?
 * Man Machine (2007)
 * http://www.man-machine.se
 * johan@man-machine.se
 * 
 * Mensch Machine - Ein Wesen und ein Ding
*/
/**
* ...
* @author Carlo Alducente
* @version 0.1
* 
* 
Copyright (c) 2007 Carlo Alducente

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package au.com.dtdigital.core.net.webservice.soap 
{
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	
	import au.com.dtdigital.core.net.webservice.AsyncToken;
	import au.com.dtdigital.core.net.webservice.Fault;
	import au.com.dtdigital.core.net.webservice.events.FaultEvent;
	import au.com.dtdigital.core.net.webservice.events.ResultEvent;
	
	public class WSProxy {
		
		private static var __instance:WSProxy;
		
		private var _urlLoader:URLLoader;
		private var _token:AsyncToken;
		private var _callQueue:Array = new Array();
		private var _busyOnCall:Boolean = false;
		private var _action:String;
		
		public function WSProxy(){}
		
		public static function getInstance():WSProxy{
			if(__instance == null){
				__instance = new WSProxy();
			}
			return __instance;
		}
		
		private function callService(token:AsyncToken, request:XML, servicePath:String, action:String):void{
			_token = token;
			_action = action;
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.contentType = "text/xml; charset=utf-8";
			urlRequest.method = "POST";
			urlRequest.url = servicePath;
			var soapAction:URLRequestHeader = new URLRequestHeader("SOAPAction", action);
			urlRequest.requestHeaders.push(soapAction);
			urlRequest.data = request;
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, onComplete);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			_urlLoader.load(urlRequest);
		}
		
		private function onComplete(evt:Event):void {
			var responseXML:XML = new XML(_urlLoader.data);
			var result:* = responseXML.*.*.*;
			var resultEvent:ResultEvent = new ResultEvent(ResultEvent.RESULT, false, true, result, _token);
			_token.dispatchEvent(resultEvent);
			_busyOnCall = false;
			if(_callQueue.length > 0) {
				callService(_callQueue[0].token, _callQueue[0].req, _callQueue[0].path, _callQueue[0].soapAction);
				_callQueue.splice(0,1);
			}
		}
		
		private function onError(event:Event):void {
			var fault:Fault;
			if(event is IOErrorEvent) {
				var ioee:IOErrorEvent = event as IOErrorEvent;
				fault = new Fault(ioee.type, ioee.text);
			} else {
				var see:SecurityErrorEvent = event as SecurityErrorEvent;
				fault = new Fault(see.type, see.text);
			}
			var faultEvent:FaultEvent = new FaultEvent(FaultEvent.FAULT, false, true, fault, _token);
			_token.dispatchEvent(faultEvent);
		}
		
		public function callMethod(token:AsyncToken, request:XML, servicePath:String, action:String):void{
			//trace(request);
			if(!_busyOnCall){
				_busyOnCall = true;
				callService(token, request, servicePath, action);
			} else {
				_callQueue.push({token: token, req: request, path: servicePath, soapAction: action});
			}
		}
		
	}
	
}