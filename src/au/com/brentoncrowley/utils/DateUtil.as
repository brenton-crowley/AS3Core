/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/9/12
 * Time: 14:27
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.utils {

    import au.com.brentoncrowley.utils.data.MonthData;

    public class DateUtil {

        // STATIC PROPERTIES

		public static const ON_INVALID_DATE:String = "onInvalidDate";
		public static const ON_INVALID_MONTH:String = "onInvalidMonth";

		public static const monthDatas:Array = [new MonthData("Jan", "Januray", 31),
												new MonthData("Feb", "February", 28),
												new MonthData("Mar", "March", 31),
												new MonthData("Apr", "April", 30),
												new MonthData("May", "May", 31),
												new MonthData("Jun", "June", 30),
												new MonthData("Jul", "July", 31),
												new MonthData("Aug", "August", 31),
												new MonthData("Sep", "September", 30),
												new MonthData("Oct", "October", 31),
												new MonthData("Nov", "November", 30),
												new MonthData("Dec", "December", 31)
												];

		private static const TOTAL_DAYS:uint = 30;


		/*
		 * Randomises the elements of an array by returning a copy.
		 *
		 * @param year:uint Year you are comparing
		 * @param month:uint Month you are comparing
		 * @param day:uint Day you are comparing
		 * @param minAge:uint Minimum age requirement
		 * @param originDate:Date OPTIONAL enter a server date for more secure source. Defaults to new Date()
		 *
		 * @event listen for DateUtil.ON_INVALID_DATE for invalid date entries.
		 *
		 * @return Boolean
		 *
		 */

		public static function verifyAge(year:uint, month:uint, day:int, minAge:uint, originDate:Date = null):Boolean {
			if(month != 0){
				var leapYearModulo4:int = year % 4;
				var leapYearModulo100:int = year % 100;
				var leapYearModulo400:int = year % 400;
				var maxDaysOfMonth:int = monthDatas[month -1].getMaxNoDays();
				var feb29Days:int = monthDatas[1].getMaxNoDays()+1;

				if((day > 0 && day <= maxDaysOfMonth) ||
				  (((leapYearModulo4 == 0 && leapYearModulo100 != 0) &&  day == feb29Days) || leapYearModulo400 == 0)){
					var currentDate:Date;
					if(originDate == null){
						currentDate = new Date();
					}else{
						currentDate = originDate;
					}
					var minDate:Date = new Date();
					var ageDate:Date = new Date(year, month-1, day);
					minDate.setFullYear(currentDate.getFullYear() - minAge);
					var ageEpoch:Number = ageDate.time;
					var minEpoch:Number = minDate.time;

					if(ageEpoch < minEpoch){
						return true;
					}else{
						return false;
					}
				}else{
					var reason:String;
					if(day > monthDatas[month -1].getMaxNoDays() || day < 1){
						reason = "Day: *** " + day + " *** is an invalid number for month: *** " + monthDatas[validateMonth(month)-1].getFullname() + " ***";
					}
					if(((leapYearModulo4 == 0 && leapYearModulo100 != 100) &&  day == feb29Days) || leapYearModulo400 == 0){
						reason = "Not a valid date for a non leap year.";
					}
					throw new Error("ERROR - Invalid Date - DateUtil: " + reason);
					return false;
				}
			}
			return false;
		}

		/*
		 * Returns an array of numbers with a leading zero for numbers 1-9. eg. 01, 02, 03...
		 *
		 * @return Array
		 *
		 */

		public static function getleadingZeroDaysList():Array{
			var leadingZeroDays:Array = [];

			for (var i:uint = 0;i < TOTAL_DAYS; i++) {
				if(i < 9){
					leadingZeroDays.push("0" +(i+1));
				}else{
					leadingZeroDays.push(i+1);
				}
			}
			return leadingZeroDays;
		}


		/*
		 * Returns an array of calendar numbers with a leading zero for numbers 1-9. eg. 01, 02, 03...
		 *
		 * @return Array
		 *
		 */

		public static function getDaysList():Array{
			var days:Array = [];

			for (var i:uint = 0;i < TOTAL_DAYS; i++) {
				days.push(i+1);
			}
			return days;
		}


		/*
		 * Returns an array of calendar months in full. Eg. "January", "February"...
		 *
		 * @return Array
		 *
		 */

		public static function getFullnameMonths():Array {
			var fullnameMonths:Array = [];
			for (var i:uint = 0; i < monthDatas.length; i++) {
				fullnameMonths.push(monthDatas[i].getFullname());
			}
			return fullnameMonths;
		}


				/*
		 * Returns an array of calendar months in number format, with or without a leading zero. Eg. "01", "1"...
		 *
		 * @return Array
		 *
		 */

		public static function getNumberMonths(withLeadingZero:Boolean = true):Array {
			var numberMonths:Array = [];
			for (var i:uint = 0;i < monthDatas.length; i++) {
				if(withLeadingZero){
					if(i < 9){
						numberMonths.push("0" +(i+1));
					}else{
						numberMonths.push(i+1);
					}
				}else{
					numberMonths.push(i+1);
				}
			}
			return numberMonths;
		}


		/*
		 * Returns an array of calendar months in abbreviated format. Eg. "Jan", "Feb"...
		 *
		 * @return Array
		 *
		 */

		public static function getAbbreviatedMonths():Array {
			var abbreviatedMonths:Array = [];
			for (var i:uint = 0; i < monthDatas.length; i++) {
				abbreviatedMonths.push(monthDatas[i].getAbbreviatedName());
			}
			return abbreviatedMonths;
		}

		/*
		 * Converts a string or a number to a valid month for the ageVerification. If the month cannot be found then
		 * it will throw an error. Valid parameters include: "Jan", "January", "1", "01", 1
		 *
		 * @event listen for DateUtil.ON_INVALID_MONTH for invalid month entries.
		 *
		 * @param month:* Can be a string or number
		 *
		 * @return uint
		 *
		 */

		public static function validateMonth(month:*):uint{
			var validMonth:uint = parseInt(month);
			if(validMonth == 0){
				var m:String = month;
				var abbreviatedMonths:Array = getAbbreviatedMonths();
				var monthNameTrimmed:String = m.slice(0,3);
				for (var i:uint = 0; i < abbreviatedMonths.length; i++) {
					if(abbreviatedMonths[i].toUpperCase() == monthNameTrimmed.toUpperCase()){
						trace("abbreviatedMonths[i]: " + abbreviatedMonths[i].toUpperCase());
						return i+1;
					}
				}

				throw new Error("ERROR - Not a Valid Month - DateUtil");
				return null;

			}else if(validMonth <= 12){
				return validMonth;
			}else{
				throw new Error("ERROR - Not a Valid Month - DateUtil");
			}
			return null;
		}


    	/*
    	 *
    	 * Compares the two specified Date objects to see if they're equal.
    	 *
    	 * @param d1:Date
    	 * @param d2:Date
    	 *
	     * @return Boolean
	     *
    	 */

		public static function equals(d1:Date, d2:Date):Boolean {
			if (!d2) return false;
			return d1.valueOf() == d2.valueOf();
		}
    }
}
