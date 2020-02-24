package object.track {
	//-------------------------------------------------------------------------
	// Imports
	//-------------------------------------------------------------------------
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import object.track.part.Grid;
	
	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Represents a part.
	 */
	public class Part extends DisplayStateLayerSprite {		
		//-------------------------------------------------------
		// Public getter and setter methods
		//-------------------------------------------------------
		/**
		 * Returns the possible directions of the track after the 
		 * part has been placed.
		 * 
		 * @return uint
		 */
		public function get direction():Vector.<uint> {
			return _direction;
		}
		
		/**
		 * Returns the part's type; 
		 * Straight = 0, Left = 1, or Right = 2.
		 * 
		 * @return int
		 */
		public function get type():int {
			return _type;
		}
		
		/**
		 * Returns a reference to the grid.
		 * @return 	Grid
		 */
		public function get grid():Grid {
			return _grid;
		}
		
		/**
		 * Returns the direction in which the player will run 
		 * while on the part.
		 * 
		 * @return uint
		 */
		public function get runningDirection():uint {
			return _runningDirection;
		}
		
		/**
		 * Sets the running direction in which the player will run 
		 * while on the part.
		 * 
		 * @param value
		 */
		public function set runningDirection(value:uint):void {
			_runningDirection = value;
		}
		
		//-------------------------------------------------------
		// Private properties
		//-------------------------------------------------------
		/**
		 * Type of part. Straight = 0, Left = 1, or Right = 2. 
		 */
		private var _type:int = 0;
		
		/**
		 * List holding the possible directions of the track after
		 * the part has been placed.
		 */
		private var _direction:Vector.<uint>;
		
		/**
		 * The direction in which the player will run while on 
		 * the part.
		 */
		private var _runningDirection:uint;
		
		/**
		 * Reference to the type of graphic's to instantiate; 
		 * Straight, Left or Right.
		 */
		private var _graphicsBuffer:Class;
		
		/**
		 * Reference to the main graphics (the ground of the part). 
		 */
		private var _graphics:MovieClip;
		
		/**
		 * Reference to the grid.
		 */
		private var _grid:Grid;
		
		/**
		 * Positions for all cells in the grid when rotated 
		 * -90 degrees (left)
		 */
		private var _leftIndex:Array;
		
		/**
		 * Positions for all cells in the grid when rotated 
		 * 90 degrees (right)
		 */
		private var _rightIndex:Array;		
		
		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		public function Part(graphics:Class, partType:int, direction:Vector.<uint>) {
			super();
			_graphicsBuffer = graphics;
			_type = partType;
			_direction = direction;
			this.init();		
		}
		
		//-------------------------------------------------------
		// Public methods
		//-------------------------------------------------------		
		/**
		/**
		 * Instantiates the part. 
		 *
		 * @return	void
		 */
		override public function init():void {
			this.initGraphics();
			this.initGrid();
			this.initIndexes();
		}
		
		/**
		 * Deallocation code for the object.
		 * 
		 * @return 	void
		 */
		override public function dispose():void {
			_grid.dispose();
			_grid = null;
			_graphics = null;
		}
		
		/**
		 * Rotates the grid by removing all children objects, 
		 * changing their index, and placing the children again
		 * in new cells (positions).
		 *  
		 * @param angleDegrees
		 */
		public function rotateGrid(angleDegrees:Number):void {
			rotateGraphics(angleDegrees);
			var children:Array = [];
			var cellChild:DisplayObject = null;
			var newPlot:Object = null;
			for(var r:int = 0; r<3; r++){
				for(var c:int = 0; c<3; c++){
					if(_grid.cellChildren(r,c) > 0) {
						cellChild = _grid.getCellChildAt(0,r,c);
						_grid.getCellAt(r,c).removeChild(cellChild);
						newPlot = getNewIndex(angleDegrees, r, c);	
						children.push({item: cellChild, newPlot: newPlot});	
					}
				}
			}
			replotChildren(children);		
		}
		
		/**
		 * Check if plot has child or not.
		 * 
		 * @param r
		 * @param c
		 * @return
		 */
		public function checkChild(r:uint, c:uint):Boolean {
			var child:Boolean;
			if(_grid.cellChildren(r,c) == 0) {
				child = false;
			} else {
				child = true;
			}
			return child;
		}
		
		/**
		 * Adds new item to the part by placing it in a cell.
		 * 
		 * @param 	itemType		Type of item
		 * @param 	r				Row
		 * @param 	c				Column
		 * 
		 */
		public function addItem(itemType:Class, r:uint, c:uint):void {
			var ob:Object = new itemType();
			plotCell(ob, r, c);
		}
		
		//-------------------------------------------------------
		// Protected properties
		//-------------------------------------------------------
		/** 
		 * Sets (plots) an object into a cell in the grid.
		 *
		 * @param	ob		Object to be plotted
		 * @param 	r		Row
		 * @param	c		Column
		 * @return	void
		 */
		protected function plotCell(ob:*,r:int, c:int):void {
			_grid.setCellChild(ob,r,c);
		}
		
		//-------------------------------------------------------
		// Private methods
		//-------------------------------------------------------
		/**
		 * Initiates the main graphics. 
		 *
		 * @return	void
		 */
		private function initGraphics():void {
			_graphics = new _graphicsBuffer();
			this.addChild(_graphics);	
		}
		
		/**
		 * Initiates the grid.
		 * 
		 * @return void
		 */	
		private function initGrid():void {
			_grid = new Grid(48, 3, 3);
			addChild(_grid);			
		}
		
		/**
		 * Instantiates the indexes used to rotate the grid 90 
		 * degrees (right) and -90 degrees (left).
		 * 
		 */
		private function initIndexes():void {
			_leftIndex = [
				[{r:2, c:0},{r:1, c:0},{r:0, c:0}],
				[{r:2, c:1},{r:1, c:1},{r:0, c:1}],
				[{r:2, c:2},{r:1, c:2},{r:0, c:2}
				]
			];
			_rightIndex = [
				[{r:0, c:2},{r:1, c:2},{r:2, c:2}],
				[{r:0, c:1},{r:1, c:1},{r:2, c:1}],
				[{r:0, c:0},{r:1, c:0},{r:2, c:0}]
			];
		}
		
		/**
		 * Rotates the part's main graphics. 
		 * 
		 * @param 	angleDegrees
		 * @return	void
		 */
		private function rotateGraphics(angleDegrees:Number):void {
			_graphics.rotation = angleDegrees;
			switch (angleDegrees) {
				case 90: 	_graphics.x += _graphics.width; 	break;
				case -90: 	_graphics.y += _graphics.width; 	break;
			}
		}
		
		/**
		 * Changes index based on rotation and previous index. 
		 * 
		 * @param 	angleDegrees		 Rotation in degrees
		 * @param 	r					 Previous row index
		 * @param 	c					 Previous cell index
		 * @return 
		 */		
		private function getNewIndex(angleDegrees:int, r:int, c:int):Object {	
			var newPlot:Object;	
			switch (angleDegrees) {
				case  90: 	newPlot = {r: _rightIndex[r][c].r, c: _rightIndex[r][c].c}; break;
				case -90: 	newPlot = {r: _leftIndex[r][c].r, c: _leftIndex[r][c].c}; 	break;
			}
			return newPlot;
		}
		
		/**
		 * Changes the position of all the children objects by placing 
		 * them in new cells (positions)
		 * 
		 * @param 	children	The children to 
		 * @return	void
		 */
		private function replotChildren(children:Array):void {
			for(var i:int = 0; i < children.length; i++) {
				plotCell(children[i].item, children[i].newPlot.r, children[i].newPlot.c);
			}
		}
	}
}