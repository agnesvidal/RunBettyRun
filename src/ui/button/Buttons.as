package ui.button {
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------
	import flash.display.Sprite;
	
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;

	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Creates vector with, and container for, buttons
	 * for a state. Handles selection buttons.
	 */
	public class Buttons {
		
		//-------------------------------------------------------
		// Public getter and setter methods
		//-------------------------------------------------------
		/**
		 * getter for active/selected button
		 * 
		 * @return	int		index of selected button
		 */
		public function get activeIndex():int {	
			return _buttons.indexOf(_active);
		}
		
		//-------------------------------------------------------
		// Private static embedded constants
		//-------------------------------------------------------
		/**
		 * Source to select sound.
		 */
		[Embed(source="../../../asset/sound/select.mp3")]  
		private static const SELECT_SOUND:Class; 
		
		//-------------------------------------------------------
		// Private properties
		//-------------------------------------------------------
		/**
		 * Vector with GFX classes for buttons
		 */
		private var _buttonsGFXs:Vector.<Class>;
		
		/**
		 * Vector containing all buttons.
		 */
		private var _buttons:Vector.<Button>;
		
		/**
		 * The selected/active button.
		 */
		private var _active:Button;
		
		/**
		 * Reference to sound effect
		 */
		private var _selectSound:SoundObject;
		
		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		/**
		 * creates new buttons
		 * 
		 * @param	vector	Vector with classes for buttons
		 */
		public function Buttons(buttonGFXs:Vector.<Class>) {
			_buttons = new Vector.<Button>();
			_buttonsGFXs = buttonGFXs;
			this.initButtons();
			this.initSound();
		}
		
		//-------------------------------------------------------
		// Public methods
		//-------------------------------------------------------
		/**
		 * Select next button in vector. If last, select first.
		 * Called upon input from control.
		 * 
		 * @return	void
		 */
		public function selectNext():void {
			var currentBtn:int = _buttons.indexOf(_active) + 1;
			_active.frame = "deselect";
			_active = currentBtn >= _buttons.length ? _buttons[0] : _buttons[currentBtn];
			_active.frame = "select";
			_selectSound.play();
		}
		
		/**
		 * Select previous button in vector. If first, select last.
		 * Called upon input from control.
		 * 
		 * @return	void
		 */
		public function selectPrevious():void {
			var currentBtn:int = _buttons.indexOf(_active) -1;
			_active.frame = "deselect";
			_active = currentBtn == -1 ? _buttons[_buttons.length-1] : _buttons[currentBtn];
			_active.frame = "select";
			_selectSound.play();
			_selectSound.volume = 0.8;
		}
		
		/**
		 * Returns a sprite container with graphic
		 * representations of the buttons.
		 * 
		 * @return	Sprite
		 */
		public function getContainer():Sprite {
			var margin:int = 30;
			var container:Sprite = new Sprite();
			
			for(var i:int = 0; i < _buttons.length; i++) {
				_buttons[i].y = (_buttons[i].height + margin) * i;
				container.addChild(_buttons[i]);
				
			}	
			return container;
		}
		
		//-------------------------------------------------------
		// Private methods
		//-------------------------------------------------------
		/**
		 * Creates a new button for every class in
		 * _buttonsGFXs. Set first button to active/selected.
		 * 
		 * @return	void
		 */
		
		private function initButtons():void {
			for (var i:int = 0; i < _buttonsGFXs.length; i++) {
				var btn:Button = new Button(_buttonsGFXs[i]);
				btn.frame = "deselect";
				_buttons.push(btn);
			}
			_active = _buttons[0];
			_active.frame = "select";
		}
		
		/**
		 * Add sound effect for selecting new button
		 * @return 	void
		 */
		private function initSound():void {
			Session.sound.soundChannel.sources.add("slect", SELECT_SOUND);
			_selectSound = Session.sound.soundChannel.get("slect", true, true);
		}

	}
}