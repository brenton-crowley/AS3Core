package au.com.dtdigital.core.utils {
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.text.StyleSheet;
	import flash.text.TextField;	

	/**
	 * @author BCrowley
	 */
	public class ColorUtil {
		
		private static const DEGREES:int = 90;
		private static const GRADIENT_DIRECTION:Number = DEGREES * Math.PI / 180;
		private static const ALPHAS:int = 1;
		
		public static function createGradientSprite(x:Number, y:Number, width:Number, height:Number, topGradientColor:String, bottomGradientColor:String, gradientType:String = GradientType.LINEAR, direction:Number = GRADIENT_DIRECTION, topGradientAlpha:Number = ALPHAS, bottomGradientAlpha:Number = ALPHAS):Sprite {
			var s:Sprite = new Sprite();;
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(width, height, direction, 0, 0);
			var colors:Array = [topGradientColor, bottomGradientColor];
			var alphas:Array = [topGradientAlpha, bottomGradientAlpha];
			var ratios:Array = [0, 0xFF];
			s.graphics.beginGradientFill(gradientType, colors, alphas, ratios, matrix);
			s.graphics.drawRect(x, y, width, height);
			return s;
		}
		
		public static function setTextColor(textfield:TextField, color:String):void {
			var originalText:String = textfield.text;
			textfield.textColor = Number(color);
			textfield.text = originalText;
		}
		
		public static function setHTMLTextColor(textfield:TextField, color:String):void {
			var originalText:String = textfield.text;
			var style:StyleSheet = new StyleSheet();
            var textColor:Object = new Object();
            var styleColor:String = "#" + color.substr(2, 6);
            textColor.color = styleColor;
            style.setStyle(".textColor", textColor);
            textfield.styleSheet = style;
            var formattedText:String = "<span class='textColor'>" + originalText + "</span>";
			textfield.htmlText = formattedText;
		}
		
		public static function setSpriteColor(sprite:Sprite, color:String):void {
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = Number(color);
			sprite.transform.colorTransform = colorTransform;
		}
		
	}
}
