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
	public class PartGap1 extends PartObstacle {
		//----------------------------------------------------------------------
		// Constructor method
		//----------------------------------------------------------------------
		public function PartGap1() {
			super(Gap, 1);
		}

		//----------------------------------------------------------------------
		// Protected methods
		//----------------------------------------------------------------------
		/**
		 * Places the obstacles on the part's grid.
		 */
		override protected function plotObstacle():void {
			plotCell(obstacles[0], 2, 0);
		}
	}
}