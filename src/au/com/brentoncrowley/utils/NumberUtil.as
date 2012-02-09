/**
 * Created by IntelliJ IDEA.
 * User: Brenton
 * Date: 2/9/12
 * Time: 14:25
 * To change this template use File | Settings | File Templates.
 */
package au.com.brentoncrowley.utils {

    public class NumberUtil {

        /*
		 * Compares if two Numbers are equal by value
		 *
		 * @param n1:Number
		 * @param n2:Number
		 *
		 * @return Boolean
		 */

		public static function equals(n1:Number = NaN, n2:Number = NaN):Boolean {
			if (n1.toString() == n2.toString()) return true;
			if(n1.valueOf() == n2.valueOf()) return true;
			return false;
		}

    	/*
    	 * Converts a Number to an equivalent Boolean value.
    	 */
    	public static function toBoolean(n:Number = NaN):Boolean
    	{
    		if (isNaN(n) || n.valueOf() == 0) return false ;
    		return true ;
    	}


		/*
		 * Converts a range to a value between 0 and 1.
		 *
		 * @param currentPosition:Number  Current number of target.
		 * @param min:Number  Lowest number possible.
		 * @param max:Number  Highest number possible.
		 *
		 * @return Number
		 *
		 */

		public static function toFraction(currentPosition:Number, minValue:Number, maxValue:Number):Number {
			var f:Number = (currentPosition - minValue) / (maxValue - minValue);
			return f;
		}



		/*
		 * Converts a fraction value to its relative position.
		 *
		 * @param fraction:Number  Fraction value.
		 * @param min:Number  Lowest number possible.
		 * @param max:Number  Highest number possible.
		 *
		 * @return Number
		 *
		 */

		public static function fromFraction(fraction:Number, minValue:Number, maxValue:Number):Number {
			var f:Number = minValue + ((maxValue - minValue) * fraction);
			return f;
		}



		/*
		 * Returns a Random Number in a specified range.
		 *
		 * @param min:Number  Lowest number possible.
		 * @param max:Number  Highest number possible.
		 *
		 * @return Number
		 *
		 */

		public static function ranNumRange(min:Number, max:Number):Number {
			var ranNum:Number = Math.ceil(Math.random() * (max - min +1)) + min -1;
			return ranNum;
		}




		/*
		 * Returns a Random Number from 0 to the amount passed in.
		 *
		 * @param num:Number  The maximum number allowed.
		 *
		 * @return Number
		 *
		 */

		public static function ranNum(num:Number):Number {
			var ranNum:Number = Math.floor(Math.random() * (num +1));
			return ranNum;
		}



		/**
		 * Rounds a target number to the nearest multiple of another number.
		 *
		 * @param num The number to be rounded
		 * @param nearest
		 *
		 * @return Number
		 *
		 */

		public static function roundToNearest(num:Number, nearest:Number):Number {
			return Math.round(num / nearest) * nearest;
		}


		/**
		 * Rounds a target number up to the nearest multiple of another number.
		 *
		 * @param num  The number to be rounded
		 * @param nearest
		 *
		 * @return Number
		 *
		 */

		public static function roundUpToNearest(num:Number, nearest:Number):Number {
			return Math.ceil(num / nearest) * nearest;
		}


		/**
		 * Rounds a target number down to the nearest multiple of another number.
		 *
		 * @param num  The number to be rounded
		 * @param nearest
		 *
		 * @return Number
		 *
		 */

		public static function roundDownToNearest(num:Number, nearest:Number):Number {
			return Math.floor(num / nearest) * nearest;
		}


		/**
		 * Rounds a target number to a specific number of decimal places.
		 *
		 * @param number  The number to be rounded
		 * @param places The number of decimal places to round to (optional)
		 *
		 * @return Number
		 *
		 */

		public static function roundToPlaces(number:Number, places:int = 0):Number {
			var decimalPlaces:Number = Math.pow(10, places);
			return Math.round(decimalPlaces * number) / decimalPlaces;
		}




		/**
		 * Converts true longitude degrees to an x position based on your map width.
		 *
		 * @param longitudeDegrees  The true longitude to be converted
		 * @param mapWidth  The width of your map
		 *
		 * @return Number
		 *
		 */

		public static function convertLongitudeToX(longitudeDegrees:Number, mapWidth:Number):Number {
		    var radius:Number = mapWidth / 2 / 180;
		    var fullX:Number = longitudeDegrees * radius;
		    var x:Number = roundToPlaces(fullX, 1);
		    return x;
		}



		/*
		 * Converts the specified number to a hexadecimal string
		 * @example
		 * for (var i:uint = 0; i < 256; i++) {
		 *     trace(NumberUtil.toHex( i )) ; // without optional prefix
		 * }
		 * trace("-------------------------") ;
		 * for (var i:uint = 0; i < 256; i++) {
		 *     trace(NumberUtil.toHex( i , "#" )) ; // with optional prefix
		 * }
		 *
		 * @param n:Number
		 * @param prefix:String (optional, default "0x")
		 *
		 * @return String
		 *
		 */
		public static function toHex(n:Number, prefix:String = "0x"):String {
			var temp:String = n.toString(16) ;
			if(n < 16) temp = "0" + temp ;
			return (prefix || "") + temp ;
		}
    }
}
