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
	import au.com.dtdigital.core.net.webservice.AsyncToken;

	public dynamic class WSMethod {
		
		private var __action:String;
		private var __servicePath:String;
		private var __methodName:String;
		private var __params:Array;
		private var __targetNamespace:String;
		private var __proxy:WSProxy;
		private var __token:AsyncToken;
		
		public function WSMethod() {
			__proxy = WSProxy.getInstance();
		}
		
		public function get token():AsyncToken { return __token; }
		
		private function myMethod(...args):AsyncToken {
			__token = new AsyncToken();
			var params:String = new String();
			var a:Number;
			for(a=0;a<__params.length;a++){
				var argument:String = "";
				if(args[a] != undefined){
					argument = args[a];
					
					//for insert method, convert xml values to CDATA string, to avoid errors when soap requests is parsed as XML
					if(args[a] is XML){
						argument = "<![CDATA[" + args[a].toString() + "]]>";	
					}
				}
				params += '<' + __params[a] + '>' + argument + '</' + __params[a] + '>';
			}
			
			
	  
			var soapRequest:String = '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">';
			soapRequest += '<soap:Body>';
			soapRequest += '<' + __methodName + ' xmlns="' + __targetNamespace + '">';
			soapRequest += params;
			soapRequest += '</' + __methodName + '>';
			soapRequest += '</soap:Body>';
			soapRequest += '</soap:Envelope>';
			
			var request:XML = new XML(soapRequest);
			
			/**
			 * PUT SENDING ACTION HERE
			 */
			__proxy.callMethod(token, request, __servicePath, __action);
			
			return __token;
		}
		
		public function createMethod(name:String, param:Array, ns:String, service:String, action:String):Function {
			__servicePath = service;
			__methodName = name;
			__params = param;
			__targetNamespace = ns;
			__action = action;
			return myMethod;
		}
		
	}
	
}