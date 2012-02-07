package au.com.dtdigital.core.utils {

	import flash.display.FrameLabel;	
	import flash.display.MovieClip;		
	
	/**
	 * @author bkanizay
	 */
	 
	public class DTFrameScriptManager {

		private var displayClip:MovieClip;
		private var frameLabels:Object;

		public function DTFrameScriptManager(displayClip:MovieClip) {
			this.displayClip = displayClip;
			this.getAllFrameLabels();
		}

		public function addNewFrameScript(frame:*, handler:Function, ...args):void {
			var frameNumber:uint = this.getFrameNumber(frame);
			if (frameNumber == 0) { 
				return; 
			}
			if (args == null) {
				this.displayClip.addFrameScript(frameNumber-1, handler);
			}
			else {
				this.displayClip.addFrameScript(frameNumber-1, this.createFunctionWithArgs(handler, args));
			}
		}

		private function createFunctionWithArgs(handler:Function, ...args):Function {
		    return function(...innerArgs):void {
		       handler.apply(this, innerArgs.concat(args));
		  	};

		}

		private function getAllFrameLabels():void {
			this.frameLabels = [];
			for each (var j:FrameLabel in this.displayClip.currentLabels) {
				this.frameLabels[j.name] = j.frame;
			}
		}

		private function getFrameNumber(frame:*):uint {
			var frameNumber:uint = uint(frame);
			if (frameNumber) { 
				return frameNumber; 
			}

			var frameLabel:String = String(frame);
			if (frameLabel == null) { 
				return 0; 
			}

			frameNumber = this.frameLabels[frameLabel];
			return frameNumber;
		}


	}

}
