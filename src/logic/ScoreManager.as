package logic{
	//-------------------------------------------------------------------------
	// Imports
	//-------------------------------------------------------------------------
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	import ui.HUDSingleplayer;
	
	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Manager for the score system. Keeps track of the player(s) score.
	 */
	public class ScoreManager {
		//-------------------------------------------------------
		// Public getter and setter methods
		//-------------------------------------------------------
		/**
		 * Returns the player's score. 
		 * 
		 * @return 	int		Score
		 */
		public function get score():int{
			return _score;
		}
		
		/**
		 * Sets timer feedback for speed boost/reducer.
		 * @param 	boost	Wheter it's a boost or reducer.
		 */
		public function set speedTimerFeedback(boost:Boolean):void{
			this._HUD.speedFeedback = boost;
		}
		
		//-------------------------------------------------------
		// Private static embedded constants
		//-------------------------------------------------------
		/**
		 *	Sound effect for when player achives combo
		 * 
		 *	@default Class
		 */
		[Embed(source="../../asset/sound/combo.mp3")]
		private static var COMBO_SOUND:Class;
		
		/**
		 *	Sound effect for when player breaks combo
		 * 
		 *	@default Class
		 */
		[Embed(source="../../asset/sound/ohno.mp3")]
		private static var OHNO_SOUND:Class;
		
		//-------------------------------------------------------
		// Private properties
		//-------------------------------------------------------
		/**
		 * Reference to the HUD. 
		 */
		private var _HUD:HUDSingleplayer;
		
		/**
		 * Player's score. 
		 */
		private var _score:int = 0;	
		
		/**
		 * Points collected to reach combo.
		 */
		private var _comboPoints:uint = 0;
		
		/**
		 *  List with current high scores.
		 */
		private var _currentHighscores:Vector.<int> = new Vector.<int>;
		
		/**
		 * Sound played when combo is achieved.
		 */
		private var _comboSound:SoundObject;
		
		/**
		 * Sound played when combo breaks.
		 */
		private var _ohnoSound:SoundObject;
		
		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		public function ScoreManager(hud:*){
			this._HUD = hud;
			this.initSound();
			this.initHighscore();
		}
		
		//-------------------------------------------------------
		// Public methods
		//-------------------------------------------------------
		/**
		 * Updates score with time points.
		 * 
		 * @param 	points		Points to add to score
		 * @return 	void
		 */
		public function updateTimeScore(points:int):void{
			this._score += points;
			this._HUD.score = this._score;
			Session.highscore.checkScore(1, this._score, updateHighscore);
		}
		
		/**
		 * Updates combo meter.
		 * 
		 * @param combo
		 * 
		 */
		public function updateCombo(combo:Boolean):void{
			if(combo == false && _comboPoints >= 3){
				// Breaks previously achieved combo if a token hasn't been picked up
				_HUD.comboFeedback = false;	
				_ohnoSound.play();
				_ohnoSound.volume = 1;
			}
			
			if(combo) {
				// Combo achieved
				_comboPoints++;
				this.checkCombo();
			} else { 
				// Resets the combo meter if a token hasn't been picked up
				_comboPoints = 0;
				_HUD.comboMeter = 0;				
			}			
		}
			
		//-------------------------------------------------------
		// Private methods
		//-------------------------------------------------------
		/**
		 * Initializes sound effects
		 * 
		 * @return void
		 */
		private function initSound():void {
			Session.sound.soundChannel.sources.add("combo", COMBO_SOUND);
			_comboSound = Session.sound.soundChannel.get("combo", true, true);
			
			Session.sound.soundChannel.sources.add("ohno", OHNO_SOUND);
			_ohnoSound = Session.sound.soundChannel.get("ohno", true, true);
		}
		
		/**
		 * Retrieves highscores from database
		 * 
		 * @return void
		 */
		private function initHighscore():void {
			Session.highscore.receive(1, 10, setCurrentHighscores);
		}
		
		/**
		 * Checks if combo has been achieved and gives feedback
		 * accordingly. Updates combo meter and textual feedback.
		 * 
		 * @return 	void
		 */
		private function checkCombo():void{
			//Token taken, but not combo yet (e.g. +1p)
			if(_comboPoints < 3) {
				this.updateScore(false,1);
			}
			
			// Updates combobar until it is full
			if(_comboPoints <= 3) {
				_HUD.comboMeter = _comboPoints;
			}
			
			// Feedback when combo is achieved
			if(_comboPoints == 3) {
				_HUD.comboFeedback = true;
				_comboSound.play();
				_comboSound.volume = 0.8;
			}
			
			// Updates combo score when active
			if(_comboPoints >= 3 ) {
				this.updateScore(true,_comboPoints);
			}
		}
		
		/**
		 * Updates the player's score and sets textual feedback.
		 *  	
		 * @param 	combo		Wheter combo is acieved or not.
		 * @param	value		Value of combo.
		 * 
		 */
		public function updateScore(combo:Boolean, value:uint):void{
			if(!combo) {
				this._score++;
				this._HUD.score = this._score;
				this._HUD.scoreFeedback = "+1p";
			} else {
				this._score += value;
				this._HUD.score = this._score;
				this._HUD.scoreFeedback = "+" + (value+1).toString() + "p";
			}

			Session.highscore.checkScore(1, this._score, updateHighscore);
		}
		
		/**
		 * Compares current score to saved high score list, dsiplays
		 * next score to beat. If current score is great enough to 
		 * make it onto the list, display next high score to beat etc.
		 * 
		 * @param 	data	XML from API request.
		 * @return 	void
		 */
		private function updateHighscore(data:XML):void {
			if (data.header.success == false) {
				this._HUD.nextHighScorePos = 10;
				this._HUD.nextHighScore = _currentHighscores[9];
			} else if (data.header.success == true) {
				var playerPosition:int = data.header.position;
				if (playerPosition > 1) {
					this._HUD.nextHighScorePos = playerPosition - 1;
					this._HUD.nextHighScore = _currentHighscores[playerPosition-2];
				} else if (playerPosition == 1) {
					this._HUD.nextHighScorePos = playerPosition;
					this._HUD.nextHighScore = this._score;
				}
				
			}
		}
		
		/**
		 * Saves current highscores from the database in vector.
		 * 
		 * @param 	data	XML	from API request
		 * @return 	void
		 */
		private function setCurrentHighscores(data:XML):void {
			for(var i:int = 0; i < data.items.item.length(); i++) {
				_currentHighscores.push(data.items.item[i].score);
			}
		}
		
		/**
		 * Stops timer feedback for speed boost/reducer.
		 * 
		 * @return 	void
		 */
		public function stopTimerFeedback():void{
			this._HUD.stopSpeedTimer();
		}	
	}
}