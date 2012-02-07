package au.com.dtdigital.core.dtdbug {

	import au.com.dtdigital.core.utils.KeyTracker;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;

	/**
	 * @author JCope
	 */
	public class DTDBug extends Sprite {
		
		/*
		 * DTDBug simple usage
		 * -------------------
		 *  
		 * Here's the simplest example of using DTDBug:
		 * 
		 * 1. Import the class:
		 *    import au.com.dtdigital.core.dtdbug.DTDBug;
		 *    
		 * 2. Add it to the stage:
		 *    this.addChild(DTDBug.getInstance());
		 *    
		 * 3. Set a URL as allowed:
		 *    DTDBug.addAllowedURL("dtdigital.com.au");
		 *    
		 * 4. Log some text:
		 *    DTDBug.log("Hello world!");
		 *    
		 * 5. Hit the shortcut to view the output (SPACE + CONTROL + SHIFT).
		 * 
		 * Other options
		 * -------------
		 * 
		 * -  Enable DTDBug regardless of which URL the flash is running on:
		 *    DTDBug.addAllowedURL("*");
		 * 
		 * -  Log a message in red:
		 *    DTDBug.log("Hello world!", DTDBugColour.RED);
		 *    
		 * -  Log a value with a label:
		 *    DTDBug.log("Label string", "Value string");
		 * 
		 */
		
		public static var instance:DTDBug;

		public var traceField:TextField;
		public var fpsDisplay:FPSDisplay;
		public var allowedURLs:Array;

		private static const VERSION:String = "1.0";

		private static const FILE_SUBSTRING:String = "file:";
		private static const WILDCARD:String = "*";
		private static const FILL_ALPHA:Number = 0.7;
		private static const TEXTFIELD_PADDING:int = 4;
		private static const TEXTFIELD_HEIGHT:int = 34;

		private var keyTracker:KeyTracker;
		private var titleField:TextField;
		private var background:Sprite;

		public static function getInstance():DTDBug {
			if (instance == null) {
				instance = new DTDBug();	
			}
			return instance;
		}

		public static function addAllowedURL(allowedURL:String):void {
			getInstance().getAllowedURLs().push(allowedURL);
		}
		
		/*
		 * @param traceString:* - value to trace
		 * @param colour:uint (optional) - trace colour use DTDBugColour constants
		 */
		public static function log(traceString:*, colour:uint = DTDBugColour.BLACK):void {
			trace(traceString);
			getInstance().update(removeUnsafeCharacters(traceString), colour);
		}

		/*
		 * @param label:* - label string, will trace as bold
		 * @param value:* - value to trace
		 * @param colour:uint (optional) - trace colour use DTDBugColour constants
		 */
		public static function logWithLabel(label:*, value:*, colour:uint = DTDBugColour.BLACK):void {
			trace(removeUnsafeCharacters(label) + ": " + removeUnsafeCharacters(value));
			getInstance().update("<b>" + removeUnsafeCharacters(label.toString()) + ": </b>" + removeUnsafeCharacters(value.toString()), colour);
		}

		public function DTDBug() {
			this.visible = false;
			this.fpsDisplay = new FPSDisplay();
			this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
		}

		public function getAllowedURLs():Array {
			if (getInstance().allowedURLs == null) {
				getInstance().allowedURLs = [FILE_SUBSTRING];
			}
			return getInstance().allowedURLs;
		}

		private function onAddedToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			this.initialize();				
		}

		private function checkIsLive():Boolean {
			var url:String = this.stage.loaderInfo.url;
			var allowedURLs:Array = getInstance().getAllowedURLs();
			var isLive:Boolean = false;
			for (var i:int = 0; i < allowedURLs.length; i++) {
				if ((url.indexOf(allowedURLs[i]) > -1) || (allowedURLs[i] == WILDCARD)) {
					isLive = true;
					break;
				}
			}
			return isLive;
		}

		private function initialize():void {
			
			trace("DTDBug enabled");
			trace("Hold SPACE + CONTROL + SHIFT to toggle");
			this.stage.addEventListener(Event.RESIZE, this.onStageResize);
			if(this.keyTracker == null) {
				//initialise key tracker
				this.keyTracker = new KeyTracker(this.stage, [Keyboard.SPACE, Keyboard.CONTROL, Keyboard.SHIFT]);
				this.keyTracker.addEventListener(Event.SELECT, this.onTriggered);
			}				
			
			this.background = new Sprite();
			this.background.graphics.beginFill(0xFFFFFF, FILL_ALPHA);
			this.background.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			this.background.graphics.endFill();
			this.addChild(this.background);
//			this.graphics.beginFill(0xFFFFFF, FILL_ALPHA);
//			this.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			
			var textFormat:TextFormat = new TextFormat("_sans");			
			
			this.titleField = new TextField();
			this.titleField.autoSize = TextFieldAutoSize.LEFT;
			this.titleField.x = TEXTFIELD_PADDING;
			this.titleField.y = TEXTFIELD_PADDING;
			this.titleField.height = TEXTFIELD_HEIGHT;
			this.titleField.multiline = true;
			this.titleField.selectable = false;
			this.titleField.defaultTextFormat = textFormat;
			this.titleField.htmlText = "<font face='Courier'><b>DTDBug v" + VERSION + "<br/>-----------</b></font>";
			this.addChild(this.titleField);
			
			this.traceField = new TextField();
			this.traceField.x = TEXTFIELD_PADDING;
			this.traceField.y = TEXTFIELD_PADDING + this.titleField.height;
			this.traceField.width = this.stage.stageWidth - (TEXTFIELD_PADDING * 2);
			this.traceField.height = this.stage.stageHeight - (TEXTFIELD_PADDING * 2) - this.titleField.height;
			this.traceField.multiline = true;
			this.traceField.selectable = true;			
			this.traceField.defaultTextFormat = textFormat;

			this.addChild(this.traceField);
			
			//trace player version
			DTDBug.logWithLabel("Flash player version", Capabilities.version, DTDBugColour.RED);
			DTDBug.logWithLabel("Debug player installed?", Capabilities.isDebugger, DTDBugColour.BLUE);
			DTDBug.log("");
			
			this.positionFPSDisplay();
		}
		
		private function positionFPSDisplay():void {
			this.fpsDisplay.x = this.stage.stageWidth - TEXTFIELD_PADDING - this.fpsDisplay.width;			this.fpsDisplay.y = TEXTFIELD_PADDING;		}

		private function onStageResize(event:Event):void {
			this.background.width = this.stage.stageWidth;			this.background.height = this.stage.stageHeight;
			this.traceField.width = this.stage.stageWidth - (TEXTFIELD_PADDING * 2);
			this.positionFPSDisplay();
		}

		private function onTriggered(event:Event):void {
			if (this.checkIsLive()) {
				this.toggleVisible();
			}	
		}
		
		private function toggleVisible():void {
			if (this.visible) {
				this.hide();
			}
			else {
				this.show();
			}
		}

		private function show():void {
			this.visible = true;	
			this.addChild(this.fpsDisplay);
			this.stage.addChild(DTDBug.getInstance());
		}

		private function hide():void {
			this.visible = false;	
			this.removeChild(this.fpsDisplay);
		}

		private function update(traceString:*, colour:uint = DTDBugColour.BLACK):void { 
			if (this.traceField != null) {
				this.traceField.htmlText += ("<font face='Courier' color='#" + colour.toString(16) + "'>" + traceString.toString() + "</font><br/>");
				this.traceField.scrollV = this.traceField.maxScrollV;
			}
		}

		private static function removeUnsafeCharacters(string:String):String {
			return replaceString(replaceString(string.toString(), ">", "&gt;"), "<", "&lt;");			
		}
		
		private static function replaceString(string:String, find:String, replace:String, ignoreCase:Boolean = false):String {
			var flags:String = (ignoreCase) ? "gi" : "g";
			var regExp:RegExp = new RegExp(find, flags);
			return string.replace(regExp, replace);
		}
	}
}
