package state {
	//-------------------------------------------------------------------------
	// Imports
	//-------------------------------------------------------------------------
	import asset.SplashScreenGFX;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;

	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Creates new splash screen with creators logo
	 */
	public class SplashScreenState extends DisplayState {
		//-------------------------------------------------------
		// Private static embedded constants
		//-------------------------------------------------------
		
		/**
		 * Splash sound.
		 * 
		 * @default	Class
		 */
		[Embed(source="../../asset/sound/splash.mp3")]  
		private const SPLASH_SOUND:Class;
		
		//-------------------------------------------------------
		// Private properties
		//-------------------------------------------------------
		private var _playerOneControls:EvertronControls = new EvertronControls(0);
		private var _playerTwoControls:EvertronControls = new EvertronControls(1);
		private var _layer:DisplayStateLayer;
		private var _graphics:SplashScreenGFX;
		private var _sound:SoundObject;
		
		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		public function SplashScreenState() {
			super();
		}
		
		//-------------------------------------------------------
		// Override public methods
		//-------------------------------------------------------
		override public function init():void {
			this.initLayer();
			this.initGraphics();
			this.initTimer();
			this.initSound();
		}
		
		override public function update():void {
			this.updateControls(_playerOneControls);
			this.updateControls(_playerTwoControls);
		}
		
		override public function dispose():void {
			_sound.stop();
			_playerOneControls = null;
			_playerTwoControls = null;
			_sound = null;
			_graphics = null;
		}
		
		//-------------------------------------------------------
		// Private methods
		//-------------------------------------------------------
		/**
		 * Creates DisplayStateLayer
		 */
		private function initLayer():void {
			_layer = this.layers.add("splashScreen");
		}
		
		/**
		 * Adds MovieClip with logo.
		 */
		private function initGraphics():void {
			_graphics = new SplashScreenGFX();
			_layer.addChild(_graphics);
		}
		
		/**
		 * Initializes timer to switch states
		 */
		private function initTimer():void {
			Session.timer.create(3750, changeStates);
		}
		
		/**
		 * Callback for timer - changes state to
		 * main menu
		 */
		private function changeStates():void {
			Session.application.displayState = new MenuState();
		}
		
		/**
		 * Initializes & play splash sound
		 * 
		 */
		private function initSound():void {
			Session.sound.masterChannel.sources.add("splah", SPLASH_SOUND);
			_sound = Session.sound.masterChannel.get("splah", true, true);
			_sound.play();
		}
		
		/**
		 * Checks for input from controls.
		 * 
		 * @param	controls	player one or two controls
		 */
		private function updateControls(controls:EvertronControls):void {
			if(Input.keyboard.justPressed(controls.PLAYER_BUTTON_1)) {
				Session.application.displayState = new MenuState();
			}
		}
	}
}