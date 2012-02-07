package au.com.dtdigital.core.net.webservice 
{
	import au.com.dtdigital.core.dtdbug.DTDBugColour;	
	import au.com.dtdigital.core.dtdbug.DTDBug;	
	
	import flash.events.EventDispatcher;
	
	import au.com.dtdigital.core.net.webservice.AsyncToken;
	import au.com.dtdigital.core.net.webservice.events.FaultEvent;
	import au.com.dtdigital.core.net.webservice.events.LoadEvent;
	import au.com.dtdigital.core.net.webservice.events.ResultEvent;
	import au.com.dtdigital.core.net.webservice.events.WebserviceConsumerEvent;
	import au.com.dtdigital.core.net.webservice.soap.WebService;			


	/**
	 * @author JCope
	 * 
	 */	 
	 
	public class WebserviceConsumer extends EventDispatcher	
	{
		protected static const DEFAULT_WSDL_PATH_RELATIVE:String = "Webservices/API.asmx?WSDL";
		
		protected var defaultWsdlTestPath:String = "http://localhost/honda/webservices/dtdmanage/Webservices/API.asmx?WSDL";		
		protected var service:WebService;
		
		private var isWebserviceLoaded:Boolean = false;
		private var wsdl:String;

		
		// START PUBLIC METHODS
		// ---------------------------				
		
		/*
		 * 	@param swfPath The path of the current swf file, use this.loaderInfo.loaderURL of document class
		 */ 
		public function loadDefaultWSDL(swfPath:String = null):void
		{	
			if(swfPath == null)
			{
				//if loaded from browser, will set wsdl to relative default
				this.wsdl = DEFAULT_WSDL_PATH_RELATIVE;
			}
			else
			{
				if(swfPath.indexOf("http") == -1)
				{
					//if loaded from flash player, will set wsdl to test default path
					DTDBug.logWithLabel("Using Test wsdl", defaultWsdlTestPath, DTDBugColour.WARNING);
					this.wsdl = defaultWsdlTestPath;	
				}
			}
		
			this.loadWsdl(this.wsdl);
		}		
		
		
		/*
		 * 	@param wsdl:String  The WSDL path
		 */	
		public function loadWsdl(wsdl:String):void 
		{
			DTDBug.logWithLabel("WebserviceConsumer.loadWsdl", wsdl);
			this.wsdl = wsdl;
			this.service = new WebService();
			this.service.addEventListener(LoadEvent.LOAD, this.onWsdlLoad);
			this.service.addEventListener(FaultEvent.FAULT, this.onWsdlLoadError);
			this.service.loadWsdl(this.wsdl);
		}
		
		public function getIsWebserviceLoaded():Boolean	{
			return this.isWebserviceLoaded;
		}
	
		

		// START RESULT EVENT HANDLERS
		// ---------------------------
		
		protected function onWsdlLoad(event:LoadEvent):void	{
			DTDBug.logWithLabel("WebserviceConsumer.onWsdlLoad", "SUCCESS", DTDBugColour.GREEN);
			this.isWebserviceLoaded = true;
			this.dispatchEvent(new WebserviceConsumerEvent(WebserviceConsumerEvent.LOAD));
		}

		protected function onWsdlLoadError(event:FaultEvent):void {
			DTDBug.logWithLabel("WebserviceConsumer.onWsdlLoadError", event.fault, DTDBugColour.ERROR);
			this.dispatchEvent(new WebserviceConsumerEvent(WebserviceConsumerEvent.LOAD_ERROR, event.fault));
		}
		
		protected function onFault(event:FaultEvent):void {
			DTDBug.logWithLabel("WebserviceConsumer.onFault", event.fault, DTDBugColour.ERROR);
			event.token.removeEventListener(FaultEvent.FAULT, onFault);
			this.dispatchEvent(new WebserviceConsumerEvent(WebserviceConsumerEvent.FAULT, event.fault));
		}
		
		private function onSelectResult(event:ResultEvent):void
		{
			DTDBug.log("WebserviceConsumer.onSelectResult", DTDBugColour.SUCCESS);
			this.concludeWebserviceCall(this.onSelectResult, event, WebserviceConsumerEvent.ON_RESULT_SUCCESS);
		}

		
		
		
		// START PRIVATE WEBSERVICE METHODS
		// --------------------------------

		protected function makeWebServiceCall(method:Function, params:Array, resultHandler:Function = null):void {
			try {
				var fullParams:Array = new Array();
				fullParams = fullParams.concat(params);
				var asyncToken:AsyncToken = method.apply(this, fullParams);  // applies fullParams array as individual arguments
				asyncToken.addEventListener(FaultEvent.FAULT, this.onFault);
				if (resultHandler != null) {
					asyncToken.addEventListener(ResultEvent.RESULT, resultHandler);
				}
			}
			catch (error:Error) {
				DTDBug.logWithLabel("WebserviceConsumer.makeWebServiceCall", error.message, DTDBugColour.ERROR);
			}
		}
		
		protected function concludeWebserviceCall(listenerFunction:Function, event:ResultEvent, eventName:String = null):void {
			event.token.removeEventListener(ResultEvent.RESULT, listenerFunction);
			event.token.removeEventListener(FaultEvent.FAULT, this.onFault);
			if (eventName != null) {
				var result:XML = new XML(event.result.toString());
				this.dispatchEvent(new WebserviceConsumerEvent(eventName, result));
			}
		}
		
		// ------------------------------
		// END PRIVATE WEBSERVICE METHODS		

	}
}
