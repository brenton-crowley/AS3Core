package au.com.dtdigital.core.utils {

	/**
	 * @author bkanizay
	 */
	public class BooleanUtil {


		/*
		 * Compares if two Booleans are equal by value.
		 * 
		 * @param bool1:Boolean
		 * @param bool2:Boolean
		 * 
		 * @return Boolean
		 * 
		 */

		public static function equals(bool1:Boolean, bool2:Boolean):Boolean {
			return bool1.valueOf() == bool2.valueOf();
		}


	    /*
 	     * Converts the boolean to an equivalent Number value.
 	     * 
 	     * @param bool:Boolean the boolean to convert
 	     * 
 	     * @return Number
 	     * 
 	     */
		public static function toNumber(bool:Boolean):Number {
			return  bool.valueOf() == true ? 1 : 0 ;
		}


		/*
		 * Converts to an equivalent Object value.
 	     * 
 	     * @param bool:Boolean the boolean to convert
 	     * 
 	     * @return Object
 	     * 
		 */
		public static function toObject(bool:Boolean):Object {
			return new Boolean(bool.valueOf()) ;
		}
		

		/*
		 * Returns a string representation of the boolean.
		 * 
 	     * @param bool:Boolean the boolean to convert
 	     * 
		 * @return String
		 */
		public static function toSource(bool:Boolean):String {
			return equals(bool, true) ? "true" : "false";
		}
		
		
	}
}
