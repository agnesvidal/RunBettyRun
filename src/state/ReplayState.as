package state {
	//-------------------------------------------------------------------------
	// Imports
	//-------------------------------------------------------------------------
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import asset.GameOverGFX;
	import asset.MenuGFX;
	import asset.ReplayGFX;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	import ui.Text;
	import ui.button.Buttons;
	
	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Creates new state displaying score/winner 
	 * with option to replay the game or go back
	 * to main menu.
	 */
	public class ReplayState extends DisplayState {
		
		//-------------------------------------------------------
		// Private static embedded constants
		//-------------------------------------------------------
		
		/**
		 * Game Over sound.
		 * 
		 * @default	Class
		 */
		[Embed(source="../../asset/sound/gameover.mp3")]  
		private const GAME_OVER_SOUND:Class;
		
		/**
		 * Winner sound.
		 * 
		 * @default	Class
		 */
		[Embed(source="../../asset/sound/win.mp3")]  
		private const WINNER_SOUND:Class;
		
		//-------------------------------------------------------
		// Private properties
		//-------------------------------------------------------
		/**
		 * Player 1 controls
		 */
		private var _playerOneControls:EvertronControls = new EvertronControls(0);
		
		/**
		 * Player 2 controls
		 */
		private var _playerTwoControls:EvertronControls = new EvertronControls(1);
		
		/**
		 * Reference to last played game mode.
		 * 0 - Singleplayer
		 * 1 - Versus
		 */
		private var _gameMode:int;
		
		/**
		 * DisplayStateLayer
		 */
		private var _layer:DisplayStateLayer;
		
		/**
		 * Vector with references to classes of buttons to initiate.
		 */
		private var _buttonsGFXs:Vector.<Class> = new <Class>[ReplayGFX, MenuGFX];
		
		/**
		 * Reference to buttons object
		 */
		private var _buttons:Buttons;
		
		/**
		 * Players score
		 * 
		 * @default	0
		 */
		private var _score:int = 0;
		
		/**
		 * Boolean if player achived new highscore or not
		 * 
		 * @default	false
		 */
		private var _highscore:Boolean = false;
		
		/**
		 * Winner of versus.
		 * 0 - player 1
		 * 1 - player 2
		 * 3 - draw
		 * 
		 * @default	0
		 */
		private var _winner:uint;
		
		/**
		 * Game Over graphics
		 */
		private var _graphics:GameOverGFX;
		
		/**
		 * Sprite container for texts
		 */
		private var _textContainer:Sprite;
		
		/**
		 * String for header in _textContainer
		 * 
		 * @default	"Your score:"
		 */
		private var _headerString:String = "Your score:";
		
		/**
		 * String for score in _textContainer
		 * 
		 * @default	"0"
		 */
		private var _scoreString:String = "0";
		
		/**
		 * String for message in _textContainer
		 * 
		 * @default	"no score?"
		 */
		private var _messageString:String = "no score?";
		
		/**
		 * Reference to game over soundFX
		 * 
		 */
		private var _gameOverSound:SoundObject;
		
		/**
		 * Reference to winner soundFX
		 * 
		 */
		private var _winnerSound:SoundObject;
		
		/**
		 * Reference to background music
		 * 
		 */
		private var _backgroundMusic:SoundObject;
		
		
		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		/**
		 * Creates new replay state
		 * 
		 * @param	gameMode	Type of game last played (singleplayer/versus)
		 * @param	highscore	If player achived new highscore (singpleplayer)
		 * @param	score		Players score (singpleplayer)	
		 * @param	winner		winning player or draw (versus)
		 */
		public function ReplayState(gameMode:int, highscore:Boolean = false, score:int = 0, winner:uint = 0) {
			_gameMode = gameMode;
			_highscore = highscore;
			_score = score;
			_winner = winner;
			super();
		}
		
		//----------------------------------------------------------------------
		// Override public methods
		//----------------------------------------------------------------------
		override public function init():void {
			this.initLayer();
			this.initGraphics();
			this.initTextContainer();
			this.initButtons();
			this.initSound();
			
			if(_gameMode == 0) {
				initSingleplayer();
			} else {
				initVersus();
			}
		}
		
		override public function update():void {
			this.updateControls(_playerOneControls);
			this.updateControls(_playerTwoControls);
			
		}
		
		override public function dispose():void {
			_backgroundMusic.volume = 0.5;
			_playerOneControls = null;
			_playerTwoControls = null;
			_textContainer = null;
			_graphics = null;
			_buttons = null;
			
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		/**
		 * Creates DisplayStateLayer
		 * 
		 * @return	void
		 */
		private function initLayer():void {
			_layer = this.layers.add("replay");
		}
		
		/**
		 * Adds game over graphics 
		 * 
		 * @return	void
		 */
		private function initGraphics():void {
			_graphics = new GameOverGFX();
			_graphics.x = 100;
			_graphics.y = 80;
			_layer.addChild(_graphics);
			
		}
		
		/**
		 * Adds container for text 
		 * 
		 * @return	void
		 */
		private function initTextContainer():void {
			_textContainer = new Sprite();
			_textContainer.graphics.beginFill(0xFFFFFF, 1);
			_textContainer.graphics.drawRect(5, 80, 590, 220);
			_textContainer.graphics.endFill();
			_graphics.addChild(_textContainer);
		}
		
		/**
		 * Adds menu buttons.
		 * 
		 * @return	void
		 */
		private function initButtons():void {
			_buttons = new Buttons(_buttonsGFXs);
			var btnCont:Sprite = _buttons.getContainer();
			btnCont.x = 80;
			btnCont.y = 450;
			_layer.addChild(btnCont);
		}
		
		/**
		 * Initializes sounds 
		 * 
		 * @return	void
		 */
		private function initSound():void {
			Session.sound.soundChannel.sources.add("gameover", GAME_OVER_SOUND);
			_gameOverSound = Session.sound.soundChannel.get("gameover", true, true);
			
			Session.sound.soundChannel.sources.add("winner", WINNER_SOUND);
			_winnerSound = Session.sound.soundChannel.get("winner", true, true);
			
			_backgroundMusic = Session.sound.masterChannel.get("music", true, true);
			
		}
		
		/**
		 * Initializes singpleplayer mode on replaystate 
		 * 
		 * @return	void
		 */
		private function initSingleplayer():void {
			if (_highscore == true) {
				_messageString = "Yay, new high score!";
				_backgroundMusic.fade(0.1, 500, resetVolume);
				_winnerSound.play();
			} else if (_highscore == false){
				_messageString = "Sorry, no high score...";
				_backgroundMusic.fade(0.1, 500, resetVolume);
				_gameOverSound.play();
			}
			
			_scoreString = _score.toString();
			this.initHeader();
			this.initScore();
			this.initMessage();
		}
		
		private function resetVolume():void {
			_backgroundMusic.fade(0.5, 5000);
		}
		
		/**
		 * Initializes versus mode on replaystate 
		 * 
		 * @return	void
		 */
		private function initVersus():void {
			if (_winner == 3) {
				_headerString = "It's a";
				_messageString = "Try again!";
				_backgroundMusic.fade(0.1, 500, resetVolume);
				_gameOverSound.play();
			} else {
				_headerString = "The winner is...";
				_messageString = "Wohoo!";
				_backgroundMusic.fade(0.1, 500, resetVolume);
				_winnerSound.play();
			}
			this.initHeader();
			this.initWinner();
			this.initMessage();
		}
		
		/**
		 * Adds header text to textContainer
		 * 
		 * @return	void
		 */
		private function initHeader():void {
			var header:Text = new Text(0, 85, 590, 80);
			header.embedFonts = true;
			header.defaultTextFormat = getMessageFormat();
			header.text = _headerString;

			_textContainer.addChild(header);	
		}
		
		/**
		 * Adds score text to textContainer
		 * 
		 * @return	void
		 */
		private function initScore():void {
			var score:Text = new Text(0, 140, 590, 95);
			score.embedFonts = true;
			score.defaultTextFormat = getScoreFormat();
			score.text = _scoreString;
			
			_textContainer.addChild(score);
		}
		
		/**
		 * Adds message text to textContainer
		 * 
		 * @return	void
		 */
		private function initMessage():void {
			var message:Text = new Text(0, 250, 590, 80);
			message.embedFonts = true;
			message.defaultTextFormat = getMessageFormat();
			message.text = _messageString;
			
			_textContainer.addChild(message);
		}
		
		/**
		 * Sets winner text accordin to
		 * winner or draw.
		 * 
		 * @return	void
		 */
		private function initWinner():void {
			var winner:Text = new Text(0, 155, 590, 95);
			winner.embedFonts = true;
			winner.defaultTextFormat = getWinnerFormat();
			
			if (_winner == 0) {
				winner.text = "Player One";
			} else if (_winner == 1) {
				winner.text = "Player Two";
			} else if (_winner == 3) {
				winner.text = "Draw";
			} 
			
			_textContainer.addChild(winner);
		}
		
		/**
		 * Checks for input from controls.
		 * 
		 * @param	controls	player one or two controls
		 */
		private function updateControls(controls:EvertronControls):void {
			
			if (Input.keyboard.justPressed(controls.PLAYER_UP)) {
				_buttons.selectPrevious();
			}
			if (Input.keyboard.justPressed(controls.PLAYER_DOWN)) {
				_buttons.selectNext();
			}
			if(Input.keyboard.justPressed(controls.PLAYER_BUTTON_1)) {
				var btn:int = _buttons.activeIndex;
				if (btn == 0) {
					Session.application.displayState = new GameState(_gameMode);
				} else if (btn == 1) {
					Session.application.displayState = new MenuState();
				}
			}
		}
		
		/**
		 * Creates basic textformat for text
		 * 
		 * @return	TextFormat
		 */
		private function getBasicFormat():TextFormat {
			var format:TextFormat = new TextFormat();
			format.font = "ARCO";
			format.color = 0xFF00CC;
			format.align = TextFormatAlign.CENTER;
			
			return format;
		}
		
		/**
		 * Creates textformat for score text
		 * 
		 * @return	TextFormat
		 */
		private function getScoreFormat():TextFormat {
			var format:TextFormat = this.getBasicFormat();
			format.size = 85;

			return format;
		}
		
		/**
		 * Creates textformat for message text
		 * 
		 * @return	TextFormat
		 */
		private function getMessageFormat():TextFormat {
			var format:TextFormat =  this.getBasicFormat();
			format.color = 0x3CC6E8;
			format.size = 40;
			
			return format;
		}
		
		/**
		 * Creates textformat for winner text
		 * 
		 * @return	TextFormat
		 */
		private function getWinnerFormat():TextFormat {
			var format:TextFormat = this.getBasicFormat();
			format.size = 60;
			
			return format;
		}
	}
}