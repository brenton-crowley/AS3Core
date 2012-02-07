/**
 * @author Johan Öbrink - Man Machine
 * @version 1.0
 * 
 * This interface provides the contract for any service that needs to respond to remote or asynchronous calls.
 * Flash 9 version of mx.rpc.IResponder
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
	public interface IResponder
	{
		/** This method is called by a service when the return value has been received. */
		function result(data:*):void;
		
		/** This method is called by a service when an error has been received. */
		function fault(info:*):void;
	}
}