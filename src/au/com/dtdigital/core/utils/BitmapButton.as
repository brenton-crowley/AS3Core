// combines a bunch of loaded bitmaps into a button.
package au.com.dtdigital.core.utils {
	import au.com.dtdigital.core.dtdbug.DTDBug;
	import au.com.dtdigital.core.utils.LoadedBitmap;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;	

	/**
	 * @author iwilliams
	 */
	public class BitmapButton extends Sprite {
		
		// VARIBABLES
		private var buttonUp:LoadedBitmap;
		private var buttonOver:LoadedBitmap;
		private var buttonDown:LoadedBitmap;
		
		private var onClickMethod:Function;
		
		// CONSTRUCTOR
		// 		@param				urlUp: location of the image to be displayed when there is no mouse interaction
		//		@param [optional]	urlOver: location of the image to be displayed when the mouse is over the button
		//		@param [optional]	urlDown: location of the image to be displayed when the button is clicked
		//		@param [optional]	clickMethod: method to call when the button is clicked
		public function BitmapButton( urlUp:String, urlOver:String=null, urlDown:String=null, clickMethod:Function=null ) {
			
			this.buttonUp = new LoadedBitmap(urlUp);
			this.addChild( this.buttonUp );
			
			if ( urlDown != null ){
				this.buttonOver = new LoadedBitmap( urlOver );
				this.addChild( this.buttonOver );
				this.buttonOver.visible = false;
			}
			if ( urlDown != null ) {
				this.buttonDown = new LoadedBitmap( urlDown );
				this.addChild( this.buttonDown );
				this.buttonDown.visible = false;				
			}
						
			this.onClickMethod = clickMethod;
						
			this.mouseChildren = false;
			this.buttonMode = true;
						
			this.createListeners();
			
			DTDBug.log( "button created!" );
			
		}
					
		private function createListeners():void{
			if ( this.buttonOver != null ){
				this.addEventListener( MouseEvent.MOUSE_OVER, this.mouseOverListener, false, 0, true );
			}
			if ( this.buttonDown != null ){
				this.addEventListener( MouseEvent.MOUSE_DOWN, this.mouseDownListener, false, 0, true );
			}
			if ( this.onClickMethod != null ){
				this.addEventListener( MouseEvent.CLICK, this.mouseClickListener, false, 0, true );
			}
		}
		
		
		// BUTTON RESPONSE
		private function mouseOverListener( event:MouseEvent ):void{
			this.addEventListener( MouseEvent.MOUSE_OUT, this.mouseOutListener );
			this.buttonOver.visible = true;
			this.buttonUp.visible = false;			
		}
		private function mouseOutListener( event:MouseEvent ):void{
			this.removeEventListener( MouseEvent.MOUSE_OUT, this.mouseOutListener );
			this.buttonOver.visible = false;
			this.buttonUp.visible = true;
		}
		private function mouseDownListener( event:MouseEvent ):void{
			this.buttonDown.visible = true;
			this.stage.addEventListener( MouseEvent.MOUSE_UP, this.mouseUpListener );
		}
		private function mouseUpListener( event:MouseEvent ):void{
			this.stage.removeEventListener( MouseEvent.MOUSE_UP, this.mouseUpListener );
			this.buttonDown.visible = false;
		}

		// CLICK RESPONSE
		private function mouseClickListener( event:MouseEvent ):void{
			if ( this.onClickMethod != null ){
				this.onClickMethod();
			}
			DTDBug.log( "button clicked. Running method." );
		}
		
	}
}
