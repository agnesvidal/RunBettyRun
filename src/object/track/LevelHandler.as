package object.track {
	//-------------------------------------------------------------------------
	// Imports
	//-------------------------------------------------------------------------
	import object.track.part.PartLeft;
	import object.track.part.PartRight;
	import object.track.part.PartStraight;
	import object.track.part.partgap.*;
	
	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Manages the new parts that can be generated based on difficulty level.
	 */
	public class LevelHandler {
		/**
		 * Register with all parts used on easy difficulty.
		 */
		private var _easy:Vector.<Vector.<Class>> = new Vector.<Vector.<Class>>;
		
		/**
		 * Register with all parts used on medium difficulty.
		 */
		private var _hard:Vector.<Vector.<Class>> = new Vector.<Vector.<Class>>;

		/**
		 * Generated part.
		 */
		private var _part:Class = null;
		
		/**
		 * A temporary list of parts to generate from.
		 */
		private var _tempParts:Vector.<Class>
		
		/**
		 * Random number generated.
		 */
		private var _chance:int = 0;
		
		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		public function LevelHandler() {
			initEasy();
			initHard();
		}
		
		//-------------------------------------------------------
		// Public methods
		//-------------------------------------------------------
		/**
		 * Returns a part based on difficulty.
		 * 
		 * @param 	difficulty
		 * @return 	Class
		 */		
		public function getDifficultyParts(difficulty:int):Class {
			switch(difficulty) {
				case 0: getEasyPart(); break;
				case 1: getHardPart(); break;
			}
			return _part;
		} 
		
		/**
		 * Creates a temporary list with parts of easy difficulty. 
		 * 
		 * @return Class
		 */		
		private function getEasyPart():void {
			_tempParts = new Vector.<Class>;
			_chance = Math.random() * 100;
			
			if(_chance < 50){ 		// 50%
				_tempParts = _easy[0].slice(); 
			} else if(_chance < 70){ // 20%
				_tempParts = _easy[2].slice();
			} else { 				// 30%
				_tempParts = _easy[1].slice();
			}		
			this.getRandomPart();
		}
		
		/**
		 * Creates a temporary list with parts of medium difficulty. 
		 * 
		 * @return  void
		 */
		private function getHardPart():void {
			_tempParts = new Vector.<Class>;
			_chance = Math.random() * 100;
			if(_chance < 50){ 		// 50%
				_tempParts = _hard[0].slice(); 
			} else if(_chance < 70){ // 20%
				_tempParts = _hard[1].slice();
			} else { 				// 30%
				_tempParts = _hard[2].slice();
			}		
			this.getRandomPart();
		}
		
		/**
		 * Generates a random part.
		 * 
		 * @return void
		 */
		private function getRandomPart():void {
			_part = _tempParts[Math.floor(Math.random() * _tempParts.length)];
		}
			
		/**
		 * Instantiation of register for the easy difficulty.
		 * 
		 * @return 	void
		 */
		public function initEasy():void {
			_easy = Vector.<Vector.<Class>>([
				Vector.<Class>([
					PartGap3, 
					PartGap4, 
					PartGap5, 
					PartGap34, 
					PartGap45,
				]),
				Vector.<Class>([ 
					PartStraight,				
					PartRight,
					PartLeft
				]),
				Vector.<Class>([ 
					PartGap14,
					PartStraight
				])
			]);
		}
		/**
		 *  Instantiation of register for the medium difficulty.
		 */
		public function initHard():void {
			_hard = Vector.<Vector.<Class>>([
				Vector.<Class>([	
					PartStraight, 
					PartLeft, 
					PartRight, 
					PartGap3, 
					PartGap4, 
					PartGap5, 
					PartGap34, 
					PartGap35, 
					PartGap345,					
					PartGap0,
					PartGap1,
					PartGap2,
					PartGap02,
				]),
				Vector.<Class>([ // All parts.	
					PartGap3, 
					PartGap4, 
					PartGap5, 
					PartGap34, 
					PartGap35, 
					PartGap345,
					PartGap012345,
					PartGap0,
					PartGap1,
					PartGap2,
					PartGap02,
				]),
				Vector.<Class>([ 
					PartStraight,				
					PartRight,
					PartLeft
				])
			]);
		}
	}
}

