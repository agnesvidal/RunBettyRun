package ui {
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	import flash.text.TextField;

	//----------------------------------------------------------------------
	// Public class
	//----------------------------------------------------------------------
	/**
	 * Represents a textfield. The class is used to simplify the creation of textfields.
	 */
	public class Text extends TextField {
		//----------------------------------------------------------------------
		// Constructor method
		//----------------------------------------------------------------------
		public function Text(x:Number = 0, y:Number = 0, width:Number = 100, height:Number = 100) {
			this.x 		= x;
			this.y 		= y;
			this.width 	= width;		
			this.height = height;	 	
		}
	}
}