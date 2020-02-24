package se.lnu.stickossdk.display {
	
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	
	/**
	 *	...
	 *
	 *	@author		Henrik Andersen <henrik.andersen@lnu.se>
	 *	@copyright	Copyright (c) 2013.
	 *	@license	Creative Commons (BY-NC-SA)
	 *	@version	1.0
	 *	@since		2013-11-22
	 */
	public class ScrollingTextureStack extends DisplayStateLayerSprite {
		
		//----------------------------------------------------------------------
		//  Private properties
		//----------------------------------------------------------------------
		
		/**
		 *	...
		 * 
		 *	@private
		 */
		private var m_stackMask:Sprite = new Sprite();
		
		//----------------------------------------------------------------------
		// Override public getter and setter methods
		//----------------------------------------------------------------------
		
		/**
		 *	...
		 * 
		 *	@return Number
		 */
		override public function get width():Number {
			return this.m_stackMask.width;
		}
		
		/**
		 *	...
		 * 
		 *	@return Number
		 */
		override public function set width(value:Number):void {
			this.m_initStackMask(value, this.m_stackMask.height);
		}
		
		/**
		 *	...
		 * 
		 *	@return Number
		 */
		override public function get height():Number {
			return this.m_stackMask.height;
		}
		
		/**
		 *	...
		 * 
		 *	@return Number
		 */
		override public function set height(value:Number):void {
			this.m_initStackMask(this.m_stackMask.width, value);
		}
		
		//----------------------------------------------------------------------
		// Constructor method
		//----------------------------------------------------------------------
		
		/**
		 *	...
		 */
		public function ScrollingTextureStack(width:int = 800, height:int = 600) {
			this.m_initStackMask(width, height);
		}
		
		//----------------------------------------------------------------------
		// Override public methods
		//----------------------------------------------------------------------
		
		/**
		 *	...
		 * 
		 *	@return void
		 */
		override public function addChild(child:DisplayObject):DisplayObject {
			if (child is ScrollingTexture) {
				super.addChild(child);
			}
			
			return child;
		}
		
		/**
		 *	...
		 * 
		 *	@return void
		 */
		override public function dispose():void {
			this.m_disposeStackMask();
			this.m_disposeStack();
		}
		
		//----------------------------------------------------------------------
		// Public methods
		//----------------------------------------------------------------------
		
		/**
		 *	...
		 * 
		 *	@return void
		 */
		public function create(texture:Class, vx:Number = 0, vy:Number = 0):void {
			var scrollingTexture:ScrollingTexture = new ScrollingTexture(texture, this.width, this.height, vx, vy);
			this.addChild(scrollingTexture);
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 *	...
		 * 
		 *	@return void
		 */
		private function m_initStackMask(width:Number = 800, height:Number = 600):void {
			if (this.m_stackMask == null) this.m_stackMask = new Sprite();
			this.m_stackMask.graphics.clear();
			this.m_stackMask.graphics.beginFill(0xFF00FF);
			this.m_stackMask.graphics.drawRect(0, 0, width, height);
			this.m_stackMask.graphics.endFill();
			this.mask = this.m_stackMask;
		}
		
		/**
		 *	...
		 * 
		 *	@return void
		 */
		private function m_disposeStackMask():void {
			if (this.m_stackMask != null) {
				this.mask = null;
				this.m_stackMask.graphics.clear();
				this.m_stackMask = null;
			}
		}
		
		/**
		 *	...
		 * 
		 *	@return void
		 */
		private function m_disposeStack():void {
			var child:ScrollingTexture;
			while (this.numChildren > 0) {
				child = this.getChildAt(0) as ScrollingTexture;
				child.dispose();
				child = null;
			}
		}
	}
}
