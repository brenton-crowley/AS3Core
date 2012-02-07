package au.com.dtdigital.core.utils {

	/**
	 * @author BCrowley
	 */
	public class ArrayUtil {
		
		
		/*
		 * Selects a random position in an array.
		 * 
		 * @param array:Array  Pass in the array for random item selection
		 * 
		 * @return Array
		 * 
		 */
		
		public static function selectRanItem(array:Array):* {
			var range:uint = array.length - 1;
			return array[NumberUtil.ranNum(range)];
		}
		

		/*
		 * Checks whether a value is present in an array
		 * 
		 * @param array:Array  Pass in the array to search
		 * @param value:*  The value to search for
		 * 
		 * @return Boolean
		 * 
		 */
		
		public static function inArray(array:Array, value:*):Boolean {
			for (var i:uint = 0; i < array.length; i++) {
				if (array[i] == value) return true;
			}
			return false;
		}


		/*
		 * Returns the index of the value in an array
		 * 
		 * @param array:Array  Pass in the array to search
		 * @param value:*  The value to search for
		 * 
		 * @return Boolean
		 * 
		 */
		
		public static function getIndex(array:Array, value:*):int {
			for (var i:int = 0; i < array.length; i++) {
				if (array[i] == value) return i;
			}
			return -1;
		}



		
		/*
		 * Randomises the elements of an array by returning a copy.
		 * 
		 * @param array:Array  The array you want to randomise 
		 * 
		 * @return Array
		 * 
		 */
		
		public static function randomize(array:Array):Array {
		    var arrayCopy:Array = array.concat();
		    var randomisedArray:Array = [];
		    var ranNum:Number;
		    for(var i:Number = 0; i < arrayCopy.length; i++) {
			    ranNum = NumberUtil.ranNum(arrayCopy.length - 1);
			    randomisedArray.push(arrayCopy[ranNum]);
			    arrayCopy.splice(ranNum, 1);
			    i--;
		    }
		    return randomisedArray;
	    }
		
	}
}
