package state {
	//-------------------------------------------------------------------------
	// Imports
	//-------------------------------------------------------------------------
	import flash.display.Sprite;
	
	import asset.CreditsMenuGFX;
	import asset.MenuGFX;
	
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
	 * Creates new credit state.
	 */
	public class CreditsState extends DisplayState {
		
		/**
		 * Player 1 controls.
		 */
		private var _playerOneControls:EvertronControls = new EvertronControls(0);
		
		/**
		 * Player 1 controls.
		 */
		private var _playerTwoControls:EvertronControls = new EvertronControls(1);
		
		/**
		 * DisplayStateLayer.
		 */
		private var _layer:DisplayStateLayer;
		
		/**
		 * Vector with classes for buttons.
		 */
		private var _buttonsGFXs:Vector.<Class> = new <Class>[MenuGFX];
		
		/**
		 * Buttons object.
		 */
		private var _buttons:Buttons;
		
		/**
		 * MovieClip with graphics for state
		 */
		private var _graphics:CreditsMenuGFX;
		
		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		public function CreditsState() {
			super();
		}
		
		//-------------------------------------------------------
		// Override public methods
		//-------------------------------------------------------
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
			_playerOneControls = null;
			_playerTwoControls = null;
			_buttonsGFXs = null;
			_buttons = null;
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		/**
		 * Initializes DisplayStateLayer
		 */
		private function initLayer():void {
			_layer = this.layers.add("credits");
		}
		
		/**
		 * Initializes graphics for credits
		 */
		private function initGraphics():void {
			_graphics = new CreditsMenuGFX();
			_graphics.x = 60;
			_graphics.y = 40;
			_layer.addChild(_graphics);
		}
		
		/**
		 * Adds buttons to state
		 */
		private function initButtons():void {
			_buttons = new Buttons(_buttonsGFXs);
			var btnCont:Sprite = _buttons.getContainer();
			btnCont.x = 80;
			btnCont.y = 500;
			_layer.addChild(btnCont);
		}

		/**
		 * Update players controls.
		 */
		private function updateControls(controls:EvertronControls):void {
			if(Input.keyboard.justPressed(controls.PLAYER_BUTTON_1)) {
				Session.application.displayState = new MenuState();
			}
		}
	}
}