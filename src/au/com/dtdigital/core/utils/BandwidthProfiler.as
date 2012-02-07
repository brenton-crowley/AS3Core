package au.com.dtdigital.core.utils {

	import flash.display.LoaderInfo;	
	import flash.events.SecurityErrorEvent;	
	import flash.events.IOErrorEvent;	
	import flash.net.URLRequest;	
	import flash.display.Loader;	
	import flash.system.Capabilities;	
	import flash.events.Event;	
	import flash.display.Sprite;
	import flash.utils.getTimer;	
	
	/**
	 * @author bkanizay
	 */
	public class BandwidthProfiler extends Sprite {

		private static const DEFAULT_BANDWIDTH:String = "low";
		private static const DEFAULT_BANDWIDTH_SPEED:Number = 500;

		private static var bandwidthDetected:String;
		private static var bandwidthSpeedDetected:Number;

		private var startTime:uint;
		private var testImage:String;
		
		public function BandwidthProfiler(testImage:String) {
			this.testImage = testImage;
		}

		public function getBandwidth():String {
			return bandwidthDetected;
		}

		public function getBandwidthSpeed():Number {
			return bandwidthSpeedDetected;
		}
		
	
		public function checkBandwidth():void {
			var loader:Loader = new Loader();
			var request:URLRequest = new URLRequest(this.testImage + this.getCacheBlocker());
			loader.contentLoaderInfo.addEventListener(Event.OPEN, this.startHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.completeHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, this.ioErrorHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR, this.ioErrorHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.VERIFY_ERROR, this.ioErrorHandler);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.ioErrorHandler);
			loader.load(request);
		}
		
		private function startHandler(event:Event):void {
			startTime = getTimer();
		}
		
		private function completeHandler(event:Event):void {
			var time:Number = (getTimer() - startTime) / 1000;
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			bandwidthSpeedDetected = Math.round((loaderInfo.bytesTotal / 1000 * 8) / time);
			bandwidthDetected = (bandwidthSpeedDetected > DEFAULT_BANDWIDTH_SPEED) ? "high" : "low";
			this.dispatchCompleteEvent();
		}
		
		private function getCacheBlocker():String {
			if ((Capabilities.playerType == "External" || Capabilities.playerType == "StandAlone")) {
				return "";
			}
			else {
				var date:Date = new Date();
				var time:Number = date.getTime();
				return "?t=" + time.toString();
			}
		}
		
		private function dispatchCompleteEvent():void {
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function ioErrorHandler(e:Event):void {
			bandwidthDetected = DEFAULT_BANDWIDTH;
			bandwidthSpeedDetected = DEFAULT_BANDWIDTH_SPEED;
			this.dispatchCompleteEvent();
		}

	}

}
