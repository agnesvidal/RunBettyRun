package object.track.part {
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Represents a grid.
	 */
	public class Grid extends Sprite {
		//-------------------------------------------------------
		// Private properties
		//-------------------------------------------------------
		/**
		 * Number of rows. 
		 */
		private var _rows:uint;
		
		/**
		 * Number of columns. 
		 */
		private var _cols:uint;
		
		/**
		 * List containing all cells. 
		 */
		private var _cells:Array = new Array();
		
		/**
		 * Two dimensional list containing the cells based on row
		 * and column. 
		 */
		private var _plot:Array = new Array();

		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		public function Grid(cell:uint, rows:uint, cols:uint) {
			_rows = rows;
			_cols = cols;
			createCells(cell);
			createGrid(_cells);	
		}
		
		//-------------------------------------------------------
		// Public methods
		//-------------------------------------------------------
		/**
		 * Returns the number of cells.
		 * 
		 * @return 	int
		 */
		public function get numCells():int {
			return _plot.length;
		}
		
		/**
		 * Returns a cell based on row and column.
		 * 
		 * @param 	r			Row
		 * @param 	c			Column
		 * @return  Sprite
		 */
		public function getCellAt(r:int, c:int):Sprite {
			return _plot[r][c];
		}
		
		/**
		 * Sets the graphic representation of a child object into a cell.
		 * 
		 * @param 	ob		DisplayObject
		 * @param 	r		Row
		 * @param 	c		Column
		 */
		public function setCellChild(ob:DisplayObject, r:int, c:int):void {
			_plot[r][c].addChild(ob);
		}
		
		/**
		 * Returns the child object of a cell based on the cell's row and column.
		 * 
		 * @param 	value			
		 * @param 	r		Row
		 * @param 	c		Column
		 * @return 	DisplayObject	
		 */
		public function getCellChildAt(value:uint, r:int, c:int):DisplayObject {
			return _plot[r][c].getChildAt(value);
		}
		
		/**
		 * Returns the number of children in a cell. The number should never be  
		 * allowed to be more then 1.
		 * 
		 * @param 	r
		 * @param 	c
		 * @return 	int
		 */
		public function cellChildren(r:int, c:int):int {
			return _plot[r][c].numChildren;
		}	
		
		/**
		 * Deallocates object
		 * 
		 */
		public function dispose():void {
			this.disposeCellChildren();
			_plot.length = 0;
			_plot = null;
			_cells.length = 0;
			_cells = null;
		}
		
		//-------------------------------------------------------
		// Private methods
		//-------------------------------------------------------
		/**
		 * Creates the cells of the grid.
		 * 
		 * @param 	cell	Width/height of a cell.
		 * @return 	void
		 */		
		private function createCells(cell:uint):void {
			var i:uint = 0;
			for(var r:uint = 0; r<_rows; r++){
				for(var c:uint = 0; c<_cols; c++){
					_cells[i] = new Sprite();
					_cells[i].y = cell * r;
					_cells[i].x = cell * c;
					addChild(_cells[i]);
					i++;
				}
			}			
		}
		
		/**
		 * Creates the grid from the created cells.
		 * 
		 * @param 	cells	...
		 * @return 	void
		 */		
		private function createGrid(cells:Array):void {
			var i:uint = 0;
			for(var r:uint = 0; r<_rows; r++){
				_plot[r] = new Array;
				for(var c:uint = 0; c<_cols; c++){
					_plot[r][c] = cells[i];
					i++
				}
			}
		}
		
		/**
		 * Deallocates all children of cells
		 */
		private function disposeCellChildren():void {
			for each(var cell:Sprite in _cells){
				if(cell.numChildren >= 1) {
					cell.removeChildren(0);
				}
				cell = null;
			}
		}
	}
}