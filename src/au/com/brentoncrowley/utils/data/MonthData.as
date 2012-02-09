/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/9/12
 * Time: 14:27
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.utils.data {

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
