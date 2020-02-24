package object {
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import flash.display.Sprite;
	import logic.GameLogic;
	import ui.HUD;
	import ui.HUDSingleplayer;
	import ui.HUDVersus;

	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Manager for game screens. Handles instantiation of single (singleplayer)
	 * or split screen (versus).
	 * 
	 */
	public class ScreenManager extends DisplayStateLayerSprite {
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		private var _gameMode:uint; 		// Singleplayer or Multiplayer
		private var _gs1:GameScreen; 		// First game screen
		private var _gs2:GameScreen;		// Second game screen, only used in multiplayer	
		private var _screen1:Sprite;		// Container for first game screen
		private var _screen2:Sprite;		// Container for second game screen
		private var _gameLogic:GameLogic; 	// Logic used in game modes
		private var _HUD:HUD;				// HUD

		//----------------------------------------------------------------------
		// Constructor method
		//----------------------------------------------------------------------
		public function ScreenManager(gameMode:uint = 0){
			_gameMode = gameMode;
			
		}
		
		/**
		 * Deallocation code for the object.
		 * 
		 * @return 	void
		 */
		override public function dispose():void {
			//@TODO
			_gs1.dispose();
			_gs1 = null;
			if (_gs2) {
				_gs2.dispose();
				_gs2 = null;
			}
		}
		
		//----------------------------------------------------------------------
		// Public methods
		//----------------------------------------------------------------------
		/**
		 * Instantiates thee game mode: Singleplayer or Versus.
		 * 
		 * @return void
		 */		
		public function initGameMode():void {
			if(_gameMode == 0) {
				_HUD = new HUDSingleplayer();
				_HUD.initHUD();
				_gameLogic = new GameLogic(_gameMode, _HUD);
				this.initSingleplayer();
				this.addChild(_HUD);				
			} else {
				_HUD = new HUDVersus();
				_HUD.initHUD();
				_gameLogic = new GameLogic(_gameMode, _HUD);
				this.initMultiplayer();	
				this.addChild(_HUD);
			}
		}
		
		/**
		 * Draws the bitmap for the screen(s).
		 * 
		 * @return void
		 */		
		public function drawGameMode():void {
			if(_gameMode == 0) {
				_gs1.draw();
			} else {
				_gs1.draw();
				_gs2.draw();
			}
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		/**
		 * Instantiates the screen for Singleplayer.
		 * 
		 * @return void
		 */		
		private function initSingleplayer():void{
			_gs1 = new GameScreen(350, 0, _gameLogic);
			_gs1.x = -350;
			_gs1.y = -330;
			this.addChild(_gs1);
		}
		
		/**
		 * Instantiates screens for Versus.
		 * 
		 * @return void
		 */
		private function initMultiplayer():void{
			_gs1 = new GameScreen(550, 0, _gameLogic);
			_gs1.x = -550;
			_gs1.y = -330;
				
			_gs2 = new GameScreen(150, 1, _gameLogic);
			_gs2.x = -150;
			_gs2.y = -330;
			this.initMasks();
		}
		
		/**
		 * Instantiates split screen.
		 * 
		 * @return void
		 */
		private function initMasks():void{
			_screen1 = new Sprite();
			this.createMask(0, _screen1);
			_screen1.addChild(_gs1);	
			this.addChild(_screen1);
			
			_screen2 = new Sprite();
			this.createMask(400, _screen2);
			_screen2.addChild(_gs2);
			this.addChild(_screen2);
		}
		
		/**
		 * Creates mask for a screen.
		 * 
		 * @param 	offset 		x-axis offset
		 * @param 	screen		screen to apply the mask to
		 * @return 	void		...
		 */
		private function createMask(offset:int, screen:Sprite):void {
			var mask:Sprite = new Sprite;
			mask.graphics.beginFill(0x000000);
			mask.graphics.drawRect(offset,0,400,600);
			mask.graphics.endFill();
			screen.mask = mask;
		}
	}
}