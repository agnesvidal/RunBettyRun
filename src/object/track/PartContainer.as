package object.track {
	//-------------------------------------------------------------------------
	// Imports
	//-------------------------------------------------------------------------
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import collision.Hitbox;	

	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Represents a part's container and contains the part's hitbox.
	 */
	public class PartContainer extends DisplayStateLayerSprite {
		//-------------------------------------------------------
		// Public getter and setter methods
		//-------------------------------------------------------
		/**
		 * Returns the part's hitbox
		 *
		 * @return	Hitbox
		 */
		public function get hitBox():Hitbox {
			return _hitBox;
		}
		
		/**
		 * Returns the part.  
		 * 
		 * @return Part
		 */
		public function get part():Part {
			return this._part;
		}	
		
		//-------------------------------------------------------
		// Private properties
		//-------------------------------------------------------
		/**
		 * Reference to the part's hitbox. The hitbox is used to
		 * check if the player is still on the track.
		 */
		private var _hitBox:Hitbox;
		
		/**
		 * Reference to the to the part.
		 */
		private var _part:Part;
		
		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		public function PartContainer(part:Class) {
			_part = new part();
			addChild(_part);
			this.initHitbox();	
		}
		
		//-------------------------------------------------------
		// Public methods
		//-------------------------------------------------------
		/**
		 * Deallocation code for the object.
		 * 
		 * @return 	void
		 */
		override public function dispose():void {
			_part.dispose();
			_part = null;
			_hitBox = null;
		}
		
		//-------------------------------------------------------
		// Private methods
		//-------------------------------------------------------
		/**
		 * Instantiates the hitbox.
		 *
		 * @return	void
		 */
		private function initHitbox():void {
			_hitBox = new Hitbox(this);
			_hitBox.width = 114;
			_hitBox.height = 114;
			_hitBox.x = 15;
			_hitBox.y = 15;
		}
	}
}