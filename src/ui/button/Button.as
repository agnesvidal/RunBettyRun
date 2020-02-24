package ui.button {
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------
	import flash.display.MovieClip;	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;

	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Creates button
	 */
	public class Button extends DisplayStateLayerSprite {
		
		//-------------------------------------------------------
		// Public getter and setter methods
		//-------------------------------------------------------	
		/**
		 * setter for buttons frame
		 * 
		 * @param value	String	"select" or "deselect"
		 */
		public function set frame(value:String):void {
			_graphics.gotoAndStop(value);
		}
		
		//-------------------------------------------------------
		// Private properties
		//-------------------------------------------------------
		/**
		 * Class for the buttons movieclip/graphics
		 */
		private var _graphicsBuffer:Class;
		
		/**
		 * Buttons graphic
		 */
		private var _graphics:MovieClip;
		
		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		/**
		 * creates new button
		 * 
		 * @param	graphics	Class for buttons movieclip
		 */
		public function Button(graphics:Class) {
			_graphicsBuffer = graphics;
			this.initGraphics();
		}
		
		//-------------------------------------------------------
		// Private methods
		//-------------------------------------------------------
		private function initGraphics():void {
			_graphics = new _graphicsBuffer();
			this.addChild(_graphics);
		}
	}
}