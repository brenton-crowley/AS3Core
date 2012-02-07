package au.com.dtdigital.core.utils
{
	import flash.system.Capabilities;	

	/**
	 * @author JCope
	 */
	public class PlayerVersionDetection 
	{
		private static var majorVersion:Number;
		private static var minorVersion:Number;
		private static var buildNumber:Number;
		private static var fullscreenCapable:Boolean;

		public function PlayerVersionDetection() 
		{
			
		}
		
		private static function getVersion():void
		{
			var versionString:String = Capabilities.version;
			var versionArray:Array = versionString.split(",");			
			var platformAndVersion:Array = versionArray[0].split(" ");		
				
			majorVersion = parseInt(platformAndVersion[1]);
			minorVersion = parseInt(versionArray[1]);
			buildNumber = parseInt(versionArray[2]);
			
			trace(majorVersion, minorVersion, buildNumber);
		}

		
		
		public static function getMajorVersion():Number 
		{
			getVersion();
			return majorVersion;
		}

		public static function getMinorVersion():Number 
		{
			getVersion();
			return minorVersion;
		}

		public static function getBuildNumber():Number 
		{
			getVersion();
			return buildNumber;
		}

		public static function isFullscreenCapable():Boolean 
		{
			getVersion();
			if(majorVersion < 9) {
				fullscreenCapable = false;
			} else if(majorVersion == 9 && buildNumber >= 124) {
				fullscreenCapable = true;
			} else if(majorVersion == 9 && buildNumber < 124) {
				fullscreenCapable = false;
			} else {
				fullscreenCapable = true;
			}
			return fullscreenCapable;
		}

	}
}

