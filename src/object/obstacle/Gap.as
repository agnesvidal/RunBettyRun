package object.obstacle {
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import flash.display.MovieClip;
	import asset.Gap1x1GFX;
	import collision.Hitbox;
	
	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Represents a gap obstacle.
	 */
	public class Gap extends DisplayStateLayerSprite {
		//-------------------------------------------------------
		// Public getter and setter methods
		//-------------------------------------------------------
		/**
		 * Returns the gap's hitbox
		 *
		 * @return	Hitbox
		 */
		public function get hitBox():Hitbox {
			return _hitBox;
		}
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		/**
		 * Hitbox for gap. 
		 */
		private var _hitBox:Hitbox;
		
		/**
		 * Graphic representation of gap.
		 */
		private var _graphics:MovieClip;
		
		//----------------------------------------------------------------------
		// Public methods
		//----------------------------------------------------------------------
		/**
		 * Runs initalization process. 
		 */
		override public function init():void {
			this.initGraphics();
			this.initHitbox();
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		/**
		 * Initializes the graphics. 
		 *
		 * @return	void
		 */
		private function initGraphics():void {
			_graphics = new Gap1x1GFX();
			this.addChild(_graphics);						
		}
		
		/**
		 * Initializes and creates a hitbox. 
		 *
		 * @return	void
		 */
		private function initHitbox():void {
			_hitBox = new Hitbox(this);
			_hitBox.width = 20;
			_hitBox.height = 20;
			_hitBox.x = 14;
			_hitBox.y = 14;
		}
	}
}