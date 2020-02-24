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
	public class PartGap1245 extends PartObstacle {
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		public function PartGap1245() {
			super(Gap, 4);
		}

		//----------------------------------------------------------------------
		// Protected methods
		//----------------------------------------------------------------------
		/**
		 * Places the obstacles on the part's grid.
		 */
		override protected function plotObstacle():void {
			plotCell(obstacles[0], 0, 1);
			plotCell(obstacles[1], 0, 2);
			plotCell(obstacles[2], 1, 1);
			plotCell(obstacles[3], 1, 2);
		}
	}
}