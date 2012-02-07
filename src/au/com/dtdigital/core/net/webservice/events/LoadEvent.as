/**
 * @author Johan Öbrink - Man Machine
 * @version 0.1
 * 
 * This event is dispatched when the WSDL document has loaded sucessfully.
 * Flash 9 version of mx.rpc.soap.LoadEvent
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
	import au.com.dtdigital.core.net.webservice.soap.WSDL;

	public class LoadEvent extends Event
	{
		public static const LOAD:String = "load";
		
		private var _document:XML;
		private var _wsdl:WSDL;
		
		public function LoadEvent(wsdl:WSDL, document:XML)
		{
			super(LOAD, false, false);
			_wsdl = wsdl;
			_document = document;
		}
		
		/** The parsed WSDL document. */
		public function get wsdl():WSDL { return _wsdl; }
		
		/** The raw XML for the WSDL document. */
		public function get document():XML { return _document; }
		
		public override function clone():Event {
			return new LoadEvent(wsdl, document);
		}
		
	}
}