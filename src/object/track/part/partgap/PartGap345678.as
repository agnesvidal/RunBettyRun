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
	public class PartGap345678 extends PartObstacle {
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		public function PartGap345678() {
			super(Gap, 6);
		}

		//----------------------------------------------------------------------
		// Protected methods
		//----------------------------------------------------------------------
		/**
		 * Places the obstacles on the part's grid.
		 */
		override protected function plotObstacle():void {
			plotCell(obstacles[0], 1, 0);
			plotCell(obstacles[1], 1, 1);
			plotCell(obstacles[2], 1, 2);
			plotCell(obstacles[3], 2, 0);
			plotCell(obstacles[4], 2, 1);
			plotCell(obstacles[5], 2, 2);
		}
	}
}