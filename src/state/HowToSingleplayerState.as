package state {
	//-------------------------------------------------------------------------
	// Imports
	//-------------------------------------------------------------------------
	import flash.display.Sprite;
	
	import asset.HowToSingleplayerGFX;
	import asset.MenuGFX;
	import asset.PlayGFX;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.system.Session;
	
	import ui.button.Buttons;
	
	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Creates new state with rules and 
	 * instructions for singpleplayer game
	 */
	public class HowToSingleplayerState extends DisplayState {
		
		//-------------------------------------------------------
		// Private properties
		//-------------------------------------------------------
		private var _playerOneControls:EvertronControls = new EvertronControls(0);
		private var _playerTwoControls:EvertronControls = new EvertronControls(1);
		private var _layer:DisplayStateLayer;
		private var _graphics:HowToSingleplayerGFX;
		private var _buttonsGFXs:Vector.<Class> = new <Class>[PlayGFX, MenuGFX];
		private var _buttons:Buttons;
		
		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		public function HowToSingleplayerState() {
			super();
		}
		
		//----------------------------------------------------------------------
		// Override public methods
		//----------------------------------------------------------------------
		override public function init():void {
			this.initLayer();
			this.initGraphics();
			this.initButtons();
		}
		
		override public function update():void {
			this.updateControls(_playerOneControls);
			this.updateControls(_playerTwoControls);
			
		}
		
		override public function dispose():void {
			_graphics = null;
			_buttons = null;
			
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 * Creates DisplayStateLayer
		 */
		private function initLayer():void {
			_layer = this.layers.add("howToVersus");
		}
		
		/**
		 * Adds MovieClip with graphics.
		 */
		private function initGraphics():void {
			_graphics = new HowToSingleplayerGFX();
			_graphics.x = 30;
			_graphics.y = 15;
			_layer.addChild(_graphics);
			
		}
		
		/**
		 * Creates buttons
		 */
		private function initButtons():void {
			_buttons = new Buttons(_buttonsGFXs);
			var btnCont:Sprite = _buttons.getContainer();
			btnCont.x = 30;
			btnCont.y = 480;
			_layer.addChild(btnCont);
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
					Session.application.displayState = new GameState(0);
				} else if (btn == 1) {
					Session.application.displayState = new MenuState();
				}
			}
			
		}

	}
}