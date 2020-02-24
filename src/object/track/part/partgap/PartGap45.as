package object.track.part.partgap {	
	//-------------------------------------------------------------------------
	// Imports
	//-------------------------------------------------------------------------
	import object.track.part.PartObstacle;
	import object.obstacle.Gap;
	
	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Represents a part with obstacle(s). 
	 */
	public class PartGap45 extends PartObstacle {
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		public function PartGap45() {
			super(Gap, 2);
		}

		//----------------------------------------------------------------------
		// Protected methods
		//----------------------------------------------------------------------
		/**
		 * Places the obstacles on the part's grid.
		 */
		override protected function plotObstacle():void {
			plotCell(obstacles[0], 1, 1);
			plotCell(obstacles[1], 1, 2);
		}
	}
}