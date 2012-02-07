package au.com.dtdigital.core.net.webservice.events 
{
	import au.com.dtdigital.core.event.ParamEvent;	
	
	/**
	 * @author JCope
	 */
	public class WebserviceConsumerEvent extends ParamEvent 
	{
		public static const LOAD:String = "onLoad";
		public static const LOAD_ERROR:String = "onLoadError";
		public static const FAULT:String = "onFault";
		public static const ON_RESULT_SUCCESS:String = "onResultSuccess";
		public static const ON_INSERT_SUCCESS:String = "onInsertSuccess";
		public static const ON_INSERT_FAIL:String = "onInsertFail";
		public static const ON_UPDATE_SUCCESS:String = "onUpdateSuccess";
		public static const ON_UPDATE_FAIL:String = "onUpdateFail";
		public static const ON_MAIL_SUCCESS:String = "onMailSuccess";
		public static const ON_RESULT_FAIL:String = "onResultFail";
		
		public function WebserviceConsumerEvent(event:String, data:* = null) {
			super(event, data);
		}
	}
}
