package ui{
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import asset.PlayerOneGFX;
	import asset.PlayerTwoGFX;

	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Base class for the HUD.
	 */
	public class HUD extends DisplayStateLayerSprite {
		//----------------------------------------------------------------------
		// Protected properties
		//----------------------------------------------------------------------
		/**
		 * Container that holds player stats.  
		 */
		protected var topContainer:Sprite;
		
		/**
		 * Format for Heading 1 
		 */
		protected var h1:TextFormat;
		
		/**
		 * Format for Heading 2 
		 */
		protected var h2:TextFormat;
		
		/**
		 * Format for Heading 3 
		 */
		protected var h3:TextFormat;
		
		/**
		 * Format for Heading 4 
		 */
		protected var h4:TextFormat;
		
		/**
		 * Format for Heading 5 
		 */
		protected var h5:TextFormat;
		
		/**
		 * Contains an outline filter for text. 
		 */
		protected var filterArray:Array = new Array();

		//-------------------------------------------------------
		// Constructor
		//-------------------------------------------------------
		public function HUD(x:int){
			initTopContainer(x);	
			initTextFormats();
			initOutline();
		}
		
		//-------------------------------------------------------
		// Public methods
		//-------------------------------------------------------
		/**
		 * Deallocation code for the object.
		 * 
		 * @return 	void
		 */
		override public function dispose():void {
			//@TODO
		}
		
		/**
		 * Abstract method that initiates the HUD. 
		 * (Note: this method must be overriden in subclass.)
		 * 
		 * @return 	void
		 */
		public function initHUD():void {
			throw new IllegalOperationError("Call to abstract method (must be overridden in a subclass)");
		}
		
		//-------------------------------------------------------
		// Protected methods
		//-------------------------------------------------------
		/**
		 * Initiates graphics (an avatar) that corresponds 
		 * to the player.
		 * 
		 * @param 	player		Player's ID.
		 * @param 	x			The horizontal position (px).	
		 * @param 	y			The vertical position (px).
		 * @return	MovieClip 	Returns a graphic representation of the avatar.
		 */
		protected function initAvatar(player:uint, x:Number, y:Number):MovieClip{
			var avatar:MovieClip
			if(player == 0) {
				avatar = new PlayerOneGFX();
				avatar.rotation = 130;
			} else {
				avatar = new PlayerTwoGFX();
				avatar.rotation = 230;
			}
			avatar.scaleX = 1.5;
			avatar.scaleY = 1.5;
			avatar.x = x;
			avatar.y = y;
			avatar.gotoAndStop("idle");
			avatar.cacheAsBitmap = true;
			
			return avatar;
		}
		
		/**
		 * Initiates a circular frame that holds the 
		 * avatar graphics.
		 * 
		 * @param 	color		The color of the fill (0xRRGGBB).
		 * @param 	x			The horizontal position (px).
		 * @param 	y			The vertical position (px).
		 * @return 	Sprite		A circular frame.
		 */
		protected function initAvatarFrame(color:uint, x:Number, y:Number):Sprite {
			var circle:Sprite = new Sprite();
			circle.graphics.beginFill(color, 1); 
			circle.graphics.drawCircle(x,y,40);
			circle.graphics.endFill();
			
			var innerCircle:Shape = new Shape();
			innerCircle.graphics.beginFill(0xFFFFFF, 1);
			innerCircle.graphics.drawCircle(x,y,34);
			innerCircle.graphics.endFill();
			circle.addChild(innerCircle);
			
			return circle;
		}
		
		/**
		 * Creates a meter used to keep track of collected items.
		 * 
		 * @param 	x			The horizontal position (px).
		 */
		protected function initMeter(x:Number):Sprite {
			var meter:Sprite = new Sprite(); 
			meter.graphics.beginFill(0xFFFFFF, 1);
			meter.graphics.drawRoundRect(x,10,208,32,10,10);
			meter.graphics.endFill();
			
			var meterInner:Shape = new Shape();
			meterInner.graphics.beginFill(0xFF00CC, 1);
			meterInner.graphics.drawRect((x+4), 14, 200, 24);
			meterInner.graphics.endFill();
			meter.addChild(meterInner);			
			
			return meter;
		}
		
		/**
		 * Creates a visual representation of the meter's bar.
		 * The bar represents how many items has been collected. 
		 * 
		 * @param 	bar			The bar to be visually represented.
		 * @param 	x			The horizontal position (px).
		 * @return 	void
		 */
		protected function initBar(bar:Shape, x:Number):void {
			bar.graphics.beginFill(0xFFFFFF, 1);
			bar.graphics.drawRect(0, 14, 200, 24);
			bar.graphics.endFill();
			bar.x = x; 
		}
		
		/**
		 * Creates a frame that is used to hold a visual 
		 * representation indicating what the meter is used for. 
		 * 
		 * @param 	color		The color of the fill (0xRRGGBB).
		 * @param 	x			The horizontal position (px).
		 * @param 	y			The vertical position (px).
		 * @return 	Sprite
		 */
		protected function initMeterFrame(color:uint, x:Number, y:Number):Sprite {
			var circle:Sprite = new Sprite();
			circle.graphics.beginFill(color, 1); 
			circle.graphics.drawCircle(x,y,28);
			circle.graphics.endFill();
			
			var innerCircle:Shape = new Shape();
			innerCircle.graphics.beginFill(0xFFFFFF, 1);
			innerCircle.graphics.drawCircle(x,y,24);
			innerCircle.graphics.endFill();
			circle.addChild(innerCircle);
			
			return circle;
		}
		
		//-------------------------------------------------------
		// Private methods
		//-------------------------------------------------------
		/**
		 * Instantiates new text formats. 
		 * 
		 */
		private function initTextFormats():void {		
			h1 = new TextFormat("ARCO", 26, 0xFFFFFF);
			h2 = new TextFormat("ARCO", 18, 0xFFFFFF);
			h3 = new TextFormat("ARCO", 16, 0xFFFFFF);	
			h4 = new TextFormat("ARCO", 12, 0xFFFFFF);	
			h1.align = h2.align = h3.align = h4.align = TextFormatAlign.CENTER;
			h5 = new TextFormat("Roboto", 16, 0xFFFFFF);
		}
		
		/**
		 * Creates the top container that holds player stats.
		 *  
		 * @param 	width	The width of the container (px).
		 * @param 	color	The color of the fill (0xRRGGBB).
		 * 
		 */
		private function initTopContainer(width:Number, color:uint = 0x3CC6E8):void {
			topContainer = new Sprite();
			topContainer.graphics.beginFill(color, 1);
			topContainer.graphics.drawRoundRect(-10,0,width,50,10,10)
			topContainer.graphics.endFill();
			topContainer.y = 30;
			this.addChild(topContainer);
		}
		/**
		 * Creates a filter used to add an outline effect to text
		 * .
		 * @return 	void 
		 */
		private function initOutline():void {
			var outline:GlowFilter = new GlowFilter();
			outline.blurX = outline.blurY = 3;
			outline.color = 0xFF00CC;
			outline.quality = BitmapFilterQuality.HIGH;
			outline.strength = 100;
			filterArray.push(outline);
		}	
	}
}