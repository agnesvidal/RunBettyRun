package collision {
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	//----------------------------------------------------------------------
	// Public class
	//----------------------------------------------------------------------
	/**
	 * Represents an objects hitbox, used for detecting collisions.
	 */
	public class Hitbox extends Rectangle {
		
		//----------------------------------------------------------------------
		// Public getter and setter methods
		//----------------------------------------------------------------------
		/**
		 * Returns global coordinates for hitbox.
		 * 
		 * @return	Rectangle
		 */
		public function get globalRect():Rectangle {
			_tempPoint.x = this.x;
			_tempPoint.y = this.y;
			var a:Point = this._parent.localToGlobal(_tempPoint);
			var b:Rectangle = new Rectangle(this.x + a.x,this.y + a.y, this.width, this.height);
			
			return b;
		}
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		/**
		 *	The object which the hitbox is applied to.
		 */
		private var _parent:Sprite;
		/**
		 *	Temporary point, used to calculate global coordinates. 
		 */
		private var _tempPoint:Point = new Point();
		
		//----------------------------------------------------------------------
		// Constructor method
		//----------------------------------------------------------------------
		public function Hitbox(parent:Sprite) {
			_parent = parent;
		}
		
		//----------------------------------------------------------------------
		// Public methods
		//----------------------------------------------------------------------
		/**
		 * Check if hitbox collides with another hitbox
		 *
		 * @param	obj:Hitbox - the "other" hitbox 
		 * @return	Boolean
		 */
		public function hitCheck(obj:Hitbox):Boolean {
			if (this.globalRect.intersects(obj.globalRect) == false) {
				return false;
			} else {
				return true;
			}
		}
	}
}