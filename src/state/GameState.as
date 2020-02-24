package state {
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------
	import object.ScreenManager;
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	
	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Creates new gamestate.
	 */
	public class GameState extends DisplayState {	
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		/**
		 * DisplayStateLayer for GameScreens
		 */
		private var _gameScreenLayer:DisplayStateLayer;
		
		/**
		 * Reference to ScreenManager
		 */
		private var _screenManager:ScreenManager;
		
		/**
		 * Current game mode:
		 * 0 - singleplayer
		 * 1 - versus
		 */
		private var _gameMode:int;
		
		//----------------------------------------------------------------------
		// Constructor method
		//----------------------------------------------------------------------
		public function GameState(mode:uint) {
			_gameMode = mode;
			super();
		}	
		
		//----------------------------------------------------------------------
		// Override public methods
		//----------------------------------------------------------------------
		override public function init():void {
			initLayer();
			initScreenManager();
		}
		
		override public function update():void {
			_screenManager.drawGameMode();
		}
		
		override public function dispose():void {
			_screenManager = null;
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		/**
		 * Initializes gameScreenLayer
		 * 
		 * @return	void
		 */
		private function initLayer():void {
			_gameScreenLayer = this.layers.add("gameScreen");
		}
		
		/**
		 * Initializes a screenManager.
		 * 
		 * @return	void
		 */
		private function initScreenManager():void {
			_screenManager = new ScreenManager(_gameMode);
			_screenManager.initGameMode();
			_gameScreenLayer.addChild(_screenManager);
		}
	}
}