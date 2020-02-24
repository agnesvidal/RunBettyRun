package object {
	//-------------------------------------------------------------------------
	// Imports
	//-------------------------------------------------------------------------
	import flash.display.MovieClip;
	import asset.SpeedReduceGFX;
	import collision.Hitbox;
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * SpeedReduce represents a power down.
	 * 
	 */
	public class SpeedReduce extends DisplayStateLayerSprite {
		//-------------------------------------------------------
		// Public getter and setter methods
		//-------------------------------------------------------
		/**
		 * Returns the hitbox. 
		 * 
		 * @return 	Hitbox
		 */
		public function get hitBox():Hitbox {
			return _hitBox;
		}
		
		//-------------------------------------------------------
		// Private properties
		//-------------------------------------------------------
		private var _graphics:MovieClip;
		private var _hitBox:Hitbox;
		
		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		public function SpeedReduce() {
			this.init();
		}
		
		//-------------------------------------------------------
		// Override public methods
		//-------------------------------------------------------
		override public function init():void {
			this.initGraphics();
			this.initHitbox();
			this.x = 5;
			this.y = 5;
		}
		
		//-------------------------------------------------------
		// Private methods
		//-------------------------------------------------------
		/**
		 * Initializes graphical representation of SpeedReduce.
		 *
		 * @return	void
		 */
		private function initGraphics():void {
			_graphics = new SpeedReduceGFX();
			this.addChild(_graphics);						
		}
		
		/**
		 * Initializes SpeedReduces hitbox.
		 *
		 * @return	void
		 */
		private function initHitbox():void {
			_hitBox = new Hitbox(this);
			_hitBox.width = 30;
			_hitBox.height = 30;
			_hitBox.x = 4;
			_hitBox.y = 4;
		}
	}
}