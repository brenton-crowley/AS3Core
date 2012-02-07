package au.com.dtdigital.core.utils {

	/**
	 * @author datwill
	 */
	public class ConvertSeconds {

		
		
		/*
		 * Pass in Milliseconds and returns a string that adds playback formatting
		 * 
		 * @param milliseconds:Number  The number of milliseconds that have elapsed 
		 * 
		 * @return String
		 * 
		 */
		
		public static function convertTime(milliseconds:Number):String {
		
			
			var fmtTime:String;
			var seconds:int = Math.floor(milliseconds);


			if(seconds < 10) {
				fmtTime = "00:0" + seconds;
			} else if(seconds < 60) {
				fmtTime = "00:" + seconds;
			} else if(seconds >= 60) {
				
				var mins:Number = Math.floor(seconds / 60);
				var secs:Number = Math.floor(seconds - (mins * 60));
				
				var fmtMins:String;
				var fmtSecs:String;
				
				if(mins < 10) {
					fmtMins = "0" + mins;	
				} else {
					fmtMins = mins.toString();	
				}
				
				if(secs < 10) {
					fmtSecs = "0" + secs;	
				} else {
					fmtSecs = secs.toString();	
				}
				
				fmtTime = fmtMins + ":" + fmtSecs;
			}
			return fmtTime;	
		}
	}
}
