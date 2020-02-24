package ui{
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------
	import se.lnu.stickossdk.fx.Flicker;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.tween.easing.Sine;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import asset.LifeGFX;
	import asset.TimerGFX;

	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Represents the HUD in Versus mode and manages visual feedback to
	 * the player.
	 */
	public class HUDVersus extends HUD {
		//-------------------------------------------------------
		// Public getter and setter methods
		//-------------------------------------------------------
		/**
		 * Updates the life meter for Player 1.
		 *  
		 * @param 	value	A value between 0-16. (
		 * 					0 = resets meter. 
		 * 					16 = meter is full )
		 */
		public function set p0Points(value:uint):void{
			_p0lifebar.scaleX = value/MAX_POINTS;
			_p0lifebar.x = 144 + (200 - 200 *_p0lifebar.scaleX);
		}
		
		/**
		 * Updates the life meter for Player 2.
		 *  
		 * @param 	value	A value between 0-16. (
		 * 					0 = resets meter. 
		 * 					16 = meter is full )
		 */
		public function set p1Points(value:uint):void{
			_p1lifebar.scaleX = value/MAX_POINTS;
		}
		
		/**
		 * Displays visual feedback (winner/loser) on  game over.
		 * 
		 * @param 	winner		The player who won (uint)
		 */
		public function set winner(winner:uint):void{
			trace(winner);
			if(winner == 0) {
				_p0gameoverField.text = "Winner";
				_p1gameoverField.text = "Loser";
				gameover();
			} else {
				_p0gameoverField.text = "Loser";
				_p1gameoverField.text = "Winner";
				gameover();
			}
		}	
		
		/**
		 * Updates Player 1's number of lives in the HUD. 
		 * Displays "MAX" if the player has reached the 
		 * maximum number of lives. 
		 * 
		 * @param 	value		Number of lives
		 */
		public function set p0Lives(value:Number):void{
			_p0livesField.text = value.toString();
			if (value == MAX_LIVES) {
				_p0meterField.text = "MAX";
			} else {
				_p0meterField.text = "";
			}
		}
		
		/**
		 * Updates Player 2's number of lives in the HUD. 
		 * Displays "MAX" if the player has reached the 
		 * maximum number of lives. 
		 * 
		 * @param 	value		Number of lives
		 */
		public function set p1Lives(value:Number):void{
			_p1livesField.text = value.toString();
			if (value == MAX_LIVES) {
				_p1meterField.text = "MAX";
			} else {
				_p1meterField.text = "";
			}	
		}
		//-------------------------------------------------------
		// Private static constants
		//-------------------------------------------------------
		/**
		 * Maximum number of points for the life meter. 
		 * @default 16
		 */
		private static const MAX_POINTS:uint = 16;
		
		/**
		 * Maximum number of lives. 
		 * @default 6
		 */
		private static const MAX_LIVES:uint = 6;
		
		//-------------------------------------------------------
		// Private properties
		//-------------------------------------------------------
		private var _p0meterField:TextField;		// Textfield for when maximum lives has been reached. 
		private var _p1meterField:TextField;		// Textfield for when maximum lives has been reached. 
		
		private var _p0livesField:TextField;		// Textfield displaying number of lives.
		private var _p1livesField:TextField;		// Textfield displaying number of lives.
		
		private var _p0gameoverField:TextField;		// Textfield displaying winner/loser.
		private var _p1gameoverField:TextField;		// Textfield displaying winner/loser.
		
		private var _p0lifebar:Shape;				// Reference to Player 1's life meter.
		private var _p1lifebar:Shape;				// Reference to Player 1's life meter.
		
		private var _p0lifeFeedback:Sprite;			// Reference to Player 1's heart in the top container
		private var _p1lifeFeedback:Sprite;			// Reference to Player 2's heart in the top container
		
		private var _p0speedTimer:MovieClip;		// Reference to Player 1's speed timer.
		private var _p1speedTimer:MovieClip;		// Reference to Player 2's speed timer.
		
		private var _p0heartContainer:Sprite;		// Reference to Player 1's movable heart (when stolen).
		private var _p1heartContainer:Sprite;		// Reference to Player 2's movable heart (when stolen).

		//-------------------------------------------------------
		// Constructor
		//-------------------------------------------------------
		public function HUDVersus(){
			super(800);
		}
		
		//-------------------------------------------------------
		// Public methods
		//-------------------------------------------------------
		/**
		 * Initiates the HUD. 
		 * 
		 * @return 	void
		 */
		override public function initHUD():void {
			initP0Container();
			initP1Container();
			initFeedbackFields();
			initDivider();
		}
		
		/**
		 * Starts the visual representation of the speed timers: 
		 * speed boost and speed reduction.
		 * 
		 * @param 	player		Player ID (0 or 1)
		 * @param 	boost		Wheter it's a boost or reduction.
		 * 						(Boost = true, reduction = false)	
		 * 
		 */
		public function speedFeedback(player:uint, boost:Boolean):void{
			if(player == 0) {
				if(boost) {
					_p0speedTimer.gotoAndStop(2);
				} else {
					_p0speedTimer.gotoAndStop(1);
				}
			}else {
				if(boost) {
					_p1speedTimer.gotoAndStop(2);
				} else {
					_p1speedTimer.gotoAndStop(1);
				}
			}
		}
		
		/**
		 * Stops speed timer.
		 * 
		 * @param 	player			Player ID (0 or 1)
		 */
		public function stopSpeedTimer(player:uint):void{
			if(player == 0) {
				_p0speedTimer.gotoAndStop(3);
			}else {
				_p1speedTimer.gotoAndStop(3);
			}
		}
		
		/**
		 * Shows animation for stealing a life.
		 * 
		 * @param 	robbedPlayer	Player losing a life (0 or 1)
		 */
		public function stealLifeFrom(robbedPlayer:uint):void {
			if(robbedPlayer == 0){
				Session.effects.add(new Flicker(_p0heartContainer, 500));
				stealLife(_p0lifeFeedback, 590, p0lifeComplete)
			} else {
				Session.effects.add(new Flicker(_p1heartContainer, 500));
				stealLife(_p1lifeFeedback, 190, p1lifeComplete)
			}
		}
		//-------------------------------------------------------
		// Private methods
		//-------------------------------------------------------
		/**
		 * Creates a divider between the two players.
		 * 
		 * @return 	void
		 */
		private function initDivider():void {
			var divider:Shape = new Shape();
			divider.graphics.beginFill(0x000000, 0);
			divider.graphics.lineStyle(4, 0xFFFFFF);
			divider.graphics.moveTo(400,0);
			divider.graphics.lineTo(400,600);
			divider.graphics.endFill();
			this.addChild(divider);
		}
		
		/**
		 * Creates Player 1's container holding the player's stats.  
		 * 
		 * @return 	void
		 */
		private function initP0Container():void {
			//@TODO Divide into methods
			var p0Container:Sprite = new Sprite();
			p0Container.graphics.beginFill(0x3CC6E8, 1);
			p0Container.graphics.drawRect(0, 0, 398, 50);
			p0Container.graphics.endFill();
			topContainer.addChild(p0Container);

			p0Container.addChild(initMeter(140));
			_p0lifebar = new Shape();
			initBar(_p0lifebar, 144);
			p0Container.addChild(_p0lifebar);
			
			p0Container.addChild(initAvatarFrame(0x3CC6E8, 50, 25));
			p0Container.addChild(initAvatar(0, 46, 22));
			p0Container.addChild(initMeterFrame(0x3CC6E8, 120, 25));

			_p0heartContainer = new Sprite();
			p0Container.addChild(_p0heartContainer);
			var heart:MovieClip = new LifeGFX();
			_p0heartContainer.addChild(heart);
			heart.scaleX = 2;
			heart.scaleY = 2;
			heart.x = 100;
			heart.y = 10;
			
			_p0lifeFeedback = new Sprite();
			initHeartContainer(_p0lifeFeedback, 190);
			this.addChild(_p0lifeFeedback);
			
			_p0speedTimer = new TimerGFX();
			_p0speedTimer.gotoAndStop(3);
			_p0speedTimer.x = 150;
			_p0speedTimer.y = 480;
			_p0speedTimer.scaleX = 1.5;
			_p0speedTimer.scaleY = 1.5;	
			this.addChild(_p0speedTimer);
		}
		
		/**
		 * Initiates a container for life feedback visualised 
		 * by a heart (moving from one player to the other).
		 * 
		 * @param 	container
		 * @param 	x			The horizontal position (px).
		 */
		private function initHeartContainer(container:Sprite, x:int):void {
			container.x = x;
			container.y = 415; 
			container.alpha = 0;
			var heart:MovieClip = new LifeGFX();
			container.addChild(heart);
		}
		
		/**
		 * Creates Player 2's container holding the player's stats.  
		 * 
		 * @return 	void
		 */
		private function initP1Container():void {
			//@TODO Divide into methods
			var p1Container:Sprite = new Sprite();
			p1Container.graphics.beginFill(0x6F71FC, 1);
			p1Container.graphics.drawRect(402, 0, 398, 50);
			p1Container.graphics.endFill();
			topContainer.addChild(p1Container);

			p1Container.addChild(initMeter(452));
			_p1lifebar = new Shape();
			initBar(_p1lifebar, 456);
			p1Container.addChild(_p1lifebar);
										
			p1Container.addChild(initAvatarFrame(0x6F71FC, 750, 25));
			p1Container.addChild(initAvatar(1, 754, 22));
			p1Container.addChild(initMeterFrame(0x6F71FC, 680, 25));

			_p1heartContainer = new Sprite();
			p1Container.addChild(_p1heartContainer);
			var heart:MovieClip = new LifeGFX();
			_p1heartContainer.addChild(heart);
			heart.scaleX = 2;
			heart.scaleY = 2;
			heart.x = 670 - 10;
			heart.y = 10;
			
			_p1lifeFeedback = new Sprite();
			initHeartContainer(_p1lifeFeedback, 590);
			this.addChild(_p1lifeFeedback);
			
			_p1speedTimer = new TimerGFX();
			_p1speedTimer.gotoAndStop(3);
			_p1speedTimer.x = 550;
			_p1speedTimer.y = 480;
			_p1speedTimer.scaleX = 1.5;
			_p1speedTimer.scaleY = 1.5;	
			this.addChild(_p1speedTimer);
		}
		
		/**
		 * Creates feedback fields.
		 * 
		 * @return 	void
		 */
		private function initFeedbackFields():void {
			//@TODO Divide into methods
			//P0
			_p0livesField = new Text(113,16,100);
			_p0livesField.embedFonts = true; 
			_p0livesField.defaultTextFormat = h5;
			topContainer.addChild(_p0livesField);
			_p0livesField.text = "3";
			
			//P1
			_p1livesField = new Text(673, 16, 100);
			_p1livesField.embedFonts = true; 
			_p1livesField.defaultTextFormat = h5;
			topContainer.addChild(_p1livesField);	
			_p1livesField.text = "3";		
			
			//P0
			_p0meterField = new Text(231,17,80);
			_p0meterField.embedFonts = true; 
			_p0meterField.defaultTextFormat = h4;
			topContainer.addChild(_p0meterField);
			//_p0pointField.text = "MAX";
			
			//P1
			_p1meterField = new Text(535,17,80);	
			_p1meterField.embedFonts = true; 
			_p1meterField.defaultTextFormat = h4;
			topContainer.addChild(_p1meterField);
			//_p1pointField.text = "MAX";
			
			var winnerHeading:TextFormat = new TextFormat("ARCO", 46, 0xFFFFFF);
			winnerHeading.align = TextFormatAlign.CENTER;
			
			_p0gameoverField = new Text(0,300,400);	
			_p0gameoverField.embedFonts = true; 
			_p0gameoverField.defaultTextFormat = winnerHeading;
			this.addChild(_p0gameoverField);
			_p0gameoverField.filters = filterArray;
			_p0gameoverField.alpha = 0;
			
			_p1gameoverField = new Text(400,300,400);	
			_p1gameoverField.embedFonts = true; 
			_p1gameoverField.defaultTextFormat = winnerHeading;
			this.addChild(_p1gameoverField);
			_p1gameoverField.filters = filterArray;
			_p1gameoverField.alpha = 0;
		}
		
		/**
		 * Tween for stealing a life.
		 * 
		 * @return	void
		 */
		private function stealLife(plifeFeedback:Sprite, xPos:int, callback:Function):void {
			plifeFeedback.alpha = 1;
			Session.tweener.add(plifeFeedback, {
				x: xPos,
				duration: 1000,
				transition: Sine.easeOut,
				onComplete: callback
			});
		}
		
		/**
		 * Tween to remove life feedback.
		 * 
		 * @return	void
		 */
		private function p0lifeComplete():void{
			Session.tweener.add(_p0lifeFeedback, {
				alpha: 0,
				scaleX: 1.4,
				scaleY: 1.4,
				duration: 500,
				transition: Sine.easeOut
			});	
			_p0lifeFeedback.x = 190;
		}
		
		/**
		 * Tween to remove life feedback.
		 * 
		 * @return	void
		 */
		private function p1lifeComplete():void{
			Session.tweener.add(_p1lifeFeedback, {
				alpha: 0,
				scaleX: 1.4,
				scaleY: 1.4,
				duration: 500,
				transition: Sine.easeOut
			});	
			_p1lifeFeedback.x = 590;
		}
		
		/**
		 * Tween to game over feedback.
		 * 
		 * @return	void
		 */
		private function gameover():void{
			Session.tweener.add(_p0gameoverField, {
				alpha: 1,
				duration: 500,
				transition: Sine.easeOut
			});
			
			Session.tweener.add(_p1gameoverField, {
				alpha: 1,
				duration: 500,
				transition: Sine.easeOut
			});
		}
	}
}