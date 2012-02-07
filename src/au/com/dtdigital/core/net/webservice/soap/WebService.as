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
* Using this class will enable you to use web services without having to create SOAP requests manually.
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
	import flash.events.EventDispatcher;
	
	import au.com.dtdigital.core.net.webservice.events.*;
	
	[Event(name="load", type="se.manmachine.rpc.soap.LoadEvent")]
	[Event(name="fault", type="se.manmachine.rpc.events.FaultEvent")]
	
	public dynamic class  WebService extends EventDispatcher{
		private var __wsdl:WSDL;
		private var __availableMethods:Array;
		
		public function WebService(){};
		
		public function loadWsdl(wsdlUrl:String):void{
			__wsdl = new WSDL();
			__wsdl.addEventListener(LoadEvent.LOAD, wsdlComplete);
			__wsdl.addEventListener(FaultEvent.FAULT, wsdlFault);
			__wsdl.load(wsdlUrl);
		}
			
		private function wsdlComplete(event:LoadEvent):void{
			__availableMethods = event.wsdl.availableMethods;
			var a:Number;
			for(a=0;a<__availableMethods.length;a++){
				var method:WSMethod = new WSMethod();
				this[__availableMethods[a].name] = method.createMethod(__availableMethods[a].name, __availableMethods[a].param, __availableMethods[a].targetNS, __availableMethods[a].servicePath, __availableMethods[a].soapAction);
			}
			dispatchEvent(event);
		}
		
		private function wsdlFault(event:FaultEvent):void {
			dispatchEvent(event);
		}
		
		public function get availableMethods():Array{
			return __availableMethods;
		}
	}
	
}