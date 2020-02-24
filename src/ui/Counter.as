package ui {
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	
	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Represents a counter.
	 */
	public class Counter extends DisplayStateLayerSprite{
		//-------------------------------------------------------
		// Private properties
		//-------------------------------------------------------
		/**
		 * List containing all digits. 
		 */
		private var _digits:Array = []; 
		
		/**
		 * Font used in counter.
		 * @default "Roboto"
		 */
		private var _font:String = "Roboto";
		
		/**
		 * Size of the text in the counter
		 * @default 16
		 */
		private var _size:uint = 16;
		
		/**
		 * Space between digits.
		 * @default 10
		 */
		private var _spacer:uint = 10;
		
		/**
		 * Reference to a digit. 
		 */
		private var _digit:CounterDigit;
		
		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		public function Counter(numDigits:uint, font:String, size:uint, spacer:uint, outline:Boolean){
			_font = font;
			_size = size;
			_spacer = spacer;
			initDigits(numDigits, outline);	
		}
		
		//-------------------------------------------------------
		// Public methods
		//-------------------------------------------------------	
		/**
		 * Deallocation code for the object.
		 * 
		 * @return 	void
		 */
		override public function dispose():void {
			//@TODO
		}
		
		/**
		 * Sets new score in the counter.
		 * 
		 * @param 	value	New score (int)
		 * @return 	void	
		 */
		public function setScore(value:int):void {
			var scoreArr:Array = (""+value).split("").map(toInt);			
			for(var i:int = 0; i < _digits.length; i++) {
				_digits[i].value = 0;
			}
			
			for(var j:int = _digits.length - 1, k:int = scoreArr.length - 1; j >= 0, k >= 0; j--, k--) {
				_digits[j].value = scoreArr[k];
			}
			
		}
		
		/**
		 * Converts String to int.
		 * 
		 * @param 	string		String to convert
		 * @param 	index		...
		 * @param 	arr			...
		 * @return 	int		
		 */
		public function toInt(string:String, index:int, arr:Array):int {
			return int(string);
		}
		
		//-------------------------------------------------------
		// Private methods
		//-------------------------------------------------------
		/**
		 * Initiates digits
		 * 
		 * @param 	numDigits		Number of digits (uint)
		 * @param 	outline			Wheter outline should be 
		 * 							applied to text or not.
		 * 
		 */
		private function initDigits(numDigits:uint, outline:Boolean):void {
			var x:int = 0;
			for(var i:uint = 0; i<numDigits; i++) {
				_digit = new CounterDigit(_font, _size);
				_digit.value = 0;
				_digit.x = x;
				_digits.push(_digit);
				addChild(_digit);
				if(outline) {
					var line:GlowFilter = new GlowFilter();
					line.blurX = line.blurY = 3;
					line.color = 0xFF00CC;
					line.quality = BitmapFilterQuality.HIGH;
					line.strength = 100;
					
					var filterArray:Array = new Array();
					filterArray.push(line);
					_digit.filters = filterArray;
				}
				x += _spacer;
			}
		}
	}
}