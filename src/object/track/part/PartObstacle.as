package object.track.part {
	//-------------------------------------------------------------------------
	// Imports
	//-------------------------------------------------------------------------
	import flash.errors.IllegalOperationError;
	
	//--------------------------------------------------------------------------
	// Abstract class
	//--------------------------------------------------------------------------
	/**
	 * Base class for all parts containing obstacles.
	 */
	public class PartObstacle extends PartStraight {
		//----------------------------------------------------------------------
		// Protected properties
		//----------------------------------------------------------------------
		/**
		 * All obstacles on a part. 
		 */
		protected var obstacles:Array = [];
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		/**
		 * Type of obstacle. 
		 */
		private var _obstacle:Class;
		
		/**
		 * Number of obstacles on the part.
		 */
		private var _numObstacles:int;
		
		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		public function PartObstacle(obstacle:Class, numObstacles:int) {
			_obstacle = obstacle;
			_numObstacles = numObstacles;
			this.addObstacles();
		}
		
		//-------------------------------------------------------
		// Protected (abstract) methods
		//-------------------------------------------------------
		/**
		 * Abstract method. Note: this method must be overriden 
		 * in subclass. Places the obstacles on the part's grid.
		 * 
		 * @return void
		 */
		protected function plotObstacle():void {	
			throw new IllegalOperationError("Call to abstract method (must be overridden in a subclass)");
		}
		
		//-------------------------------------------------------
		// Private methods
		//-------------------------------------------------------
		/**
		 * Adds new obstacles to the part.
		 * 
		 * @return 	void
		 */
		private function addObstacles():void {
			for (var i:uint = 0; i<_numObstacles; i++) {
				obstacles.push(new _obstacle);
				this.obstacles[i].init();
				this.addChild(obstacles[i]);
			}
			this.plotObstacle();
		}
	}
}