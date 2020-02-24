package object.track.part.partgap {
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	import object.track.part.PartObstacle;
	import object.obstacle.Gap;
	
	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Represents a part with obstacle(s). 
	 */
	public class PartGap02 extends PartObstacle {	
		//----------------------------------------------------------------------
		// Constructor method
		//----------------------------------------------------------------------
		public function PartGap02() {
			super(Gap, 2);
		}
		
		//----------------------------------------------------------------------
		// Protected methods
		//----------------------------------------------------------------------
		/**
		 * Places the obstacles on the part's grid.
		 */
		override protected function plotObstacle():void {
			plotCell(obstacles[0], 0, 0);
			plotCell(obstacles[0], 0, 2);
		}
	}
}