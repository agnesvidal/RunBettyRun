package ui{
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.tween.easing.Sine;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.text.TextFormat;
	import asset.TimerGFX;
	import asset.TokenSymbolGFX;
	import asset.TrophyGFX;
	
	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Represents the HUD in Singleplayer mode and manages visual feedback to
	 * the player.
	 */
	public class HUDSingleplayer extends HUD {
		//-------------------------------------------------------
		// Public getter and setter methods
		//-------------------------------------------------------
		/**
		 * Updates the score counter with a new score. 
		 * 
		 * @param 	value	Score
		 */
		public function set score(value:int):void{
			_scoreCounter.setScore(value);
		}
		
		/**
		 * Sets a feedback message to the player regarding 
		 * points gathered.
		 * 
		 * @param 	msg		Message to display (e.g. "+1p")
		 */
		public function set scoreFeedback(msg:String):void{	
			this._scoreFeedback.text = msg;
			this.scoreUpdate();
		}
		
		/**
		 * Updates next high score. (Next high score is the one 
		 * closest to the player's score.)
		 * 
		 * @param 	value	Position
		 */
		public function set nextHighScore(value:int):void {
			 _highscore.setScore(value);
		}
		
		/**
		 * Updates next high score position. (Next high score is 
		 * the one closest to the player's score.)
		 * 
		 * @param 	value	High Score
		 */
		public function set nextHighScorePos(value:int):void{
			_highScorePos.text = value.toString() + ":";
		}				
		
		/**
		 * Displays a timer and a message to the player when 
		 * he/she has taken a speed boost or speedreducer.
		 * 
		 * @param 	boost	Wheter boost is active or not.
		 */
		public function set speedFeedback(boost:Boolean):void{	
			this.speedUpdate();			
			if(boost) {
				this._speedFeedback.text = "2x time points";
				_speedTimer.gotoAndStop(2);
			} else {
				this._speedFeedback.text = "0x time points";
				_speedTimer.gotoAndStop(1);
			}
		}	
		
		/**
		 * Updates the combo meter when the player picks up 
		 * tokens, runs over speed reducers OR breaks a combo.
		 *  
		 * @param 	value	A value between 0-3. (
		 * 					0 = resets meter. 
		 * 					3 = meter is full )
		 */
		public function set comboMeter(value:uint):void {
			var v:uint = 3 - value;
			_combobar.scaleX = v/3;	
			_combobar.x = 144 + (200 - 200 *_combobar.scaleX);
		}
		
		/**
		 * Gives the player visual feedback when a combo has
		 * been achieved or broken. 
		 * 
		 * @param 	achieved	Wheter combo has been achieved.
		 */
		public function set comboFeedback(achieved:Boolean):void{
			if(achieved) {
				this._comboFeedback.text = "Combo!";
				this.comboUpdate();
			} else {
				this._comboFeedback.text = "Combo broken";
				this.comboUpdate();
			}
		}
		
		//-------------------------------------------------------
		// Private properties
		//-------------------------------------------------------
		private var _scoreCounter:Counter;
		private var _highscore:Counter
		private var _highScorePos:Text;
		private var _scoreFeedback:Text;
		private var _combobar:Shape;
		private var _comboMeterField:Text;
		private var _comboFeedback:Text;
		private var _speedFeedback:Text;
		private var _speedTimer:MovieClip;

		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		public function HUDSingleplayer(){
			super(370);
		}

		//-------------------------------------------------------
		// Protected method
		//-------------------------------------------------------	
		/**
		 * Initiates the HUD. 
		 * 
		 * @return 	void
		 */
		override public function initHUD():void {
			initSingleplayerContainer();
			initScoreCounter();
			initHighscore();
			initFeedbackFields();
			initSpeedTimerGraphic();
		}
		
		/**
		 * Stops the visual representation of a timer. 
		 * 
		 * @return 	void
		 */
		public function stopSpeedTimer():void{	
			_speedTimer.gotoAndStop(3);
		}
		
		//-------------------------------------------------------
		// Private methods
		//-------------------------------------------------------	
		/**
		 * Creates the basic graphic elements of the top container:
		 * combo meter and avatar. 
		 * 
		 * @return 	void
		 */
		private function initSingleplayerContainer():void {
			topContainer.addChild(initAvatarFrame(0x3CC6E8, 50, 25));
			topContainer.addChild(initMeter(140));
			topContainer.addChild(initAvatar(0, 46, 22));
			
			_combobar = new Shape();
			initBar(_combobar, 144);
			topContainer.addChild(_combobar);
			topContainer.addChild(initMeterFrame(0x3CC6E8, 120, 25));
			
			var comboSymbol:MovieClip = new TokenSymbolGFX();
			topContainer.addChild(comboSymbol);
			comboSymbol.scaleX = 1.9;
			comboSymbol.scaleY = 1.9;
			comboSymbol.x = 99;
			comboSymbol.y = 4.5;			
		}
		
		/**
		 * Creates a counter for the player's score. 
		 * 
		 * @return 	void
		 */
		private function initScoreCounter():void {
			_scoreCounter = new Counter(5, "ARCO", 22, 18, true);
			_scoreCounter.x = 650;
			_scoreCounter.y = 50;
			this.addChild(_scoreCounter);

			var p:Text = new Text(698,55,100);
			p.embedFonts = true;
			p.defaultTextFormat = h2;
			p.text = "p";
			p.filters = filterArray;
			this.addChild(p);
		}
		
		/**
		 * Creates a counter for the next high score.
		 * 
		 * @return 	void
		 */
		private function initHighscore():void {
			_highscore = new Counter(5, "Roboto", 18, 10, false);
			this.addChild(_highscore);
			_highscore.x = 700;
			_highscore.y = 80;
			
			var format:TextFormat = new TextFormat("Roboto", 18, 0xFFFFFF);
			_highScorePos = new Text(663,80,50,100);
			_highScorePos.embedFonts = true; 
			_highScorePos.defaultTextFormat = format;
			this.addChild(_highScorePos);
			this.nextHighScorePos = 10; 
			
			var trophy:MovieClip = new TrophyGFX();
			this.addChild(trophy);
			trophy.scaleX = 0.32;
			trophy.scaleY = 0.32;	
			trophy.x = 650;
			trophy.y = 86.5;	
			trophy.cacheAsBitmap = true;
		}
		
		/**
		 * Creates text fields for feedback.
		 * 
		 * @return 	void
		 */
		private function initFeedbackFields():void {
			_comboMeterField = new Text(155,15,180);
			_comboMeterField.embedFonts = true; 
			_comboMeterField.defaultTextFormat = h2;
			topContainer.addChild(_comboMeterField);
			_comboMeterField.text = "combo meter";
			_comboMeterField.filters = filterArray;
				
			_comboFeedback = new Text(190,370,120,100);
			_comboFeedback.wordWrap = true;
			_comboFeedback.rotation = -10;
			_comboFeedback.embedFonts = true; 
			_comboFeedback.defaultTextFormat = h1;
			_comboFeedback.filters = filterArray;
			topContainer.addChild(_comboFeedback);
			
			_scoreFeedback = new Text(260,390,80);
			_scoreFeedback.rotation = -10;
			_scoreFeedback.embedFonts = true; 
			_scoreFeedback.defaultTextFormat = h1;
			_scoreFeedback.filters = filterArray;
			topContainer.addChild(_scoreFeedback);
		}
		
		/**
		 * Creates a graphic represenation of a timer 
		 * and a textfield for additional feedback.
		 * 
		 * @return 	void 
		 */
		private function initSpeedTimerGraphic():void {
			_speedTimer = new TimerGFX();
			_speedTimer.gotoAndStop(3);
			_speedTimer.x = 345;
			_speedTimer.y = 480;
			_speedTimer.scaleX = 1.5;
			_speedTimer.scaleY = 1.5;	
			this.addChild(_speedTimer);
			
			_speedFeedback = new Text(445,440,130,100);
			_speedFeedback.wordWrap = true;
			_speedFeedback.rotation = 10;
			_speedFeedback.embedFonts = true; 
			_speedFeedback.defaultTextFormat = h1;
			_speedFeedback.filters = filterArray;
			this.addChild(_speedFeedback);
		}
		
		/**
		 * Tween to display combo feedback.
		 * 
		 * @return	void
		 */
		private function comboUpdate():void{
			Session.tweener.add(this._comboFeedback, {
				alpha: 0.1,
				scaleX: 0.8,
				scaleY: 0.8,
				x: 195,
				duration: 1000,
				transition: Sine.easeOut,
				onComplete: comboComplete
			});
			_comboFeedback.alpha = 0;
		}
		
		/**
		 * Tween to display speed feedback.
		 * 
		 * @return	void
		 */
		private function speedUpdate():void{
			Session.tweener.add(this._speedFeedback, {
				alpha: 0.1,
				scaleX: 0.8,
				scaleY: 0.8,
				x: 460,
				duration: 1000,
				transition: Sine.easeOut,
				onComplete: speedComplete
			});
		}
		
		/**
		 * Tween to display score feedback.
		 * 
		 * @return	void
		 */
		private function scoreUpdate():void{
			_scoreFeedback.alpha = 1;
			_scoreFeedback.y = 390;
			_scoreFeedback.x = 260;
			Session.tweener.add(_scoreFeedback, {
				alpha: 0.1,
				scaleX: 0.8,
				scaleY: 0.8,
				x: 265,
				duration: 1000,
				transition: Sine.easeOut,
				onComplete: scoreComplete
			});
		}
		
		/**
		 * Tween to remove combo feedback.
		 * 
		 * @return	void
		 */
		private function comboComplete():void{
			Session.tweener.add(this._comboFeedback, {
				scaleX: 1,
				scaleY: 1,	
				y: 360,
				duration: 500,
				transition: Sine.easeOut
			});	
			this._comboFeedback.text = "";
			this._comboFeedback.y = 370;
			this._comboFeedback.x = 190;
			this._comboFeedback.alpha = 1;
		}
		
		/**
		 * Tween to remove speed feedback.
		 * 
		 * @return	void
		 */
		private function speedComplete():void{
			Session.tweener.add(this._speedFeedback, {
				scaleX: 1,
				scaleY: 1,	
				y: 450,
				duration: 500,
				transition: Sine.easeOut
			});	
			this._speedFeedback.text = "";
			this._speedFeedback.y = 460;
			this._speedFeedback.x = 445;
			this._speedFeedback.alpha = 1;
		}
		
		/**
		 * Tween to score speed feedback.
		 * 
		 * @return	void
		 */
		private function scoreComplete():void{
			Session.tweener.add(_scoreFeedback, {
				scaleX: 1,
				scaleY: 1,
				y: 390,
				x: 260,
				duration: 500,
				transition: Sine.easeOut
			});	
			this._scoreFeedback.text = "";
		}	
	}
}