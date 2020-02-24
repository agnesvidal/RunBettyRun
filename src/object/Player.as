package object {
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------
	import flash.display.MovieClip;
	
	import asset.PlayerOneGFX;
	import asset.PlayerTrailGFX;
	import asset.PlayerTwoGFX;
	
	import collision.Hitbox;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.tween.easing.Sine;
	
	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	public class Player extends DisplayStateLayerSprite {
		
		//----------------------------------------------------------------------
		// Public getter and setter methods
		//----------------------------------------------------------------------
		/**
		 * Flag for when the player is jumping. 
		 * @return 	Boolean
		 * 
		 */
		public function get jumping():Boolean {
			return _jumping;
		}
		
		/**
		 * Returns the player's id.
		 *  
		 * @return 	uint
		 */
		public function get id():uint {
			return _id;
		}
		
		/**
		 * Returns the players skin.
		 *  
		 * @return 	MovieClip
		 */
		public function get skin():MovieClip {
			return _skin;
		}
		
		/**
		 * Setter the players skin frame.
		 * Eg. running or idle
		 *  
		 * @param	value	String
		 */
		public function set skinFrame(value:String):void {
			_skin.gotoAndStop(value);
		}
		
		/**
		 * Changes the player's trail depending on if it's running 
		 * or idle.
		 * 
		 * @param 	value 	String 
		 */
		public function set trailFrame(value:String):void {
			_trail.gotoAndStop(value);
		}
		
		/**
		 * Returns the player's hitbox. 
		 * 
		 * @return 	Hitbox
		 */
		public function get hitBox():Hitbox {
			return _hitBox;
		}

		//----------------------------------------------------------------------
		// Public properties
		//----------------------------------------------------------------------
		/**
		 * The direction the player is facing/running
		 */
		public var direction:uint = 0;
		
		//-------------------------------------------------------
		// Private static embedded constants
		//-------------------------------------------------------
		/**
		 * Source to jump sound.
		 */
		[Embed(source="../../asset/sound/jump.mp3")]  
		private static const JUMP:Class; 
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		/**
		 * Players hitbox
		 */
		private var _hitBox:Hitbox;
		
		/**
		 * Players skin, graphic representation of player.
		 */
		private var _skin:MovieClip;
		
		/**
		 * Players trail of particles while running.
		 */
		private var _trail:PlayerTrailGFX;
		
		/**
		 * Player id.
		 */
		private var _id:uint;
		
		/**
		 * GameWorlds speed
		 */
		private var _speed:Number = 0;	
		
		/**
		 * Millisecons a jump lasts
		 */
		private var _jumpDuration:Number;
		
		/**
		 * Flag - if player is jumping or not
		 * 
		 * @default	 false
		 */
		private var _jumping:Boolean = false;
		
		/**
		 * Flag - if second jump i taking place.
		 */
		private var _secondJump:Boolean;
		
		/**
		 * Reference to soundFX for jump.
		 */
		private var _jumpSound:SoundObject;
		
		/**
		 * Callback to rotateWorld method in GameScreen.
		 */
		private var _callback:Function;
		
		/**
		 * Last type of rotation of GameScreen.
		 */
		private var _lastRotation:uint;
		
		//----------------------------------------------------------------------
		// Constructor method
		//----------------------------------------------------------------------
		public function Player(trail:PlayerTrailGFX, player:uint = 0, callback:Function = null) {
			super();
			_trail = trail;
			_id = player;
			_callback = callback;
		}
		
		//----------------------------------------------------------------------
		// Override public methods
		//----------------------------------------------------------------------
		override public function init():void {
			this.initSkin();
			this.initHitbox();
			this.initSound();
		}
		
		/**
		 * Deallocation code for the object.
		 * 
		 * @return 	void
		 */
		override public function dispose():void {
			//@TODO
			_skin = null;
			_hitBox = null;
		}
		
		//----------------------------------------------------------------------
		// Public methods
		//----------------------------------------------------------------------	
		/**
		 * Updates player's speed.
		 *
		 * @param	speed	Number representing the speed
		 * @return	void
		 */
		public function updateSpeed(speed:Number):void {	
			_speed = speed;
		}
		
		/**
		 * Resets the player's trail to the original position. 
		 * 
		 * @param 	direction	Direction the player is facing.
		 * @return 	void
		 */
		public function  resetTrail(direction:uint):void {
			if(direction == 0) {
				_trail.rotation = 0;
				_trail.x = 728;
				_trail.y = 770;
				
			} else if (direction == 1){
				_trail.rotation = -90;
				_trail.x = 728 + 40;
				_trail.y = 770;
			} else {
				_trail.rotation = 90;
				_trail.x = 728;
				_trail.y = 770 - 40;
			}
			trailFrame = "active";
		}
		
		/**
		* Sets player direction and rotates skin 
		* left on input from controls.
		*
		* @return	void
		*/
		public function rotateLeft():void {
			this.changePlayerDirection(1);
			this.rotatePlayer(-90);
			_lastRotation = 1;
		}
		
		/**
		 * Sets player direction and rotates skin
		 * rights on input from controls.
		 *
		 * @return	void
		 */
		public function rotateRight():void {
			this.changePlayerDirection(2);
			this.rotatePlayer(90);
			_lastRotation = 2;
		}
		
		/**
		 * Animates the skin upon death.
		 *
		 * @return	void
		 */
		public function death():void {
			this.trailFrame = "idle";
			Session.tweener.add(_skin, {
				scaleX: 0.1,
				scaleY: 0.1,
				duration: 1500,
				transition: Sine.easeOut
			});	
		}
		
		
		/**
		 * Respawn skin (rotation & scale) and reset direction.
		 *
		 * @param	trackDirection	direction of last know part.
		 * @return	void
		 */
		public function respawn(trackDirection:uint):void {
			
			if(this.direction != trackDirection) {
				if (_lastRotation == 1) {
					_callback(1);
				} else if (_lastRotation == 2) {
					_callback(2);
				}
			}

			switch(trackDirection) {
				case 0: _skin.rotation = 0;
					this.direction = 0;
					this.resetTrail(0);
					break;
				case 1: _skin.rotation = -90;
					this.direction = 1;
					this.resetTrail(1);
					break;
				case 2: _skin.rotation = 90;
					changePlayerDirection(2);
					this.direction = 2;
					this.resetTrail(2);
					break;
			}

			_skin.scaleX = 1;
			_skin.scaleY = 1;
			this.skinFrame = "running";
			
		}
		
		/**
		* Makes the player jump. If the player is already in the air
		* it performs a double jump
		*
		* @return	void
		*/
		public function jump():void {
			if(_speed == 0) {
				return;
			}
			this.skinFrame = "idle";
			_jumpDuration = 825 / _speed;
			_jumpSound.play();
			_jumpSound.volume = 1;
			
			if(_jumping == true && _secondJump == false) {
				_secondJump = true;
				Session.tweener.add(_skin, {
					scaleX: 1.4,
					scaleY: 1.4,
					duration: _jumpDuration/2,
					transition: Sine.easeOut,
					onComplete: doubleJumpInAir
				});
			}
			
			if(_jumping == false) {
				_jumping = true;
				Session.tweener.add(_skin, {
					scaleX: 1.2,
					scaleY: 1.2,
					duration: _jumpDuration,
					transition: Sine.easeOut,
					onComplete: inAir
				});
			}	
		}

		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		/**
		 * Tween for when the player is in the air during a jump.
		 * 
		 * @return	void
		 */
		private function inAir():void {
			Session.tweener.add(_skin, {
				scaleX: 1,
				scaleY: 1,
				duration: _jumpDuration,
				transition: Sine.easeIn,
				onComplete: jumpComplete
			});
		}
		
		/**
		 * Tween for when the player is in the air during a double jump.
		 * 
		 * @return	void
		 */
		private function doubleJumpInAir():void {
			Session.tweener.add(_skin, {
				scaleX: 1,
				scaleY: 1,
				duration: _jumpDuration,
				transition: Sine.easeIn,
				onComplete: doubleJumpComplete
			});
		}
		
		/**
		 * Activates when the player lands after a jump. 
		 * Makes the player start running again.
		 * 
		 * @return	void
		 */
		private function jumpComplete():void {
			this.skinFrame = "running";
			_jumping = false;
		}
		
		
		/**
		 * Activates when the player lands after a double
		 * jump. Makes the player start running again.
		 * 
		 * @return	void
		 */
		private function doubleJumpComplete():void {
			this.skinFrame = "running";
			_jumping = false;
			_secondJump = false;
		}
		
		/**
		* Initializes player's skin.
		*
		* @return	void
		*/
		private function initSkin():void {
			if(_id == 0) {
				_skin = new PlayerOneGFX();
			} else {
				_skin = new PlayerTwoGFX();
			}
			_skin.scaleX = 1;
			_skin.scaleY = 1;
			_skin.x = 24;
			_skin.y = 24;
			this.skinFrame = "running";
			this.addChild(_skin);	
		}
		
		/**
		* Initializes player's hitbox
		*
		* @return	void
		*/
		private function initHitbox():void {
			_hitBox = new Hitbox(this);
			_hitBox.width = 32;
			_hitBox.height = 32;
			_hitBox.x = 8;
			_hitBox.y = 8;
		}
		
		/**
		 * Adds sound for jumping. 
		 * @return 	void
		 */
		private function initSound():void {
			Session.sound.soundChannel.sources.add("jump", JUMP);
			_jumpSound = Session.sound.soundChannel.get("jump", true, true);
		}
		
		/**
		* Rotates players skin and trail.
		*
		* @param	angleDegrees	degreeds to rotate
		* @return	void
		*/
		private function rotatePlayer(angleDegrees:Number):void {		
			_skin.rotation += angleDegrees;
			_trail.rotation += angleDegrees;				
		}
		
		/**
		* Changes players direction property, as well as the trail's position.
		*
		* @param	turnDir - direction the turn the player is taking
		* @return	void
		*/
		private function changePlayerDirection(turnDir:int):void {
			//running up, turn left
			if(this.direction == 0 && turnDir == 1){
				this.direction = 1;
				_trail.x += 40;
			}
			//running up, turn right
			else if(this.direction == 0 && turnDir == 2){
				this.direction = 2;
				_trail.y -= 40;
			}
			//running left, turn left (down)
			else if(this.direction == 1 && turnDir == 1){
				this.direction = 3;
				_trail.y -= 40;
			}
			//running right, turn right (down)
			else if(this.direction == 2 && turnDir == 2){
				this.direction = 3;
				_trail.x += 40;
			}
			//running down, turn left
			else if(this.direction == 3 && turnDir == 1){
				this.direction = 2;
				_trail.x -= 40;
			}
			//running down, turn right
			else if(this.direction == 3 && turnDir == 2){
				this.direction = 1;
				_trail.y += 40;
			}
			//running right, turn left
			else if(this.direction == 2  && turnDir == 1) { 
				this.direction = 0;
				_trail.y += 40;
			}
			//running left, turn right
			else if(this.direction == 1  && turnDir == 2) {
				this.direction = 0;
				_trail.x -= 40;
			}
			//running right or left, turn up
			else if(this.direction == 1 || this.direction == 2) {
				this.direction = 0;
			}		
		}	
	}
}