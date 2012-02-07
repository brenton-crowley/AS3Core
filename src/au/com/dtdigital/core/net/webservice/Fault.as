/**
 * @author Johan Öbrink - Man Machine
 * @version 0.1
 * 
 * Object that represents a fault in an remote procedure call (RPC) service invocation.
 * Flash 9 version of mx.rpc.Fault
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
	public class Fault extends Error
	{
		private var _faultCode:String;
		private var _faultString:String;
		private var _faultDetail:String;
		
		public function Fault(faultCode:String, faultString:String, faultDetail:String = null) {
			super(faultCode + ": " + faultString);
			_faultCode = faultCode;
			_faultString = faultString;
			_faultDetail = faultDetail;
		}
		
		/** A simple code describing the fault. */
		public function get faultCode():String { return _faultCode; }
		
		/** Text description of the fault. */
		public function get faultString():String { return _faultString; }
		
		/** Any extra details of the fault. */
		public function get faultDetail():String { return _faultDetail; }
		
		public function toString():String {
			return "[Fault (faultCode=" + faultCode + ", faultString=" + faultString + ", faultDetail=" + faultDetail + ")]";
		}
	}
}