package state {	
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import asset.CreditsGFX;
	import asset.SingleplayerGFX;
	import asset.TokenGFX;
	import asset.VersusGFX;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	import ui.button.Buttons;
	import ui.highscore.Highscore;

	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Creates menu state.
	 */
	public class MenuState extends DisplayState {
		
		//-------------------------------------------------------
		// Private static embedded constants
		//-------------------------------------------------------
		/**
		 * Background music for entire game.
		 * 
		 * @default	Class
		 */
		[Embed(source="../../asset/sound/Declan_DP_KODOMOi_Jellyfish.mp3")]
		private static const BACKGROUND_MUSIC:Class;
		
		/**
		 * Header logo for the game
		 * 
		 * @default	Class
		 */
		[Embed(source="../../asset/img/logo.png")]
		private static const LOGO:Class;
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		private var _playerOneControls:EvertronControls = new EvertronControls(0);
		private var _playerTwoControls:EvertronControls = new EvertronControls(1);
		private var _layer:DisplayStateLayer;
		private var _buttonsGFXs:Vector.<Class> = new <Class>[SingleplayerGFX, VersusGFX, CreditsGFX];
		private var _buttons:Buttons;
		private var _highscore:Highscore;
		private var _token:TokenGFX;
		
		//----------------------------------------------------------------------
		// Constructor method
		//----------------------------------------------------------------------
		public function MenuState() {
			super();
		}
		
		//----------------------------------------------------------------------
		// Override public methods
		//----------------------------------------------------------------------
		override public function init():void {
			this.initSound();
			this.initLayer();
			this.initHeader();
			this.initButtons();
			this.initToken();
			this.initHighscore();
		}
		
		override public function update():void {
			this.updateControls(_playerOneControls);
			this.updateControls(_playerTwoControls);
			
		}
		
		override public function dispose():void {
			_playerOneControls = null;
			_playerTwoControls = null;
			_buttons = null;
			_highscore = null;
			_token = null;
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 * Initializes background music if music is 
		 * not already playing. Infinite repeat.
		 * 
		 * @return	void
		 */
		private function initSound():void {
			Session.sound.masterChannel.sources.add("music", BACKGROUND_MUSIC);
			var music:SoundObject = Session.sound.masterChannel.get("music", true, true);
			if(music.isPlaying != true) {
				music.play(int.MAX_VALUE);
				music.volume = 0.5;
			}
		}
		
		/**
		 * Creates DisplayStateLayer
		 * 
		 * @return	void
		 */
		private function initLayer():void {
			_layer = this.layers.add("menu");
		}
		
		/**
		 * Adds the game logo as header.
		 * 
		 * @return	void
		 */
		private function initHeader():void {
			var logo:Bitmap = new LOGO() as Bitmap;
			logo.x = 400 - logo.width/2;
			logo.y = 20;
			_layer.addChild(logo);
		}
		
		/**
		 * Creates buttons for options
		 * 
		 * @return	void
		 */
		private function initButtons():void {
			_buttons = new Buttons(_buttonsGFXs);
			var btnCont:Sprite = _buttons.getContainer();
			btnCont.x = 50;
			btnCont.y = 350;
			_layer.addChild(btnCont);
		}
		/**
		 * Adds token for graphic effect 
		 * 
		 * @return	void
		 */
		private function initToken():void {
			_token = new TokenGFX();
			_token.width = 120;
			_token.height = 120;
			_token.x = 540;
			_token.y = 360;
			_layer.addChild(_token);
		}
		
		/**
		 * Creates list with highscores
		 * 
		 * @return	void
		 */
		private function initHighscore():void {
			_highscore = new Highscore();
			_highscore.x = 440;
			_highscore.y = 220;
			_highscore.visible = true;
			_layer.addChild(_highscore);
		}
		
		/**
		 * Checks for input from controls.
		 * 
		 * @param	controls	player one or two controls
		 */
		private function updateControls(controls:EvertronControls):void {
			
			if (Input.keyboard.justPressed(controls.PLAYER_UP)) {
				_buttons.selectPrevious();
				if (_buttons.activeIndex == 0) {
					_highscore.visible = true;
				} else {
					_highscore.visible = false;
				}
			}
			if (Input.keyboard.justPressed(controls.PLAYER_DOWN)) {
				_buttons.selectNext();
				if (_buttons.activeIndex == 0) {
					_highscore.visible = true;
				} else {
					_highscore.visible = false;
				}
			}
			if(Input.keyboard.justPressed(controls.PLAYER_BUTTON_1)) {
				if (_buttons.activeIndex == 0) {
					Session.application.displayState = new HowToSingleplayerState();
				} else if (_buttons.activeIndex == 1) {
					Session.application.displayState = new HowToVersusState();
				} else if (_buttons.activeIndex == 2) {
					Session.application.displayState = new CreditsState();
				}
			}
			
		}
		
	}
}