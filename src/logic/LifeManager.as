package logic{
	//-------------------------------------------------------------------------
	// Imports
	//-------------------------------------------------------------------------
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	import ui.HUDVersus;

	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Manager for the life system. Keeps track of the players' lives.
	 */
	public class LifeManager {
		//-------------------------------------------------------
		// Private static embedded constants
		//-------------------------------------------------------
		/**
		 *	Sound effect for when player breaks combo
		 * 
		 *	@default Class
		 */
		[Embed(source="../../asset/sound/ohno.mp3")]
		private static var OHNO_SOUND:Class;
		
		//----------------------------------------------------------------------
		// Private static constants
		//----------------------------------------------------------------------
		/**
		 * Number of points to gather until extra life.
		 */ 
		private static const UNTIL_EXTRA_LIFE:uint = 16;
		
		/** 
		 * Half-filled meter
		 */
		private static const REDUCED_LIFE_METER:uint = UNTIL_EXTRA_LIFE/2;		
		
		/**
		 * Maximum number of lives
		 */
		private static const MAX_LIVES:uint = 6;
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		private var _HUD:HUDVersus;							// Reference to HUD.
		private var _p0points:Number = UNTIL_EXTRA_LIFE; 	// Player 1: Points left to gather until next life
		private var _p1points:Number = UNTIL_EXTRA_LIFE;	// Player 2: Points left to gather until next life
		private var _p0lives:uint = 3;						// Player 1: Number of lives
		private var _p1lives:uint = 3;						// Player 2: Number of lives
		private var _killPlayerCallback:Function;			// Callback function.
		private var _ohnoSound:SoundObject;					// Sound played when life is stolen.

		//----------------------------------------------------------------------
		// Constructor method
		//----------------------------------------------------------------------
		public function LifeManager(hud:*, callback:Function){
			_HUD = hud;
			_killPlayerCallback = callback;
			this.initSound();
		}
		
		//----------------------------------------------------------------------
		// Public methods
		//----------------------------------------------------------------------
		/**
		 * Returns a player's lives. 
		 * 
		 * @param 	player 		Player ID (0 or 1)
		 * @return 	uint		Number of lives
		 * 
		 */
		public function getLives(player:uint):uint{
			if(player == 0) {
				return _p0lives;
			} else {
				return _p1lives;
			}			
		}
		
		/**
		 * Removes one life from a player and resets the life meter.
		 * 
		 * @param 	player		Player ID (0 or 1)
		 * @return 	void
		 */
		public function removeLife(player:uint):void{
			if(player == 0) {
				_p0lives--;
				_HUD.p0Lives = _p0lives;
				_p0points = UNTIL_EXTRA_LIFE;
				_HUD.p0Points = _p0points;	
			} else {
				 _p1lives--;
				 _HUD.p1Lives = _p1lives;
				 _p1points = UNTIL_EXTRA_LIFE;
				 _HUD.p1Points = _p1points;
			}	
		}
		
		/**
		 * Updates a player's life points.
		 *  
		 * @param 	player		Player ID (0 or 1)
		 * @return 	void
		 */
		public function updateLifeScore(player:uint):void{	
			if (player == 0) {
				if(_p0lives < MAX_LIVES) {
					if(_p0points <= UNTIL_EXTRA_LIFE && _p0points > 1) {
						_p0points--;
						_HUD.p0Points = _p0points;
					} else {
						this.updateLives(player);
					}
				}
			} else {
				if(_p1lives < MAX_LIVES) {
					if(_p1points <= UNTIL_EXTRA_LIFE && _p1points > 1) {
						_p1points--;
						_HUD.p1Points = _p1points;
					} else {
						this.updateLives(player);
					}
				}
			}
		}
		
		/**
		 * Sets timer feedback for speed boost/reducer.
		 * 
		 * @param	player		Player ID (1 or 2)
		 * @param 	boost		Wheter it's a boost or reducer.
		 */
		public function speedTimerFeedback(player:uint, boost:Boolean):void{
			_HUD.speedFeedback(player, boost);
		}
				
		/**
		 * Reduces gathered life points by a fourth (1/4). 
		 * 
		 * @param 	player		Player ID (0 or 1)	
		 * @return 	void
		 */
		public function reduceLifePoints(player:uint):void {	
			if(player == 0) {
				if(_p0points >= UNTIL_EXTRA_LIFE/4 && _p0points <= 12) {
					_HUD.p0Points = _p0points + UNTIL_EXTRA_LIFE/4;
					_p0points = _p0points + UNTIL_EXTRA_LIFE/4;
				} else {
					_HUD.p0Points = UNTIL_EXTRA_LIFE;
					_p0points = UNTIL_EXTRA_LIFE;		
				}
			} else {
				if(_p1points >= UNTIL_EXTRA_LIFE/4 && _p0points <= 12) {
					_HUD.p1Points = _p1points + UNTIL_EXTRA_LIFE/4;
					_p1points = _p1points + UNTIL_EXTRA_LIFE/4;
				} else {
					_HUD.p1Points = UNTIL_EXTRA_LIFE;
					_p1points = UNTIL_EXTRA_LIFE;		
				}
			}
		}
		
		/**
		 * Stops timer feedback for speed boost/reducer.
		 * 
		 * @param	player		Player ID (0 or 1)
		 * @return 	void
		 */
		public function stopTimerFeedback(player:uint):void{
			_HUD.stopSpeedTimer(player);
		}
		
		public function setWinner(player:uint):void{
			_HUD.winner = player;
		}
		
		//-------------------------------------------------------
		// Private methods
		//-------------------------------------------------------	
		/**
		 * Initializes sound effect for when player loses a life
		 * 
		 */
		private function initSound():void {
			Session.sound.soundChannel.sources.add("ohno", OHNO_SOUND);
			_ohnoSound = Session.sound.soundChannel.get("ohno", true, true);
		}
		
		/**
		 * Updates player's lives.
		 *  
		 * @param 	player		Player ID (0 or 1)
		 * @return 	void
		 */
		private function updateLives(player:uint):void{
			if (player == 0) {
					_p0lives++;
					_HUD.p0Lives = _p0lives;
					
					_p0points = UNTIL_EXTRA_LIFE;
					_HUD.p0Points = _p0points;
					
					Session.timer.create(100, function():void {
						checkOpponentLives(0);
					});
					
					if(_p0lives == MAX_LIVES) {
						_p0points = 0;
						_HUD.p0Points = 0;
					}			

			} else {
					_p1lives++;
					_HUD.p1Lives = _p1lives;
					
					_p1points = UNTIL_EXTRA_LIFE;
					_HUD.p1Points = _p1points;
					
					Session.timer.create(100, function():void {
						checkOpponentLives(1);
					});
					
					if(_p1lives == MAX_LIVES) {
						_p1points = 0;
						_HUD.p1Points = 0;
					}	
			}
		}
		
		/**
		 * Checks opponents lives and steals a life if the opponent
		 * has at least 1 life.
		 *  
		 * @param 	player		Player ID (0 or 1)
		 */
		private function checkOpponentLives(player:uint):void{
			if(player == 0) {
				if(_p1lives > 0) {
					_p1lives--; 
					_HUD.p1Lives = _p1lives;
					if(_p1points <= REDUCED_LIFE_METER) {
						_HUD.p1Points = _p1points + REDUCED_LIFE_METER;
						_p1points += REDUCED_LIFE_METER;				
					} else {
						_p1points = UNTIL_EXTRA_LIFE;
						_HUD.p1Points = UNTIL_EXTRA_LIFE;
					}
					stealLife(1);
				}
			} else {
				if(_p0lives > 0) {	
					_p0lives--; 
					_HUD.p0Lives = _p0lives;	
					if(_p0points <= REDUCED_LIFE_METER) {
						_HUD.p0Points = _p0points + REDUCED_LIFE_METER;
						_p0points += REDUCED_LIFE_METER;
					} else {
						_p0points = UNTIL_EXTRA_LIFE;
						_HUD.p0Points = UNTIL_EXTRA_LIFE;
					}
					stealLife(0);
				}
			}
		}
		
		/**
		 * Steals a life and checks wheter it is game over or
		 * not. Calls callback to give feedback and handle
		 * eventual game over.
		 * 
		 * @param 	player		Player ID (0 or 1)
		 */
		private function stealLife(player:uint):void{
			_HUD.stealLifeFrom(player);
			_ohnoSound.play();
			
			if(player == 0) {
				if(_p0lives == 0) {
					_killPlayerCallback(player,true);
				} else {
					_killPlayerCallback(player,false);
				}
			} else {
				if(_p1lives == 0) {
					_killPlayerCallback(player,true);
				} else {
					_killPlayerCallback(player, false);
				}
			}
		}
	}
}