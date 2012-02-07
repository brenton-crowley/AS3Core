package au.com.dtdigital.core.utils.data {

	/**
	 * @author BCrowley
	 */
	public class MonthData {

		private var abbreviatedName:String;
		private var fullname:String;
		private var maxNoDays:uint;

		public function MonthData(abbreviatedName:String, fullname:String, maxNoDays:uint) {
			
			this.abbreviatedName = abbreviatedName;
			this.fullname = fullname;
			this.maxNoDays = maxNoDays;
		}
		
		public function getAbbreviatedName():String {
			return abbreviatedName;
		}
		
		public function getFullname():String {
			return fullname;
		}
		
		public function getMaxNoDays():uint {
			return maxNoDays;
		}
	}
}
