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
	import flash.events.ErrorEvent;	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import au.com.dtdigital.core.net.webservice.Fault;
	import au.com.dtdigital.core.net.webservice.events.*;
	
	[Event(name="load", type="se.manmachine.rpc.soap.LoadEvent")]
	[Event(name="fault", type="se.manmachine.rpc.events.FaultEvent")]
	public class WSDL extends EventDispatcher {
		
		private var __portType:String = "";
		private var __wsdlPath:String;
		private var __servicePath:String;
		private var __rawWSDL:XML;
		private var __availableMethods:Array;
		
		public function WSDL(path:String=null) {
			__wsdlPath = path;
		}
		
		private function wsdlLoaded(evt:Event):void{
			try {
				__rawWSDL = new XML(evt.target["data"]);
				var portType:String = getPortType(__rawWSDL);
				var bindingType:String = getBinding(portType);
				var methodList:XMLList = getMethodList(bindingType);
				__availableMethods = getAvailableMethods(methodList);
				var loadEvent:LoadEvent = new LoadEvent(this, __rawWSDL);
				dispatchEvent(loadEvent);
			} catch (error:Error)
			{
				trace("wsdl could not be parsed as xml: \n");	
				wsdlLoadError(new ErrorEvent(ErrorEvent.ERROR));
			}
		}
		
		private function wsdlLoadError(event:Event):void {
			var fault:Fault = new Fault(event.type, Object(event)["text"]);
			dispatchEvent(FaultEvent.createEvent(fault));
		}
		
		private function getPortType(rawWSDL:XML):String{
			var wsdl:Namespace = rawWSDL.namespace();
			var portType:XMLList = rawWSDL.wsdl::portType;
			var portTypeAmount:Number = portType.length();
			if(portTypeAmount == 1){
				return (portType.@name);
			} else {
				if(__portType != ""){
					return __portType;
				} else {
					return portType[0].@name;
				}
			}
			return "";
		}
		
		/*private function getBinding(portType:String):String{
			var wsdl:Namespace = __rawWSDL.namespace();
			var service:XMLList = __rawWSDL.wsdl::service;
			var myPort:XMLList = service.wsdl::port.(@name == portType);
			var addressNS:Namespace = service.wsdl::port.children()[0].namespace();
			__servicePath = service.wsdl::port.addressNS::address.@location;
			var binding:String = myPort.@name;
			return(binding);
		}*/
		
		/** Modified by Vladimir @ xitexsoftware.com */
		private function getBinding(portType:String):String{
			var wsdl:Namespace = __rawWSDL.namespace();
			var service:XMLList = __rawWSDL.wsdl::service;
			// var myPort:XMLList = service.wsdl::port.(@name == portType);
			var binding:XMLList = __rawWSDL.wsdl::binding.(@type.substr(@type.indexOf(":")+1) == portType);
			var addressNS:Namespace = service.wsdl::port.children()[0].namespace();
			__servicePath = service.wsdl::port.addressNS::address.@location;
			
			var bindingAmount:Number = binding.length();
			if(bindingAmount == 1){
				return (binding.@name);
			} else if(bindingAmount >0 ) {
				return binding[0].@name;
			}
			return("");
		}
		
		private function getMethodList(bindingType:String):XMLList{
			var wsdl:Namespace = __rawWSDL.namespace();
			var binding:XMLList = __rawWSDL.wsdl::binding.(@name == bindingType);
			var methodList:XMLList = binding.wsdl::operation;
			return methodList;
		}
		
		private function getAvailableMethods(methodNames:XMLList):Array{
			var wsdl:Namespace = __rawWSDL.namespace();
			var s:Namespace = __rawWSDL.wsdl::types.children()[0].namespace();
			var schema:XMLList = __rawWSDL.wsdl::types.s::schema;
			var elements:XMLList = schema.s::element;
			return constructSchema(methodNames, elements);
		}
		
		private function constructSchema(methods:XMLList, schema:XMLList):Array{
			var names:XMLList = methods.@name;
			var wsdl:Namespace = __rawWSDL.namespace();
			var s:Namespace = __rawWSDL.wsdl::types.children()[0].namespace();
			var ns:String = __rawWSDL.@targetNamespace;
			var availableMethods:Array = new Array();
			var a:Number;
			for(a=0;a<names.length();a++){
				var tempMethod:XMLList = methods.(@name == names[a]);
				var tempNS:Namespace = tempMethod.children()[0].namespace();
				var action:String = tempMethod.tempNS::operation.@soapAction;
				var b:Number;
				for(b=0;b<schema.length();b++){
					if(names[a] == schema[b].@name){
						var params:XMLList = schema[b].s::complexType.s::sequence.s::element.@name;
						var parameters:Array = new Array();
						var c:Number;
						for(c=0;c<params.length();c++){
							parameters.push(params[c]);
						}
						var method:Object = {name: names[a], param: parameters, targetNS: ns, servicePath: __servicePath, soapAction: action};
						availableMethods.push(method);
					}
				}
			}
			return availableMethods;
		}
		
		public function get xml():XML { return __rawWSDL; }
		public function get availableMethods():Array { return __availableMethods; }
		
		public function load(path:String=null):void {
			if(path != null) __wsdlPath = path;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, wsdlLoaded);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, wsdlLoadError);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, wsdlLoadError);
			urlLoader.load(new URLRequest(__wsdlPath));
		}
		
		public function set portType(port:String):void{
			__portType = port;
		}
	}
	
}