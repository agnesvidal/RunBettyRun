package ui.highscore {
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import se.lnu.stickossdk.util.URLUtils;
	
	import ui.Text;
	
	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Creates a row for the highscore list
	 */
	public class HighscoreRow extends Sprite {
		
		//----------------------------------------------------------------------
		// Override public getter and setter methods
		//----------------------------------------------------------------------
		/**
		 * 
		 * 	@author		Henrik Andersen <henrik.andersen@lnu.se>
		 */
		override public function set name(value:String):void {
			_name.text = URLUtils.decode(value.toLocaleUpperCase());
		}
		
		/**
		 * 
		 * 	@author		Henrik Andersen <henrik.andersen@lnu.se>
		 */
		override public function get name():String {
			return _name.text.toLocaleUpperCase();
		}
		
		//----------------------------------------------------------------------
		// Public getter and setter methods
		//----------------------------------------------------------------------
		/**
		 * Setter for score.
		 * Truns int to string.
		 *
		 * @param	value	int
		 */
		public function set score(value:int):void {
			_score.text = value.toString();
		}
		
		/**
		 * Setter for rank.
		 * Turns in to strin.
		 * 
		 * @param	value 	int
		 */
		public function set rank(value:int):void {
			_rank.text = value.toString();
		}
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		private var _textFormat:TextFormat;
		private var _scoreFormat:TextFormat;
		private var _rank:Text;
		private var _name:Text;
		private var _score:Text;
		
		
		//----------------------------------------------------------------------
		// Constructor method
		//----------------------------------------------------------------------
		public function HighscoreRow() {
			this.initRank();
			this.initName();
			this.initScore();
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 * Initiates textfield for rank.
		 */
		private function initRank():void {
			_rank = new Text(0, 0, 56, 16);
			_rank.defaultTextFormat = getRankFormat();;
			_rank.embedFonts = true;
			this.addChild(_rank);
		}
		
		/**
		 * Initiates textfield for name.
		 */
		private function initName():void {
			_name = new Text(_rank.width+12, 0, 150, 16);
			_name.defaultTextFormat = getTextFormat();
			_name.embedFonts = true;
			this.addChild(_name);
		}
		
		/**
		 * Initiates textfield for score.
		 */
		private function initScore():void {
			_score = new Text(_name.width, 0, 100, 16);
			_score.defaultTextFormat = getScoreFormat();
			_score.embedFonts = true;
			this.addChild(_score);
		}
		
		/**
		 * Returns basic textformat
		 * 
		 * @return	TextFormat
		 */
		private function getTextFormat():TextFormat {
			var format:TextFormat = new TextFormat();
			format.font = "ARCO";
			format.color = 0xFFFFFF;
			format.size = 16;
			
			return format;
		}
		
		/**
		 * Returns textformat for score text
		 * 
		 * @return	TextFormat
		 */
		private function getScoreFormat():TextFormat {
			var format:TextFormat = getTextFormat();
			format.align = TextFormatAlign.RIGHT;
			
			return format;
		}
		
		/**
		 * Returns textformat for rank
		 * 
		 * @return	TextFormat
		 */
		private function getRankFormat():TextFormat {
			var format:TextFormat = getTextFormat();
			format.align = TextFormatAlign.CENTER;
			
			return format;
		}
	}
}