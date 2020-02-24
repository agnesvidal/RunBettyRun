package se.lnu.stickossdk.display {
	
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------
	
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
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
	public class ScrollingTexture extends DisplayStateLayerSprite {
		
		//----------------------------------------------------------------------
		//  Public properties
		//----------------------------------------------------------------------
		
		/**
		 *	...
		 * 
		 *	@private
		 */
		public var velocity:Point = new Point(0.0, 0.0);
		
		//----------------------------------------------------------------------
		//  Private properties
		//----------------------------------------------------------------------
		
		/**
		 *	...
		 * 
		 *	@private
		 */
		private var m_bitmap:Bitmap;
		
		/**
		 *	...
		 * 
		 *	@private
		 */
		private var m_height:int;
		
		/**
		 *	...
		 * 
		 *	@private
		 */
		private var m_matrix:Matrix = new Matrix();
		
		/**
		 *	...
		 * 
		 *	@private
		 */
		private var m_width:int;
		
		//----------------------------------------------------------------------
		// Override public getter and setter methods
		//----------------------------------------------------------------------
		
		/**
		 *	...
		 * 
		 *	@return Number
		 */
		override public function get width():Number {
			return this.m_width;
		}
		
		/**
		 *	...
		 * 
		 *	@return Number
		 */
		override public function set width(value:Number):void {
			this.m_width = value;
		}
		
		/**
		 *	...
		 * 
		 *	@return Number
		 */
		override public function get height():Number {
			return this.m_height;
		}
		
		/**
		 *	...
		 * 
		 *	@return Number
		 */
		override public function set height(value:Number):void {
			this.m_height = value;
		}
		
		//----------------------------------------------------------------------
		// Constructor method
		//----------------------------------------------------------------------
		
		/**
		 *	...
		 */
		public function ScrollingTexture(texture:Class, width:int = 800, height:int = 600, vx:Number = 0, vy:Number = 0) {
			this.m_bitmap = new texture() as Bitmap;
			this.m_width = width;
			this.m_height = height;
			this.velocity.x = vx;
			this.velocity.y = vy;
		}
		
		//----------------------------------------------------------------------
		// Override public methods
		//----------------------------------------------------------------------
		
		/**
		 *	...
		 * 
		 *	@return void
		 */
		override public function update():void {
			m_updateTexture();
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 *	...
		 * 
		 *	@return void
		 */
		private function m_updateTexture():void {
			m_matrix.translate(velocity.x, velocity.y);
			graphics.clear();
			graphics.beginBitmapFill(m_bitmap.bitmapData, m_matrix);
			graphics.drawRect(0, 0, this.m_width, this.m_height);
		}
	}
}

