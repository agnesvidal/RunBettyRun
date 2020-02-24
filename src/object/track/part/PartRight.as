package object.track.part {
	//-------------------------------------------------------------------------
	// Imports
	//-------------------------------------------------------------------------
	import object.track.Part;
	import asset.TrackRightGFX;

	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Represents a right corner part.
	 */
	public class PartRight extends Part {
		/**
		 *  List used to set the new direction of the track after the part has been placed. 
		 */
		private var _directions:Vector.<uint> = new <uint>[2,1,0,3]; 
		
		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		public function PartRight() {
			super(TrackRightGFX, 2, this._directions);
		}
	}
}