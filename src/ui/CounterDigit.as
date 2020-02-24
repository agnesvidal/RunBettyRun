package ui {
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------
	import flash.text.TextField;
	import flash.text.TextFormat;

	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Represents a digit.
	 */
	public class CounterDigit extends TextField {
		//-------------------------------------------------------
		// Public getter and setter methods
		//-------------------------------------------------------
		/**
		 * @return 	int		Value of digit.
		 */
		public function get value():int {
		 	return _value;
		}
		
		/**
		 * Sets the value of the digit.
		 * 
		 * @param v		Value of digit
		 * 
		 */
		public function set value(v:int):void {
			_value = v;
			this.text = _value.toString();
		}
		
		//-------------------------------------------------------
		// Private properties
		//-------------------------------------------------------
		/**
		 * The value of the digit.
		 */
		private var _value:int = 0;
		
		/**
		 * Text format used for digit.
		 */
		private var _format:TextFormat;
		
		/**
		 * Font used for digit.
		 * @default "Roboto"
		 */
		private var _font:String = "Roboto";
		
		/**
		 * Size of digit.
		 * @default 16
		 */
		private var _size:uint = 16;
		
		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		public function CounterDigit(font:String, size:uint){
			_format = new TextFormat();
			_format.font = font;
			_format.color = 0xFFFFFF;
			_format.size = size;
			
			this.embedFonts = true;
			this.defaultTextFormat = _format;
			this.text = "0";
		}
	}
}