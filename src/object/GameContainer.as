package object {
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------
	import asset.BackgroundGFX;
	import asset.PlayerTrailGFX;	
	import collision.CollisionManager;	
	import logic.GameLogic;
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.system.Session;
	
	//----------------------------------------------------------------------
	// Public class
	//----------------------------------------------------------------------
	/**
	 * GameContainer initializes background, collisionManager, Player and GameWorld.
	 * Game controlls during gameplay are updated here.
	 * 
	 */
	public class GameContainer extends DisplayStateLayerSprite {
		
		//----------------------------------------------------------------------
		// Public getter and setter methods
		//----------------------------------------------------------------------
		
		/**
		 * Getter for player object
		 * 
		 * @param	
		 * @return	Boolean
		 */
		public function get player():Player {
			return _player;
		}
		
		/**
		 * Getter returns rotationflag.
		 * Informs if rotation is allowed or not.
		 * 
		 * @param	
		 * @return	Boolean
		 */
		public function get allowRotation():Boolean {
			return _rotationFlag;
		}
		
		/**
		 * Setter for rotationflag.
		 * 
		 * @param	Boolean
		 * @return	
		 */
		public function set allowRotation(value:Boolean):void {
			_rotationFlag = value;
		}
		
		//-------------------------------------------------------
		// Private properties
		//-------------------------------------------------------
		/**
		 * 
		 */
		private var _player:Player;
		
		/**
		 * Reference to EvertronControls
		 */
		private var _controller:EvertronControls;
		
		/**
		 * Reference to GameWorld
		 */
		private var _gameWorld:GameWorld;
		
		/**
		 * Reference to CollisionManager
		 */
		private var _collisionMng:CollisionManager;
		
		/**
		 * Callback to rotateWorld in GameScreen
		 */
		private var _callback:Function;
		
		/**
		 * GameScreen width
		 */
		private var _gsWidth:uint;
		
		/**
		 * Player id for player one(0) or player two(1)
		 */
		private var _playerId:uint;
		
		/**
		 * Reference to GameLogic
		 */
		private var _gameLogic:GameLogic;
		
		/**
		 * RotationFlag
		 * 
		 * @default		false
		 */
		private var _rotationFlag:Boolean = false;
		
		/**
		 * Players trail
		 */
		private var _playerTrail:PlayerTrailGFX;
		
		/**
		 * Reference to background movieclip
		 */
		private var _background:BackgroundGFX;
		
		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		public function GameContainer(callback:Function, gameLogic:GameLogic, playerId:uint = 0, width:uint = 800) {
			_controller = new EvertronControls(playerId);
			_callback = callback;
			_gsWidth = width;
			_gameLogic = gameLogic;
			_playerId = playerId;
			
			super();
		}
		
		//----------------------------------------------------------------------
		// Public methods
		//----------------------------------------------------------------------
		/**
		 * Initializes GameContainer compenents
		 *
		 * @param 	...
		 * @return 	void
		 */
		override public function init():void {
			this.initBackground();
			this.initPlayer();
			this.initGameWorld();
			this.addContent();
			this.initCollisionManager();
			
			Session.timer.create(500, function():void {
				allowRotation = true;
			});
		}
		
		/**
		 * Updates controls, track and checks for collisions.
		 * 
		 * @param	
		 * @return	void
		 */
		override public function update():void {
			this.updateControls();
			_collisionMng.checkCollision();
			_gameWorld.update();				
		}
		
		/**
		 * Deallocation code for the object.
		 * 
		 * @return 	void
		 */
		override public function dispose():void {	
			player.dispose();
			_player = null;
			_gameWorld.dispose();
			_gameWorld = null;
			_collisionMng = null;
			_background = null;
			
		}
		
		//-------------------------------------------------------
		// Private methods
		//-------------------------------------------------------
		/**
		 * Creates a background for the game.
		 * 
		 * @return	void
		 */
		private function initBackground():void {
			_background = new BackgroundGFX();
		}
		
		/**
		 * Initializes CollisionManager for collision control
		 * between player, track and objects.
		 *
		 * @param 	...
		 * @return 	void
		 */
		private function initCollisionManager():void {
			_collisionMng = new CollisionManager(this, _gameWorld, _gameLogic);
		}
		
		/**
		 * Initializes the player and the players trail.
		 *
		 * @param	...
		 * @return	void
		 */
		private function initPlayer():void {
			_playerTrail = new PlayerTrailGFX();
			_playerTrail.gotoAndStop(1);
			_playerTrail.x = _gsWidth/2 - 22;
			_playerTrail.y = 1500/2 + 20;
			_playerTrail.width = 44;
			_playerTrail.height = 15;
			
			_player = new Player(_playerTrail, _playerId, _callback);
			_player.x = _gsWidth/2 - 24;
			_player.y = 1500/2 - 24;
			_player.init();	
		}
		
		/**
		 * Initializes the game world that contains track, obstacles, etc. 
		 *
		 * @param	...
		 * @return	void
		 */
		private function initGameWorld():void {
			_gameWorld = new GameWorld(player, _gsWidth, _gameLogic);
			_gameWorld.init();	
			_gameLogic.subscribePlayer(player);
		}
		
		/**
		 * Adds all content in order after everything is 
		 * initialized to prevent errors.
		 *
		 * @param	...
		 * @return	void
		 */
		private function addContent():void {
			this.addChild(_background);
			this.addChild(_gameWorld);
			this.addChild(_playerTrail);
			this.addChild(player);
		}
		
		/**
		 * Handles input from controls.
		 *
		 * @param	...
		 * @return	void
		 */
		private function updateControls():void {
			if (_collisionMng.gameOver == true) {
				return;
			}
			if (Input.keyboard.justPressed(_controller.PLAYER_LEFT)) {
				_gameWorld.moveLeft(this);
				return;
			}
			
			if (Input.keyboard.justPressed(_controller.PLAYER_RIGHT)) {
				_gameWorld.moveRight(this);
				return;
			}
			
			if (Input.keyboard.justPressed(_controller.PLAYER_BUTTON_1)) {	
				if (this.allowLeftTurn() == true && this.allowRotation != false) {
					_gameWorld.centerPlayerToLane();
					player.rotateLeft();
					
					_callback(2);	
				}
				return;
			}
			
			if (Input.keyboard.justPressed(_controller.PLAYER_BUTTON_2)) {		
				if (this.allowRightTurn() == true && this.allowRotation != false) {
					_gameWorld.centerPlayerToLane();
					player.rotateRight();
					
					_callback(1);
				}
				return;
			}
			
			if (Input.keyboard.justPressed(_controller.PLAYER_UP)) {
				player.jump();
				return;
			}
		}
		
		/**
		 * Checks if left turn is allowed.
		 * False if turn-tween is already taking place.
		 *
		 * @param	...
		 * @return	Boolean
		 */
		private function allowLeftTurn():Boolean {
			if (_collisionMng.partDirection == 0 && player.direction == 1) {
				return false;
			}
			if (_collisionMng.partDirection == 1 && player.direction == 3) {
				return false;
			}
			if (_collisionMng.partDirection == 2 && player.direction == 0) {
				return false;
			}
			
			return true;		
		}
		
		/**
		 * Checks if right turn is allowed.
		 * False if turn-tween is already taking place.
		 *
		 * @param	...
		 * @return	Boolean
		 */
		private function allowRightTurn():Boolean {
			if (_collisionMng.partDirection == 0 && player.direction == 2) {
				return false;
			}
			if (_collisionMng.partDirection == 1 && player.direction == 0) {
				return false;
			}
			if (_collisionMng.partDirection == 2 && player.direction == 3) {
				return false;
			}
			
			return true;
		}
	}
}