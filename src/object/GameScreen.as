package object {
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.tween.easing.Linear;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import logic.GameLogic;
	
	//-----------------------------------------------------------
	// Public class
	//-----------------------------------------------------------
	/**
	 * Represents and renders a game screen.
	 * 
	 */
	public class GameScreen extends Bitmap {
		//-------------------------------------------------------
		// Public getter and setter methods
		//-------------------------------------------------------
		/**
		 * ... 
		 * @return 	Number
		 * 
		 * @author Henrik Andersen <henrik.andersen@lnu.se>
		 */
		public function get cameraRotation():Number {	
			return _rotation;
		}

		/**
		 * ...
		 * @param 	value
		 * 
		 * @author Henrik Andersen <henrik.andersen@lnu.se>
		 */
		public function set cameraRotation(value:Number):void {
			_rotationDelta = value - _rotation;
			_rotation = (value % 360); // CLAMP TO 360 Degrees (0-360)
			
			var a:Matrix = this.transform.matrix;
			var b:Matrix = new Matrix(1, 0, 0, 1, (-750 + _offset), (-750 + 330));
			a.concat(b);
			
			a.rotate(Math.PI * _rotationDelta / 180);
			
			var c:Matrix = new Matrix(1, 0, 0, 1, (750 - _offset), (750 - 330));
			a.concat(c);
			this.transform.matrix = a;
		}
		
		//-------------------------------------------------------
		// Private properties
		//-------------------------------------------------------
		private var _bit:BitmapData;
		private var _gameContainer:GameContainer;
		private var _player:int;
		private var _offset:int;
		private var _gameLogic:GameLogic;
		private var _rotation:Number = 0.0;
		private var _rotationDelta:Number = 0.0;	
		
		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		public function GameScreen(offset:int, player:int, gameLogic:GameLogic) {
			_bit = new BitmapData(1500, 1500);
			_offset = offset;
			_player = player;
			super(_bit);
			_gameLogic = gameLogic;
			this.initGameContainer();
		}
		
		//-------------------------------------------------------
		// Public methods
		//-------------------------------------------------------	
		/**
		 * Draws the bitmap data. 
		 * 
		 * @return 	void
		 */
		public function draw():void {
			_gameContainer.update();
			_bit.fillRect(_bit.rect, 0x00000);
			_bit.draw(_gameContainer);
		}
		
		//-------------------------------------------------------
		// Private methods
		//-------------------------------------------------------
		/**
		 * Initializes game container.
		 * 
		 * @return 	void
		 */
		private function initGameContainer():void {
			_gameContainer = new GameContainer(rotateWorld, _gameLogic, _player, _bit.width);
			_gameContainer.init();
		}	
		
		/**
		 * Rotates game world.
		 * 
		 * @param 	direction	Direction to turn in; left(1) or right(2).
		 * @return 	void
		 */
		private function rotateWorld(direction:int):void {	
			_gameContainer.allowRotation = false;
			if(direction == 1){
				Session.tweener.add(this, {
				cameraRotation: this.cameraRotation - 90,
				duration: 175,
				transition: Linear.easeOut,
				onComplete: this.setFlag
				});			
			} else if(direction == 2) {
				Session.tweener.add(this, {
				cameraRotation: this.cameraRotation + 90,
				duration: 175,
				transition: Linear.easeOut,
				onComplete: this.setFlag
				});
			} else {
				return;
			}	
		}
		
		/**
		 * Allows rotation. 
		 * 
		 * @return 	void
		 */
		private function setFlag():void {
			_gameContainer.allowRotation = true;
		}
		
		/**
		 * Deallocates object
		 * 
		 */
		public function dispose():void {
			_gameContainer.dispose();
			_gameContainer = null;
			_bit = null;
			
		}
	}
}