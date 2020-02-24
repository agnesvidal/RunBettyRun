package logic {
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------
	import object.GameWorld;
	import object.Player;
	import object.SpeedBoost;
	import object.SpeedReduce;
	import object.Token;
	import object.track.LevelHandler;
	import object.track.Part;
	import object.track.PartContainer;
	import object.track.part.PartLeft;
	import object.track.part.PartRight;
	import object.track.part.PartStraight;
	
	import se.lnu.stickossdk.fx.Flicker;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;
	
	import state.ReplayState;
	
	import ui.HUD;

	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Handles the game logic. Mainly generating new parts and items 
	 * and managing Scores and Lives.
	 */
	public class GameLogic {
		//-------------------------------------------------------
		// Public getter and setter methods
		//-------------------------------------------------------
		/**
		 * Returns 	game mode. 0 = Singleplayer, 1 = Versus
		 */
		public function get gamemode():uint {
			return _gameMode;
		}
		
		/**
		 * Returns reference to ScoreManager in Singleplayer
		 */
		public function get scoreManager():ScoreManager{
			return _scoreManager;
		}
		
		/**
		 * Returns reference to LifeManager in Versus
		 */
		public function get lifeManager():LifeManager{
			return _lifeManager;
		} 
		
		/**
		 * Sets the time score multiplier.
		 * 
		 * @param 	value	1-3 (uint)
		 * 
		 */
		public function set multiplier(value:uint):void {
			_multiplier = value;
		}
		
		//-------------------------------------------------------
		// Private properties
		//-------------------------------------------------------	
		private var _gameMode:uint;	
		private var _updatePartsTimer:Timer;
		private var _timeScoreTimer:Timer;		
		private var _difficultyTimer:Timer;
		private var _difficulty:uint = 0;
		private var _scoreManager:ScoreManager;	
		private var _lifeManager:LifeManager;	
		private var _worlds: Vector.<GameWorld> = new Vector.<GameWorld>;
		private var _players: Vector.<Player> = new Vector.<Player>;
		private var _multiplier:uint = 1;
		private var _winner:int;		
		
		// --------------------------------------
		// @TODO TrackManager
		public var _parts1: Vector.<Class> = new Vector.<Class>;
		public var _parts2: Vector.<Class> = new Vector.<Class>;
		public var _parts1items:Vector.<Object> = new Vector.<Object>;
		public var _parts2items:Vector.<Object> = new Vector.<Object>;
		private var _levelHandler:LevelHandler;
		private var _lastPartClass:Class = PartStraight; 	// Default = last part placed in the default take off.		
		private var _trackDirection:uint = 0; 				// Default = last track direction in the default take off.	
		private var _lastTurns:Array = [];
		private var _tempPart:PartContainer;		
		// --------------------------------------
		
		//-------------------------------------------------------	
		// Constructor method
		//-------------------------------------------------------	
		public function GameLogic(gamemode:uint, hud:HUD){
			_gameMode = gamemode;
			if(_gameMode == 0) {
				_scoreManager = new ScoreManager(hud);
			}else {
				_lifeManager = new LifeManager(hud, killPlayer);
			}
			this.init(hud);
		}
		
		//-------------------------------------------------------	
		// Public methods
		//-------------------------------------------------------	
		/**
		 * Kills a player and  initiates eventual game over.
		 * 
		 * @param 	player		Player ID (0 or 1)
		 * @param 	gameover	True/false 
		 */
		public function killPlayer(player:uint, gameover:Boolean):void{
			if(gameover == false) {
				if(player == 0) {
					Session.effects.add(new Flicker(_players[0], 500));
				} else {
					Session.effects.add(new Flicker(_players[1], 500));
				}
			} else{				
				_updatePartsTimer.stop();
				_difficultyTimer.stop();
				this.checkLives();
				Session.timer.create(1500, endGameVersus);
			}
			
		}	
		
		/**
		 * Checks number of lives of both players. Decides wheter who wins,
		 * or if it is a draw.
		 * 
		 * @return	void
		 */
		public function checkLives():void {
			var p0Lives:int = _lifeManager.getLives(0);
			var p1Lives:int = _lifeManager.getLives(1);
			if (p0Lives == 0 && p1Lives == 0) {
				_winner = 3;
			} else if(p0Lives == 0 && p1Lives > 0) {
				_lifeManager.setWinner(1);
				_winner = 1;
			} else if (p1Lives == 0 && p0Lives > 0) {
				_lifeManager.setWinner(0);
				_winner = 0;
			}	
		}
		
		/**
		 * Calls ReplayState to show end game result (winner/loser/draw).
		 * 
		 * @return	void
		 */
		public function endGameVersus():void{
			if(_winner == 3) {
				Session.application.displayState = new ReplayState(1, null, 0, 3);
			} else if (_winner == 1) {
				Session.application.displayState = new ReplayState(1, null, 0, 1);
			} else if (_winner == 0) {
				Session.application.displayState = new ReplayState(1, null, 0, 0);
			}
		}
		
		/**
		 *  Stops timers.
		 */
		public function stopTimers():void{
			_timeScoreTimer.stop();
			_updatePartsTimer.stop();
			_difficultyTimer.stop();
		}
				 
		/**
		 * Stops a player and its game world.
		 * 
		 * @param 	player	Player ID (0 or 1)
		 */
		public function stopPlayer(player:uint):void {			
			if(player == 0) {
				_worlds[0].stopSpeedtimers();
				_players[0].trailFrame = "idle";
				_worlds[0].speed = 0;
			} else {
				_worlds[1].stopSpeedtimers();
				_players[1].trailFrame = "idle";
				_worlds[1].speed = 0;
			}
		}

		/**
		 * Adds reference to a GameWorld.
		 *  
		 * @param 	observer	Player
		 */
		public function subscribeObserver(observer:GameWorld):void{
			_worlds.push(observer);
		}
		
		/**
		 * Adds reference to a Player.
		 *  
		 * @param 	observer	Player
		 */
		public function subscribePlayer(observer:Player):void{
			_players.push(observer);
		}
		
		/**
		 * Removes the first index (part and item) from a player 
		 * specific registry.
		 * 
		 * @param 	player		Player ID (0 or 1)
		 */
		public function removeFirst(player:uint):void {	
			if(player == 0) {
				_parts1.shift();
				_parts1items.shift();
			} else {
				_parts2.shift();
				_parts2items.shift();
			}
		}
		
		//-------------------------------------------------------	
		// Private methods
		//-------------------------------------------------------	
		/**
		 * Initiates
		 * 
		 * @param 	hud		Reference to HUD
		 */
		private function init(hud:HUD):void{
			_levelHandler = new LevelHandler();
			this.initTimers();	
			_lastTurns.push(2,1);

			_parts1.push(PartStraight);
			_parts2.push(PartStraight);
			_parts1items.push({});
			_parts2items.push({});
		}
		
		/**
		 * Instantiates timers. 
		 * 
		 */
		private function initTimers():void {
			_updatePartsTimer = Session.timer.create(200, generateRandomPart, 0, false);
			_updatePartsTimer.start();
			
			_difficultyTimer = Session.timer.create(60000, changeDifficulty, 0, false);
			_difficultyTimer.start();
			
			if(_gameMode == 0) {
				_timeScoreTimer = Session.timer.create(1000, updateTimeScore, 0, false);
				_timeScoreTimer.start(); 
			}
		}
		
		/**
		 * Raises the difficulty.
		 * 
		 */
		private function changeDifficulty():void {
			_difficulty = 1; 
		}
		
		/**
		 * Updates time based score. 
		 * 
		 */
		private function updateTimeScore():void {
			_scoreManager.updateTimeScore(1 * _multiplier);
			_timeScoreTimer.restart();
		}		
		
		//-------------------------------------------------------	
		// @TODO TrackManager
		//-------------------------------------------------------	
		/**
		 * Generates new random part depending on game mode. 
		 * 
		 * @return 	void
		 */
		public function generateRandomPart():void {	
			if(_gameMode == 0) {				
				if(_parts1.length < 20) {
					generate();
				}
				_updatePartsTimer.restart();
			} else {				
				if(_parts1.length < 20 || _parts2.length < 20) {
					generate();
				}
				_updatePartsTimer.restart();
			}
		}
		
		/**
		 *  Generates part.
		 * 
		 * 	@return 	void
		 */
		public function generate():void {	
			var randomPart:Class;	
				while (true) {
					randomPart = _levelHandler.getDifficultyParts(_difficulty);
					_tempPart = new PartContainer(randomPart);
					if (this.checkNewRandom(_tempPart.part)){
						if (this.checkGrid(_tempPart.part)) {
							_lastPartClass = randomPart;
							
							if(_tempPart.part.type == _lastTurns[1]) {
								pushPart(PartStraight, _tempPart);
							}
							
							pushPart(randomPart, _tempPart);
							setDirection(_tempPart.part);
							
							if ((_tempPart.part.type == 1) || (_tempPart.part.type == 2)) {		
								_lastTurns.push(_tempPart.part.type);
								if (_lastTurns.length > 2) {
									_lastTurns.shift();
								}			
							}
							_tempPart = null;
							break;
						}
					}
				}
		}
		
		/**
		 * Pushes new parts and items into player specific registers.
		 * 
		 * @param 	part			
		 * @param 	tempPart		
		 */
		private function pushPart(part:Class, tempPart:PartContainer):void {
			_parts1.push(part);
			var item:Object = this.generateItem(tempPart.part);
			_parts1items.push(item);
			
			if(_gameMode == 1) {
				_parts2.push(part);
				_parts2items.push(item);
			}

			item = null;
		}
		
		/**
		 * Generates a new item.
		 * 
		 * @param 	part		...
		 * @return 	Object		New item
		 */
		private function generateItem(part:Part):Object {
			var chance:int = Math.random() * 100;
			var r:int = Math.floor(Math.random() * 3);
			var c:int = Math.floor(Math.random() * 3);
			var t:Class;
			
			if(chance < 10){ 		// 10%
				t = SpeedReduce;
			} else if(chance < 20){ // 10%
				t = SpeedBoost;
			}else if(chance < 70){ 	// 50%
				t = Token;
			} else { 				// 30%
				return {};
			}			
			
			if(part.grid.cellChildren(r,c) == 0) {
				return {t: t, r: r, c: c};
			}
			
			return {};
		}
		
		/**
		 * Checks if new part fits with last turn.
		 * 
		 * @param 	newPart		Part
		 * @return 	Boolean
		 */	
		public function checkNewRandom(newPart:Part):Boolean {
			var fit:Boolean;
			if (_trackDirection == 0 || _trackDirection == 3) { 
				// Prevents three turns in the same direction to be placed in a row
				if(newPart is PartLeft && _lastTurns[0] == 1 && _lastTurns[1] == 1) {
					fit = false;
				} else if (newPart is PartRight && _lastTurns[0] == 2 && _lastTurns[1] == 2) {
					fit = false;
				} else {
					fit = true;
				}
			} else { 
				// Control that prevents the track to build downwards
				if(newPart is PartRight && _lastTurns[1] == 2) {
					fit = false;
				} else if (newPart is PartLeft && _lastTurns[1] == 1) {
					fit = false;
				} else {
					fit = true;
				}
			}
			return fit;
		}
		
		/** 
		 * Controls if the new part fits on the track based on both
		 * its own grid and the last parts grid. If neither the new 
		 * part has any obstacles on the middle row or the last part 
		 * it fits.
		 * 
		 * @param 	part	Part to check
		 * @return 	Boolean
		 */
		public function checkGrid(part:Part):Boolean {
			var middleRow:Boolean = true;			
			if(checkNewGrid(part)) {
				middleRow = true;
			} else {
				if(checkNewGrid(_lastPartClass)) {
					middleRow = true;
				} else {
					middleRow = false;
				}
			}	
			return middleRow;
		}
		
		/**
		 * Controls if a part has an obstalce on the first or last row.
		 * (middlePar = TRUE if the part only has obstacles on the middle row.
		 * middlePart = FALSE if the part has obstacles on either the 
		 * first or last row)
		 * 
		 * @param 	part 	Part to check
		 * @return 	Boolean
		 */
		public function checkNewGrid(part:*):Boolean {
			var middlePart:Boolean = true;
			var tempPart:Part;
			
			if(part is Class) {
				tempPart = new _lastPartClass;
			} else {
				tempPart = part;
			}
			
			for (var i:int = 0; i<tempPart.grid.numCells; i++) {
				for (var j:int = 0; j<3; j++) {
					if(tempPart.grid.cellChildren(0,j) > 0) {
					// Obstacle on row 0
						middlePart = false;
					}
					if(tempPart.grid.cellChildren(2,j) > 0) {
					// Obstacle on row 2 
						middlePart = false;
					}
				}
			}
			return middlePart;
		}
		
		/**
		 * Sets a new track direction.
		 *
		 * @param	p		Part
		 * @return	void
		 */
		public function setDirection(p:Part):void {
			switch(_trackDirection) {
				case 0: 
					_trackDirection = p.direction[0]; 
					break;
				case 1: 
					_trackDirection = p.direction[2];
					break;
				case 2: 
					_trackDirection = p.direction[3];
					break;
				case 3: 
					_trackDirection = p.direction[1];
					break;
			}
		}
	}
}