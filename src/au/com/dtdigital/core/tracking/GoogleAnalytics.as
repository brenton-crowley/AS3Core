package au.com.dtdigital.core.tracking {
	
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;	
	
	/**
	 * @author JCope
	 */
	 
	public class GoogleAnalytics {
		private static const FUNCTION_NAME:String = "pageTracker._trackPageview";
		private static const EVENT_FUNCTION_NAME:String = "pageTracker._trackEvent";

		private static const TRACE_PREFIX:String = "pageTracker._trackPageview";
		private static const EVENT_TRACE_PREFIX:String = "pageTracker._trackEvent";

		
		public static function trackPageview(pageViewId:String ):void {
			
			var trackString:String = pageViewId;
			
				if (ExternalInterface.available) {
					ExternalInterface.call( FUNCTION_NAME, trackString );
				}
				else {
					var url:String = "javascript:" + FUNCTION_NAME + "('" + trackString + "')";
					var urlRequest:URLRequest = new URLRequest(url);
					navigateToURL(urlRequest);
				}
			
			trace(TRACE_PREFIX + "(" + trackString + ")");
		}
		
		public static function trackEvent(category:String, action:String, label:String=null, value:*=null ):void {
			var trackString:String = category + ', ' + action + ', ' + label + ', ' + value;			
			
				if (ExternalInterface.available) {
					if ( label == null && value == null ) {
						ExternalInterface.call( EVENT_FUNCTION_NAME, category, action );
					} else if ( value == null ) {
						ExternalInterface.call( EVENT_FUNCTION_NAME, category, action, label );
					} else {
						ExternalInterface.call( EVENT_FUNCTION_NAME, category, action, label, value );
					}					
				}
				else {
					var url:String = "javascript:" + EVENT_FUNCTION_NAME + "('" + trackString + "')";
					var urlRequest:URLRequest = new URLRequest(url);
					navigateToURL(urlRequest);
				}
			
			trace(EVENT_TRACE_PREFIX + "(" + trackString + ")");
		}
		
	}
}
