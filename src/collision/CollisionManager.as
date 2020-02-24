package collision {
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	import se.lnu.stickossdk.fx.Flicker;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import logic.GameLogic;
	
	import object.GameContainer;
	import object.GameWorld;
	import object.Player;
	import object.SpeedBoost;
	import object.SpeedReduce;
	import object.Token;
	import object.obstacle.Gap;
	import object.track.Part;
	import object.track.PartContainer;
	import object.track.part.Grid;
	
	import state.ReplayState;
	
	//----------------------------------------------------------------------
	// Public class
	//----------------------------------------------------------------------
	/**
	 * Handles all collisions between objects.
	 */
	public class CollisionManager {
		//-------------------------------------------------------
		// Public getter and setter methods
		//-------------------------------------------------------
		/**
		 * Public getter for the current direction
		 * of the part the player is located on.
		 * 
		 * @return uint
		 */		
		public function get partDirection():uint {
			return _partDirection;
		}
		
		//-------------------------------------------------------
		// Public properties
		//-------------------------------------------------------
		public var gameOver:Boolean = false;
		
		//-------------------------------------------------------
		// Private static embedded constants
		//-------------------------------------------------------
		
		/**
		 *	Sound effect for when a bubble pops
		 * 
		 *	@default Class
		 */
		[Embed(source="../../asset/sound/bubble.mp3")]  
		private const BUBBLE_POP:Class;
		
		/**
		 *	Sound effect for when player falls off track
		 * 
		 *	@default Class
		 */
		[Embed(source="../../asset/sound/fall.mp3")]  
		private const FALLING:Class;
		
		//-------------------------------------------------------
		// Private getter and setter methods
		//-------------------------------------------------------
		/**
		 * Getter - returns the part where the player 
		 * should respawn based on where it died.
		 * 
		 * @return Part		RespawnPart
		 */	
		private function get respawnPart():Part {
			var trackParts:Vector.<PartContainer> = this._gameWorld.track.trackParts;
			var i:int = trackParts.indexOf(lastPartContainer);	
			return trackParts[i].part;
		}
		
		/**
		 * Set lastPartContainer.
		 * 
		 * @param	PartContainter
		 * @return 	void
		 */	
		private function set lastPartContainer(value:PartContainer):void {
			_lastPartContainer = value;
		}
		
		/**
		 * Get lastPartContainer
		 * 
		 * @param	
		 * @return 	PartContainer
		 */
		private function get lastPartContainer():PartContainer {
			return _lastPartContainer;
		}
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		private var _player:Player;
		private var _gameWorld:GameWorld;
		private var _gameLogic:GameLogic;
		private var _gameContainer:GameContainer;
		private var _imortal:Boolean = false;
		private var _lastPartContainer:PartContainer = null;
		private var _respawnPart:Part = null;
		private var _token:Object = null;	
		//private var _tokens:Array = [];
		private var _lastToken:uint = 0;
		private var _tempPoint:Point = new Point();
		private var _bubbleSound:SoundObject;
		private var _fallingSound:SoundObject;
		private var _partDirection:uint;
		private var _winner:uint;
		
		//----------------------------------------------------------------------
		// Constructor method
		//----------------------------------------------------------------------
		public function CollisionManager(container:GameContainer, world:GameWorld, logic:GameLogic) {
			this._player = container.player;
			this._gameContainer = container;
			this._gameWorld = world;
			this._gameLogic = logic;
			this.lastPartContainer = this.currentPartContainer();
			this.initSound();
		}
		
		//----------------------------------------------------------------------
		// Public methods
		//----------------------------------------------------------------------
		/**
		 * Collision check between player and track. If the player
		 * is not on track Game Over initializes. If player is on 
		 * track, another collision check for the trackparts children 
		 * is executed.
		 *
		 * @return	void
		 */
		public function checkCollision():void {
			var pc:PartContainer = this.currentPartContainer();
			if(_player.jumping == true) {
				return;
			}
			if(this.gameOver == true) {
				return;
			}
			
			if(pc == null) {
				this.gameOver = true;
				this.initGameOver(1);
			} else { 
				
				if (_gameLogic.gamemode == 0 && lastPartContainer !== pc) {
					this.checkPickUp();
					this.checkIfToken(pc);
				}

				_partDirection = pc.part.runningDirection;
				this.lastPartContainer = pc;
				
				if(_imortal != true) {
					this.checkChildCollision(pc.part.grid);
				} 	
			}
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		/**
		 * Initializes sound
		 *
		 * @return	void
		 */
		private function initSound():void {
			Session.sound.soundChannel.sources.add("pop", BUBBLE_POP);
			_bubbleSound = Session.sound.soundChannel.get("pop", true, true);
			Session.sound.soundChannel.sources.add("fall", FALLING);
			_fallingSound = Session.sound.soundChannel.get("fall", true, true);
		}
		
		/**
		 * Checks for collisions with a parts grid children.
		 * eg. pick-ups and obstacles.
		 *
		 * @param	grid	Grid of part player is located on
		 * @return	void
		 */
		private function checkChildCollision(grid:Grid):void {
			if (_imortal == true) {
				return;
			}
			
			for(var r:int = 0; r<3; r++){
				for(var c:int = 0; c<3; c++){
					var cell:Sprite = grid.getCellAt(r,c);
					if(cell.numChildren > 0) {
						var item:Object = cell.getChildAt(0);
						if (_player.hitBox.hitCheck(item.hitBox) == true) {
							
							if (item is Gap) {
								this.gameOver = true;
								this.initGameOver(2, item);
							}
							
							if (item is Token) {
								if (_gameLogic.gamemode == 0) {
									_gameLogic.scoreManager.updateCombo(true);
									_token = null;
								} else {
									_gameLogic.lifeManager.updateLifeScore(_player.id);
								}
								cell.removeChild(cell.getChildAt(0));
								_bubbleSound.play();	
								_bubbleSound.volume = 0.5;
							}
							
							if (item is SpeedBoost) {
								cell.removeChild(cell.getChildAt(0));
								_gameWorld.speedBoost();
								_bubbleSound.play();
								_bubbleSound.volume = 0.5
							}
							
							if (item is SpeedReduce) {
								cell.removeChild(cell.getChildAt(0));
								_gameWorld.speedReduce();
								if (_gameLogic.gamemode == 0) {
									_gameLogic.scoreManager.updateCombo(false);
								} else {
									_gameLogic.lifeManager.reduceLifePoints(_player.id);
								}
								_bubbleSound.play();
								_bubbleSound.volume = 0.5
							}	
						} 
					}
				}
			}		
		}
		
		/**
		 * Returns the partContainer a player is located on.
		 *
		 * @return	partContainer
		 */
		private function currentPartContainer():PartContainer {
			var partContainer:PartContainer = null;
			var track:Vector.<PartContainer> = _gameWorld.getCurrentTrack();
			
			for(var i:int = 0; i < track.length; i++) {
				if (_player.hitBox.hitCheck(track[i].hitBox) == true) {
					partContainer = track[i];
				}
			}
			
			return partContainer;
		}
		
		/**
		 * Checks if last token was picked up. If it wasn't
		 * the combo breaks.
		 *
		 * @param	pc		PartContainer to check
		 * @return	void
		 */
		private function checkPickUp():void{
				if(_token != null) {
					/*
					while (_tokens.length > 0) {
						_tokens.splice(0);
					}
					*/
					this._gameLogic.scoreManager.updateCombo(false);
					//_lastToken = 0;	
				}
		}
		
		/**
		 * Checks if any cell in the PartContainer's grid has a 
		 * child token. If it has, it saves a reference to that 
		 * token. The reference is used in the combo system to
		 * check wether a combo is initiated/active.
		 * 
		 * @param 	pc		PartContainer to check
		 */
		private function checkIfToken(pc:PartContainer):void{
			for(var r:int = 0; r<3; r++){
				for(var c:int = 0; c<3; c++){
					var cell:Sprite = pc.part.grid.getCellAt(r,c);
					if(cell.numChildren > 0) {
						var item:Object = cell.getChildAt(0);
						if (item is Token) {	
							_token = item;
							//_tokens.push(item);
						}
					}
				}
			}
		}
		
		/**
		 * Initializes game over.
		 *
		 * @param	deathtype	1: fall over edge. 2: fall into gap.
		 * @param	gap			The gap player fell into
		 * @return	void
		 */
		private function initGameOver(deathtype:int, gap:Object = null):void {
			_player.trailFrame = "idle";
			
			if (_gameLogic.gamemode == 0) {
				_gameLogic.stopTimers();
				Session.timer.create(2000, checkHighscore);
				deathAnimation(deathtype, gap);
				
			} else {	
				_gameLogic.lifeManager.removeLife(_player.id);			
				this.deathAnimation(deathtype, gap);
				Session.timer.create(100, checkLives);
				Session.timer.create(2500, respawn);
			}	
		}

		
		/**
		 * Animates and initializes the players death sequence.
		 *
		 * @param	deathtype	1: fall over edge. 2: fall into gap.
		 * @param	gap			The gap player fell into
		 * @return	void
		 */
		private function deathAnimation(deathtype:int, gap:Object = null):void {
			_fallingSound.play();
			if(deathtype == 1) {
				Session.timer.create(200, function():void {
					_gameLogic.stopPlayer(_player.id);
				});
				_player.death();
			} 
					
			else if (deathtype == 2) {
				_tempPoint.x = gap.x;
				_tempPoint.y = gap.y;
				var gapPoint:Point = gap.localToGlobal(_tempPoint);
				
				_gameLogic.stopPlayer(_player.id);
				Session.tweener.remove(_gameWorld);
				_gameWorld.movingFlag = false;
				_gameWorld.centerPlayerToGap(gapPoint);
				_player.death();
			}	
		}

		/**
		 * If player is out of extra lives, endGameVersus is called.
		 * If not the player respawns at the center of the last part
		 * player was upon.
		 *
		 * @param	
		 * @return	void
		 */
		private function respawn():void {
			if(this._gameLogic.lifeManager.getLives(_player.id) < 1) {
				this.endGameVersus();
				
			} else {
				var cell:Sprite = this.respawnPart.grid.getCellAt(1,1);
				_tempPoint.x = cell.x;
				_tempPoint.y = cell.y;
				var spawnPoint:Point = this.respawnPart.localToGlobal(_tempPoint);
				var deathPoint:Point = new Point(this._player.x, this._player.y);

				_player.respawn(_partDirection);
				_gameWorld.respawn(spawnPoint, deathPoint);
				this.gameOver = false;	
				_imortal = true;
				
				Session.effects.add(new Flicker(_player.skin, 2500));
				Session.timer.create(2500, notImortal);	
			}
		}
		
		/**
		 * Callback for timer.
		 * After respawn, the player is no 
		 * longer imortal after 2500 ms.
		 * 
		 * @param	
		 * @return	void
		 */
		private function notImortal():void {
			_imortal = false;
		}
		
		/**
		 * Check if player achived new highscore.
		 * 
		 * @param	
		 * @return	void
		 */
		private function checkHighscore():void {
			Session.highscore.smartSend(1, _gameLogic.scoreManager.score, 10, endGameSingleplayer);
		}
		
		/**
		 * Callback for smartsend - checkHighscore
		 * initializes Replaystate with information
		 * on player success to achive highscore or not.
		 * 
		 * @param	data	XML data from smartsend
		 * @return	void
		 */
		private function endGameSingleplayer(data:XML = null):void {
			if (data.header.success == true) {
				Session.application.displayState = new ReplayState(_gameLogic.gamemode, true, _gameLogic.scoreManager.score);	
			} else {
				Session.application.displayState = new ReplayState(_gameLogic.gamemode, false, _gameLogic.scoreManager.score);
			}
		}
		
		/**
		 * Checks number of lives of both players. Decides wheter who wins,
		 * or if it is a draw.
		 * 
		 * @return	void
		 */
		private function checkLives():void {
			var p0Lives:int = this._gameLogic.lifeManager.getLives(0);
			var p1Lives:int = this._gameLogic.lifeManager.getLives(1);
			if (p0Lives == 0 && p1Lives == 0) {
				_winner = 3;
			} else if(p0Lives == 0 && p1Lives > 0) {
				_gameLogic.lifeManager.setWinner(1);
				_winner = 1;
			} else if (p1Lives == 0 && p0Lives > 0) {
				_gameLogic.lifeManager.setWinner(0);
				_winner = 0;	
			}
		}
		
		/**
		 * Calls ReplayState to show end game result (winner/loser/draw).
		 * 
		 * @param	
		 * @return	void
		 */
		private function endGameVersus():void {
			if (_winner == 3) {	
				Session.application.displayState = new ReplayState(this._gameLogic.gamemode, null, 0, 3);
			} else if(_winner == 1) {
				Session.application.displayState = new ReplayState(this._gameLogic.gamemode, null, 0, 1);
			} else if (_winner == 0) {
				Session.application.displayState = new ReplayState(this._gameLogic.gamemode, null, 0, 0);
			}
		}
	}
}