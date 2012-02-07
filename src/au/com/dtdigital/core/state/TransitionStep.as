package au.com.dtdigital.core.state {

	/**
	 * @author OCampbell
	 */
	public class TransitionStep {

		public var id:String; // this id is only used for tracing something human readable
		public var func:Function;
		public var params:*;
		
		public function TransitionStep(func:Function, params:Object = null, id:String = "") {
			this.func = func;
			this.params = params;
			this.id = id;			
		}
		
		public function begin():void {
			if (this.params != null) {
				this.func(this.params);
			}
			else {
				this.func();
			}
		}
	}
}
