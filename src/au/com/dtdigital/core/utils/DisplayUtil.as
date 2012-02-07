package au.com.dtdigital.core.utils {
	import flash.display.Sprite;		

	/**
	 * @author BCrowley
	 */
	public class DisplayUtil {
		
		
		/**
		 * Returns a rectangular sprite.
		 * 
		 * @param width:int  the width of the sprite. 
		 * @param height:int  the height of the sprite. 
		 * @param alpha:Number  OPTIONAL - transparency of sprite. DEFAULT 1
		 * @param colour:Number  OPTIONAL - colour of sprite DEFAULT 0x00FF00
		 * 
		 * @return Sprite
		 * 
		 */
		
		public static function drawRectSprite(width:int, height:int, alpha:Number = 1, colour:Number = 0x00FF00):Sprite {
			var s:Sprite = new Sprite();
			s.graphics.beginFill(colour, alpha);
			s.graphics.drawRect(0, 0, width, height);
			s.graphics.endFill();
			return s;
		}
		
		
		
		/**
		 * Returns a circular sprite.
		 * 
		 * @param radius:int  the radius of the sprite.
		 * @param alpha:Number  OPTIONAL - transparency of sprite. DEFAULT 1
		 * @param colour:Number  OPTIONAL - colour of sprite DEFAULT 0x00FF00
		 * 
		 * @return Sprite
		 * 
		 */
		
		public static function drawCircSprite(radius:int, alpha:Number = 1, colour:Number = 0x00FF00):Sprite {
			var s:Sprite = new Sprite();
			s.graphics.beginFill(colour, alpha);
			s.graphics.drawCircle(0, 0, radius);
			s.graphics.endFill();
			return s;
		}
		
		

		/**
		 * Returns a triangular sprite with equal sides.
		 * 
		 * @param base:int  the length of the triangle base (width)
		 * @param alpha:Number  OPTIONAL - transparency of sprite. DEFAULT 1
		 * @param colour:Number  OPTIONAL - colour of sprite DEFAULT 0x00FF00
		 * 
		 * @return Sprite
		 * 
		 */
		
		public static function drawTriSprite(base:int, alpha:Number = 1, colour:Number = 0x00FF00):Sprite {
			var height:Number = Math.sqrt((base*base)-((base/2)*(base/2)));
			var s:Sprite = new Sprite();
			s.graphics.beginFill(colour, alpha);
			s.graphics.moveTo(0, height);
			s.graphics.lineTo(base/2, 0);
			s.graphics.lineTo(base, height);
			s.graphics.lineTo(0, height);
			s.graphics.endFill();
			return s;
		}
		
		
	}
}
