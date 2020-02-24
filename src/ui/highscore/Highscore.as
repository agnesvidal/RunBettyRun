package ui.highscore {
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------
	import flash.display.Sprite;
	
	import asset.HighscoreGFX;
	
	import se.lnu.stickossdk.system.Session;
	
	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Creates high score list 
	 */
	public class Highscore extends Sprite {
		//-------------------------------------------------------
		// Private static constants
		//-------------------------------------------------------
		/**
		 * Default name on high score list
		 * 
		 * @default	String	Betty Gump
		 */
		private static const DEFAULT_NAME:String = "Betty Gump";
		
		/**
		 * Header height
		 * 
		 * @default		85
		 */
		private static const HEADER_HEIGHT:int = 85;
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		/**
		 * Vector with rows. Each row contains rank, name and score for one high score
		 */
		private var _rows:Vector.<HighscoreRow> = new Vector.<HighscoreRow>();
		
		/**
		 * High score graphics MovieClip
		 */
		private var _graphics:HighscoreGFX;
		
		//----------------------------------------------------------------------
		// Constructor method
		//----------------------------------------------------------------------
		public function Highscore() {
			this.initGraphics();
			this.initRows();
			this.initData();
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		/**
		 * Adds graphic component
		 * 
		 */
		private function initGraphics():void {
			_graphics = new HighscoreGFX();
			this.addChild(_graphics);
		}
		
		/**
		 * Adds 10 rows.
		 * 
		 */
		private function initRows():void {
			for(var i:int = 0; i < 10; i++) {
				var row:HighscoreRow = new HighscoreRow();
				row.x = 17;
				row.y = HEADER_HEIGHT + (row.height + 6) * i;
				row.rank = i+1;
				row.name = DEFAULT_NAME;
				row.score = 0;
				_rows.push(row);
				this.addChild(row);
			}
		}
		
		/**
		 * Get high score data from database.
		 * 
		 */
		private function initData():void {
			Session.highscore.receive(1, 10, function(data:XML):void{populateRows(data)});
		}
		
		/**
		 * Populate rows with data received from database
		 * 
		 * @param	data	XML
		 */
		private function populateRows(data:XML):void {
			for(var i:int = 0; i < data.items.item.length(); i++) {
				_rows[i].name = data.items.item[i].name;
				_rows[i].score = data.items.item[i].score;
			}
		}		
	}
}