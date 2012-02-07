// CLASS INFO -----------
// This is a class for easily loading in external image files and drawing them to a bitmapData. 
//

package au.com.dtdigital.core.utils {
	import au.com.dtdigital.core.dtdbug.DTDBug;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;	

	/**
	 * @author iwilliams
	 */
	public class LoadedBitmap extends Bitmap {
		// VARIABLES		 
		public var url:String;
		public var loaded:Boolean = false;

		private var bitmapLoader:Loader;
		
		/*
		 * 	CONSTRUCTOR
		 * 	@param bitmapURL: The location of the bitmap that is to be loaded.
		 */		 
		public function LoadedBitmap( bitmapURL:String = null ) {
		 	
			bitmapLoader = new Loader( );			
			if ( bitmapURL != null ) {
				this.load( bitmapURL );
			}
		}

		
		//	BITMAP LOADING

		public function load( loadURL:String ):void {
			url = loadURL;
			DTDBug.log( "Loading bitmap: " + loadURL );
			this.addListeners( );
			this.bitmapLoader.load( new URLRequest( loadURL ) );
		}

		private function onLoadFinish( event:Event ):void {
			DTDBug.log( "Bitmap load success: " + url );		 	
			this.clearListeners( );
			this.drawBitmap( );
			this.bitmapLoader.unload( );
			this.dispatchEvent( new Event( Event.COMPLETE ) );
			this.loaded = true;
		}

		private function loadErrorHandler( event:IOErrorEvent ):void {
			this.clearListeners( );
			this.dispatchEvent( new IOErrorEvent( IOErrorEvent.IO_ERROR ) );
			DTDBug.log( "URL not found: " + url );	
		}

		// OTHER EVENT HANDLING		
		private function handleProgress( event:ProgressEvent ):void {
			this.dispatchEvent( new ProgressEvent( ProgressEvent.PROGRESS ) );
		}

		private function addListeners():void {
			this.bitmapLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, this.onLoadFinish );
			this.bitmapLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, this.loadErrorHandler );
			this.bitmapLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, this.handleProgress );
		}

		private function clearListeners():void {
			this.bitmapLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, this.onLoadFinish );
			this.bitmapLoader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, this.loadErrorHandler );
			this.bitmapLoader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, this.handleProgress );
		}

		/*
		 * 	DRAW BITMAP
		 */
		private function drawBitmap():void {
			this.bitmapData = new BitmapData( this.bitmapLoader.width, this.bitmapLoader.height, true, 0 );
			this.bitmapData.draw( this.bitmapLoader );			 
			this.smoothing = true;		 		 
		}

		//		DESTROY!!!
		public function destroy():void {
			this.bitmapData.dispose();
		}
	}
}
