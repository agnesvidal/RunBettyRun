package object.track {
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import object.track.part.PartLeft;
	import object.track.part.PartRight;
	import object.track.part.PartStraight;
	import object.track.part.partgap.PartGap3;
	import object.track.part.partgap.PartGap5;
	
	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Represents a track.
	 */
	public class Track extends DisplayStateLayerSprite {
		//-------------------------------------------------------
		// Public getter and setter methods
		//-------------------------------------------------------
		/**
		 * Getter that returns all parts that has been placed on the track.
		 *
		 * @return	Vector.<Part>
		 */
		public function get trackParts():Vector.<PartContainer> {
			return _trackParts;
		}
		
		//-------------------------------------------------------
		// Private properties
		//-------------------------------------------------------
		/**
		 * Used to center the track in the game world. Differs 
		 * between Singleplayer and Versus mode.
		 */
		private var _gsWidth:uint;
		
		/**
		 * List containing all parts that has been placed on the 
		 * track.
		 */
		private var _trackParts:Vector.<PartContainer> = new Vector.<PartContainer>;
		
		/**
		 * 0 = up, 1 = left, 2 = right, 3 = down 
		 */
		private var _trackDirection:uint = 0;
		
		/**
		 * Last part placed on track, used to place the next part 
		 * correctly.
		 */
		private var _lastPart:PartContainer = null;
		
		/**
		 * New part to add to the track. 
		 */
		private var _newPart:PartContainer = null;
		
		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		public function Track(gsWidth:uint) {
			super();
			_gsWidth = gsWidth;
		}
		
		//-------------------------------------------------------
		// Override public methods
		//-------------------------------------------------------
		/**
		 * Initializes the track.
		 *
		 * @return	void
		 */
		override public function init():void {
			this.initDefaultStart();
		}
		
		/**
		 * Deallocation code for the object.
		 * 
		 * @return 	void
		 */
		override public function dispose():void {
			this.disposeTrackparts();
			if (parent) parent.removeChild(this);
		}
		
		/**
		 * Updates track by adding a new random part (from GameLogic).
		 *
		 * @param 	part	Type of part to be instantiated.
		 * @param 	item	Token/Speed boost/Speed reducer.
		 * @return	void
		 */
		public function updateTrack(part:Class, item:Object):void {
			_newPart = new PartContainer(part);
			if (item.hasOwnProperty("t") == true) {
				_newPart.part.addItem(item.t, item.r, item.c);
			}
			this.pushRandomPart();
		}
		
		/**
		 * Removes the first part of the current track.
		 * 
		 * @return	void
		 */
		public function removeFirstPart():void {
			_trackParts.shift();
			this.removeChildAt(0); 
		}
		
		//-------------------------------------------------------
		// Private methods
		//-------------------------------------------------------
		/**
		 * Adds new part to the list.
		 *
		 * @param	newPart	
		 * @return	void
		 */
		private function pushRandomPart():void {
			_trackParts.push(_newPart);
			this.addNewPart(_trackParts[_trackParts.length - 1]);		
		}
		
		/**
		 * 
		 *
		 * @param	newPart
		 * @return	void
		 */
		private function addNewPart(part:PartContainer):void {
			this.setPosition(part);
			_lastPart = part;
			this.addChild(part);
		}
		
		/**
		 * Sets the position of a part. 
		 *
		 * @param	pc		PartContainer
		 * @return	void
		 */
		private function setPosition(pc:PartContainer):void {
			pc.part.runningDirection = _trackDirection;
			switch(_trackDirection) {
				case 0: 
					pc.x = _lastPart.x;	
					pc.y = _lastPart.y - _lastPart.width;
					_trackDirection = pc.part.direction[0]; 
					break;
				case 1: 
					pc.x = _lastPart.x - _lastPart.width;	
					pc.y = _lastPart.y;					
					pc.part.rotateGrid(-90);
					_trackDirection = pc.part.direction[2];		
					break;	
				case 2: 
					pc.x = _lastPart.x + _lastPart.width;	
					pc.y = _lastPart.y;
					pc.part.rotateGrid(90);
					_trackDirection = pc.part.direction[3];
					break;
				case 3: 
					pc.x = _lastPart.x + _lastPart.width;	
					pc.y = _lastPart.y;
					_trackDirection = pc.part.direction[1];
					break;
			}	
		}
		
		/**
		 * Initializes and positions the default parts that 
		 * the track always starts with.
		 *
		 * @param	...
		 * @return	void
		 */
		private function initDefaultStart():void {
			_trackParts.push(	
				new PartContainer(PartStraight),
				new PartContainer(PartStraight),
				new PartContainer(PartStraight),
				new PartContainer(PartStraight),
				new PartContainer(PartStraight),
				new PartContainer(PartStraight),
				new PartContainer(PartGap3),
				new PartContainer(PartStraight),
				new PartContainer(PartGap5),
				new PartContainer(PartStraight),
				new PartContainer(PartStraight),
				new PartContainer(PartRight),
				new PartContainer(PartStraight),				
				new PartContainer(PartGap3),
				new PartContainer(PartStraight),
				new PartContainer(PartLeft)
			);
			
			this.setFirst(_trackParts[0]);
			
			for (var i:int = 1; i<_trackParts.length; i++) {
				this.addNewPart(_trackParts[i]);
			}		
		}
		
		/**
		 * Sets the position of the first part on the track.
		 * 
		 * @param 	part			First part
		 * @return 	void
		 */
		private function setFirst(pc:PartContainer):void {
			pc.x = _gsWidth/2 - (pc.width/3) * 1.5;
			pc.y = 1680;
			addChild(pc);
			_lastPart = pc;
		}
		
		/**
		 * Deallocates trackParts
		 * 
		 */
		private function disposeTrackparts():void {
			for(var i:int = 0; i < _trackParts.length; i++) {
				_trackParts[i].dispose();
			}
			_trackParts.length = 0;
		}
	}
}