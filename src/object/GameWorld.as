package object {
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	import flash.geom.Point;
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;
	import se.lnu.stickossdk.tween.easing.Sine;
	import logic.GameLogic;
	import object.track.Part;
	import object.track.PartContainer;
	import object.track.Track;
	
	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * GameWorld contains all object such as track, obstacles
	 * and tokens. All movement of the player is perfomed on 
	 * gameworld (to make it seem as if player is moving).
	 */
	public class GameWorld extends DisplayStateLayerSprite {

		//-------------------------------------------------------
		// Public getter and setter methods
		//-------------------------------------------------------
		/**
		 * Returns current speed.
		 * 
		 * @return	Number
		 */
		public function get speed():Number {
			return _speed;
		}
		
		/**
		 *	Set current speed.
		 *	
		 *	@param Number
		 */
		public function set speed(value:Number):void {
			_speed = value;
		}
		
		/**
		 *	Getter for current track placed in GameWorld
		 *	
		 *	@return	Track	 
		 */
		public function get track():Track {
			return _track;
		}
		
		/**
		 *	Getter for movingFlag.
		 * 	Informs if sideways moving is allowed.
		 *	
		 *	@return	Boolean	 
		 */
		public function get movingFlag():Boolean {
			return _movingFlag;
		}
		
		/**
		 *	Setter for movingflag.
		 *	
		 *	@param	Boolean	 
		 */
		public function set movingFlag(value:Boolean):void {
			_movingFlag = value;
		}
		
		//-------------------------------------------------------
		// Private static embedded constants
		//-------------------------------------------------------
		/**
		 * Sound for player movement
		 * 
		 * @default	Class
		 */
		[Embed(source="../../asset/sound/whoosh.mp3")]  
		private const WHOOSH:Class;
		
		//-------------------------------------------------------
		// Private static constants
		//-------------------------------------------------------
		/**
		 * The speed added to current speed 
		 * during the start acceleration phase.
		 * 
		 *	@default 0.5
		 */
		private static const START_ACC:Number = 0.5;
		
		/**
		 * The speed added to current speed 
		 * during the continous acceleration phase.
		 * 
		 *	@default 0.3
		 */
		private static const CONT_ACC:Number = 0.3;
		
		/**
		 * Max speed for the start acceleration distance.
		 * 
		 *	@default 3
		 */
		private static const MAX_START_SPEED:Number = 3;
		
		/**
		 * Max speed for the continous acceleration distance.
		 * Ergo, max speed in the game.
		 * 
		 *	@default 8
		 */
		private static const MAX_CONT_SPEED:Number = 8;
		
		/**
		 * GameWorld height
		 * 
		 *	@default 600
		 */
		private static const GW_HEIGHT:uint = 600;
		
		/**
		 * The witdh of a lane on a part.
		 * 
		 *	@default 48
		 */
		private static const LANE_WIDTH:Number = 48;
		
		/**
		 * The witdh of a part.
		 * 
		 *	@default 144
		 */
		private static const PART_WIDTH:Number = 144;
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		/**
		 * Reference to track object.
		 */
		private var _track:Track;
		
		/**
		 * Timer to regulate start speed and acceleration.
		 */
		private var _startSpeedTimer:Timer;
		
		/**
		 * Timer to regulate restart speed and acceleration.
		 * Eg. after respawn.
		 */
		private var _restartSpeedTimer:Timer;
		
		/**
		 * Timer to regulate continous speed and acceleration.
		 */
		private var _contSpeedTimer:Timer;
		
		/**
		 * Timer to regulate boosted speed inflicted by 
		 * power up.
		 */
		private var _speedBoostTimer:Timer;
		
		/**
		 * Timer to regulate reduced speed inflicted by 
		 * power down.
		 */
		private var _speedReduceTimer:Timer;
		
		/**
		 * Speed at wich GameWorld is moving.
		 * 
		 * @default 0 
		 */
		private var _speed:Number = 0;
		
		/**
		 * The width of the GameScreen
		 */
		private var _gsWidth:uint;
	
		/**
		 * Reference to GameLogic
		 */
		private var _gameLogic:GameLogic;
		
		/**
		 * Int reprecenting a parts index position in
		 * a vector.
		 */
		private var _currentIndex:int = 0;	
		
		/**
		 * The speed befor an event, such as boosted speed och death.
		 * Used to reset speed to previous speed berfore event.
		 */
		private var _beforeSpeed:Number = 0;
		
		/**
		 * Reference to the player object.
		 */
		private var _player:Player;
		
		/**
		 * Flag for sideways moving, to prevent tweens from interfering
		 * with one another.
		 * 
		 * @default	false
		 */
		private var _movingFlag:Boolean = false;
		
		/**
		 * Temporary Point
		 */
		private var _tempPoint:Point = new Point();
		
		/**
		 * Players position
		 */
		private var _playerPoint:Point = new Point();
		
		/**
		 * Reference to soundObject with "whooshing" soundFX.
		 */
		private var _whooshSound:SoundObject;
		
		/**
		 * Vector containing the current trackpart(s) 
		 * player is located on.
		 */
		private var _currentTrack:Vector.<PartContainer> = new Vector.<PartContainer>;;
		
		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		public function GameWorld(player:Player, width:uint, gameLogic:GameLogic){
			super();
			_player = player;
			_gsWidth = width;
			_gameLogic = gameLogic;
		}
		
		
		//-------------------------------------------------------
		// Public methods
		//-------------------------------------------------------
		/**
		 * Initializes sound, track and speedTimers.
		 *
		 * @param	...
		 * @return	void
		 */
		override public function init():void {
			this.initSound();
			this.initTrack();
			this.initSpeedTimers();
			_gameLogic.subscribeObserver(this);
			_playerPoint.x = _player.x;
			_playerPoint.y = _player.y;
		}
		
		/**
		 * Update loop for track, speed and player.
		 *
		 * @param	...
		 * @return	void
		 */
		override public function update():void {		
			this.scroll();			
			this.updateTrack();
			_player.updateSpeed(speed); 
		}
		
		/**
		 * Deallocation code for the object.
		 * 
		 * @return 	void
		 */
		override public function dispose():void {
			//@TODO
			_track.dispose();
			_track = null;
			_currentTrack = null;
			_whooshSound = null;
			_tempPoint = null;
			_playerPoint = null;
			
		}
		
		/**
		 * Returns vector with current trackparts 
		 * (1 or 2 parts) player is located on.
		 *
		 * @return	Vector.<PartContainer>
		 */
		public function getCurrentTrack():Vector.<PartContainer> {
			_currentTrack.length = 0;
			
			for(var i:int = 0; i < _track.trackParts.length; i++) {
				if (_player.hitTestObject(_track.trackParts[i]) == true) {
					_currentTrack.push(_track.trackParts[i]);
				}
			}
			return _currentTrack;
		}
		
		
		/** 
		 * On input from controls to move player left,
		 * move gameWorld right to illustrate the players
		 * movement. Player "moves" sideways to the next lane
		 * or falls of the track.
		 * 
		 * @param	gameContainer	To dissallow rotation while moving.
		 * @return	void
		 */
		public function moveLeft(gameContainer:GameContainer):void {
			if(this.movingFlag == true) {
				return;
			} else {
			
				this.movingFlag = true;
				gameContainer.allowRotation = false;
				_whooshSound.play();
				
				switch(_player.direction) {
					case 0: this.moveTweenX(this.x+LANE_WIDTH, function():void {
						notMoving(gameContainer);
					});
						break;
					case 1: moveTweenY(this.y-LANE_WIDTH, function():void {
						notMoving(gameContainer);
					});
						break;	
					case 2: moveTweenY(this.y+LANE_WIDTH, function():void {
						notMoving(gameContainer);
					});
						break;
				}
			}
		}
		
		/** 
		 * On input from controls to move player right,
		 * move gameWorld left to illustrate the players
		 * movement. Player "moves" sideways to the next lane
		 * or falls of the track.
		 * 
		 * @param	gameContainer	To dissallow rotation while moving.
		 * @return	void
		 */
		public function moveRight(gameContainer:GameContainer):void {
			if(this.movingFlag == true) {
				return;
			} else {
				this.movingFlag = true;
				gameContainer.allowRotation = false;
				_whooshSound.play();
				
				switch(_player.direction) {
					case 0: moveTweenX(this.x-LANE_WIDTH, function():void {
						notMoving(gameContainer);
					});
						break;
					case 1: moveTweenY(this.y+LANE_WIDTH, function():void {
						notMoving(gameContainer);
					});
						break;
					case 2: moveTweenY(this.y-LANE_WIDTH, function():void {
						notMoving(gameContainer);
					});
						break;
				}
			}
		}
		
		/**
		 * Stops all speedtimers, incase of eg. Game Over.
		 *
		 * @param	...
		 * @return	void
		 */
		public function stopSpeedtimers():void {
			this.normalSpeed();
			_beforeSpeed = this.speed;
			_restartSpeedTimer.stop();
			_startSpeedTimer.stop();
			_contSpeedTimer.stop();
			_speedBoostTimer.stop();
			_speedReduceTimer.stop();
		}
		
		/**
		 * Makes player 20% faster for 3 seconds.
		 * If speedBoost is already active it restarts.
		 *
		 * @return	void
		 */
		public function speedBoost():void {
			if (_speedReduceTimer.active == true) {
				_speedReduceTimer.stop();
				this.normalSpeed();
			} 
			
			if (_speedBoostTimer.active == true) {
				_speedBoostTimer.restart();
				if (_gameLogic.gamemode == 0) {
					_gameLogic.scoreManager.stopTimerFeedback(); 
					_gameLogic.scoreManager.speedTimerFeedback = true;
				} else {
					_gameLogic.lifeManager.stopTimerFeedback(_player.id);
					_gameLogic.lifeManager.speedTimerFeedback(_player.id, true);
				}
			} else {
				_gameLogic.multiplier = 5;
				_beforeSpeed = this.speed;
				this.speed = this.speed + (this.speed * 0.2);
				if (_gameLogic.gamemode == 0) {
					_gameLogic.scoreManager.speedTimerFeedback = true;
				} else {
					_gameLogic.lifeManager.speedTimerFeedback(_player.id, true);
				}
				_speedBoostTimer.start();
			}
		}
		
		/**
		 * Makes player 20% slower for 3 seconds.
		 * If speedReduce is already active it restarts.
		 *
		 * @return	void
		 */
		public function speedReduce():void {
			if (_speedBoostTimer.active == true) {
				_speedBoostTimer.stop();
				this.normalSpeed();
			}
			
			if (_speedReduceTimer.active == true) {
				_speedReduceTimer.restart();
				if (_gameLogic.gamemode == 0) {
					_gameLogic.scoreManager.stopTimerFeedback();
					_gameLogic.scoreManager.speedTimerFeedback = false;
				} else {
					_gameLogic.lifeManager.stopTimerFeedback(_player.id);
					_gameLogic.lifeManager.speedTimerFeedback(_player.id, false);
				}
			} else {
				_gameLogic.multiplier = 0;
				_beforeSpeed = this.speed;
				this.speed = this.speed-(this.speed * 0.2);
				if (_gameLogic.gamemode == 0) {
					_gameLogic.scoreManager.speedTimerFeedback = false;
				} else {
					_gameLogic.lifeManager.speedTimerFeedback(_player.id, false);
				}
				_speedReduceTimer.start();
			}
		}
		
		/**
		 * Centers GameWorld to the respawn point
		 * on player respawn. Calculates the distance
		 * between spawnpoint and deathpoint.
		 *
		 * @param	spawnPoint	point to center gameworld to.
		 * @param	deathPoint	the point were player died
		 * @return	void
		 */
		public function respawn(spawnPoint:Point, deathPoint:Point):void {
			this.x = this.x - (spawnPoint.x - deathPoint.x);
			this.y = this.y - (spawnPoint.y - deathPoint.y);
			Session.timer.create(1000, restartSpeed);
		}
		
		/**
		 * Center player to a lane on part after a 
		 * 90 degree turn depending on the direction
		 * the player is running in.
		 * 
		 * @return	void
		 */
		public function centerPlayerToLane():void {
			var currentTrack:Vector.<PartContainer> = this.getCurrentTrack();
			var currentPart:Part;
					
			if(currentTrack.length >= 2) {
				currentPart = currentTrack[1].part;
			} else {
				currentPart = currentTrack[0].part;
			}

			if (_player.direction == 0 || _player.direction == 3) {	
				this.centerPlayerY(currentPart);
			} else if(_player.direction == 1 || _player.direction == 2) {
				this.centerPlayerX(currentPart);
			} 	
			
			_whooshSound.play();
		}
		
		/**
		 * Centers player to gap when players hitbox collides 
		 * with a gap hitbox. Player then falls into the gap
		 * instead of through the track.
		 * 
		 * @param	gapPoint	Point to center player to.
		 */
		public function centerPlayerToGap(gapPoint:Point):void {
			Session.tweener.add(this, {
				x: this.x - (gapPoint.x - _player.x),
				y: this.y - (gapPoint.y - _player.y),
				duration: 500,
				transition: Sine.easeOut
			});
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		/**
		 * Initializes moving sound.
		 *
		 * @return	void
		 */
		private function initSound():void {
			Session.sound.soundChannel.sources.add("whoosh", WHOOSH);
			_whooshSound = Session.sound.soundChannel.get("whoosh", true, true);
		}
		
		/**
		 * Initalizes track.
		 *
		 * @return	void
		 */
		private function initTrack():void {
			_track = new Track(_gsWidth); 
			addChild(_track);
			_track.init();	
		}
		
		/**
		 * Scolls GameWorld according to players direction.
		 *
		 * @return	void
		 */
		private function scroll():void {
			switch(_player.direction) {
				case 0: this.y += this.speed; break;
				case 1: this.x += this.speed; break;
				case 2: this.x -= this.speed; break;
				case 3: this.y -= this.speed; break;
			}
		}	
		
		/**
		 * Updates track by adding and removing parts from a register. 
		 * The maximum number of parts placed in the world is 25. 
		 *  
		 * @param player
		 */
		private function updateTrack():void {
			var track:Vector.<PartContainer> = getCurrentTrack();
			if(track.length == 0) {
				return;
			}			
			var index:int = _track.trackParts.indexOf(track[0]);
			
			if (index != _currentIndex) {
				if(_track.trackParts.length >= 25) {	
					_currentIndex = index-1;
					_track.removeFirstPart(); 								
				} else {
					_currentIndex = index;
				}
				
				if(_track.trackParts.length < 25) {	
					if(_player.id == 0) {
						_track.updateTrack(_gameLogic._parts1[0], _gameLogic._parts1items[0]); 
					} else {
						_track.updateTrack(_gameLogic._parts2[0], _gameLogic._parts2items[0]);
					}
					_gameLogic.removeFirst(_player.id);						
				} 
			}
		}
		
		/**
		 * Initializes all speedTimers 
		 *
		 * @return	void
		 */
		private function initSpeedTimers():void {
			_startSpeedTimer = Session.timer.create(100, startSpeed, 0, false);
			_contSpeedTimer = Session.timer.create(8000, contSpeed, 0, false);
			_speedBoostTimer = Session.timer.create(3000, normalSpeed, 0, false);
			_speedReduceTimer = Session.timer.create(3000, normalSpeed, 0, false);
			_restartSpeedTimer = Session.timer.create(200, restartSpeed, 0, false);
			_startSpeedTimer.start();		
		}
		
		/**
		 * Startspeed runs over and oven until MAX_START_SPEED is reached.
		 * This creates a fast, short initial acceleration of player 
		 * on game start. 
		 *
		 * @return	void
		 */
		private function startSpeed():void {
			this.speed = this.speed+START_ACC;
			
			if(this.speed <= MAX_START_SPEED) {
				_startSpeedTimer.restart();
			} else {
				_contSpeedTimer.start();
			}
		}
		
		/**
		 * After respawn a shot acceleration, from 0 
		 * to the speed player had upon time of death,
		 * before continuos acceleration resumes. 
		 * 
		 * @return void
		 */
		private function restartSpeed():void {
			_player.trailFrame = "active";
			this.speed = this.speed + START_ACC;
			
			if(this.speed <= _beforeSpeed) {
				_restartSpeedTimer.restart();
			} else {
				_restartSpeedTimer.stop();
				_contSpeedTimer.start();
			}
		}
		
		/**
		 * Continous speed, updates until MAX_CONT_SPEED
		 * is reached. 
		 *
		 * @param	...
		 * @return	void
		 */
		private function contSpeed():void {
			this.speed = this.speed+CONT_ACC;
			
			if(this.speed < MAX_CONT_SPEED) {
				_contSpeedTimer.restart();
			} else {
				this.speed = MAX_CONT_SPEED;
			}
		}
		
		/**
		 * NormalSpeed resets the speed of the player, eg. after a speedBoost
		 * or on death before respawn.
		 *
		 * @return	void
		 */
		private function normalSpeed():void {
			if(_beforeSpeed != 0) {
				this.speed = _beforeSpeed;
			}
			_speedBoostTimer.stop();
			_speedReduceTimer.stop();
			_gameLogic.multiplier = 1;
			_player.trailFrame = "active";
			if (_gameLogic.gamemode == 0) {
				_gameLogic.scoreManager.stopTimerFeedback();
			} else {
				_gameLogic.lifeManager.stopTimerFeedback(_player.id);
			}
		}
		
		/**
		 * Centers player (by moving GameWorld) on Y-axis to a lane.
		 *
		 * @param currentPart	The part to center player on
		 * @return	void
		 */
		private function centerPlayerY(currentPart:Part):void {
			var playerOnPart:Point = currentPart.globalToLocal(_playerPoint);
			var globalCenterPoint:Point;
			
			if (playerOnPart.y >= 120) {
				_tempPoint.y = LANE_WIDTH*3;
			}
			else if (playerOnPart.y >= 80 && playerOnPart.y <= 120) {
				_tempPoint.y = LANE_WIDTH*2;
			}
			else if (playerOnPart.y >= 30 && playerOnPart.y <= 80) {
				_tempPoint.y = LANE_WIDTH;
			}
			else if (playerOnPart.y >= -30 && playerOnPart.y <= 30) {
				_tempPoint.y = 0;
			}
			else if (playerOnPart.y <= -30) {
				_tempPoint.y = -LANE_WIDTH;
			} 
			
			_tempPoint.x = playerOnPart.x;
			globalCenterPoint = currentPart.localToGlobal(_tempPoint);
			this.y = this.y + _player.y - globalCenterPoint.y;
		}
		
		/**
		 * Centers player (by moving GameWorld) on X-axis to a lane.
		 *
		 * @param currentPart	The part to center player on
		 * @return	void
		 */
		private function centerPlayerX(currentPart:Part):void {
			var playerOnPart:Point = currentPart.globalToLocal(_playerPoint);
			var globalCenterPoint:Point;
			
			if (playerOnPart.x >= 120) {
				_tempPoint.x = LANE_WIDTH*3;
			}
			else if (playerOnPart.x >= 80 && playerOnPart.x <= 120) {
				_tempPoint.x = LANE_WIDTH*2;
			}
			else if (playerOnPart.x >= 30 && playerOnPart.x <= 80) {
				_tempPoint.x = LANE_WIDTH;
			}
			else if (playerOnPart.x >= -30 && playerOnPart.x <= 30) {
				_tempPoint.x = 0;
			} 
			else if (playerOnPart.x <= -30) {
				_tempPoint.x = -LANE_WIDTH;
			} 

			_tempPoint.y = playerOnPart.y;
			globalCenterPoint = currentPart.localToGlobal(_tempPoint);
			this.x = this.x + _player.x - globalCenterPoint.x;
		}
		
		/**
		 * Tweening GameWorlds movement sideways on the X-axis.
		 *
		 * @param	move		The X-coordinates to move to.
		 * @param	callback	Initialised when tween is complete.
		 * @return	void
		 */
		private function moveTweenX(move:Number, callback:Function):void {
			Session.tweener.add(this, {
				x: move,
				duration: 100,
				transition: Sine.easeOut,
				onComplete: callback
			});
		}
		
		/**
		 * Tweening GameWorlds movement sideways on the Y-axis.
		 *
		 * @param	move		The Y-coordinates to move to.
		 * @param	callback	Initialised when tween is complete.
		 * @return	void
		 */
		private function moveTweenY(move:Number, callback:Function):void {
			Session.tweener.add(this, {
				y: move,
				duration: 100,
				transition: Sine.easeOut,
				onComplete: callback
			});			
		}
		
		/**
		 * Sets the movingFlag to false when tween is complete.
		 * 
		 * @param	gameContainer	To set allowRotation to true.
		 */
		private function notMoving(gameContainer:GameContainer):void {
			this.movingFlag = false;
			gameContainer.allowRotation = true;
		}
	}
}