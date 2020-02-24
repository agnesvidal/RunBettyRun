package object.track.part {
	//-------------------------------------------------------------------------
	// Imports
	//-------------------------------------------------------------------------
	import object.track.Part;
	import asset.TrackStraightGFX;	

	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Represents a straight part.
	 */
	public class PartStraight extends Part {
		/**
		 *  List used to set the new direction of the track after the part has been placed. 
		 */
		private var _directions:Vector.<uint> = new <uint>[0,3,1,2 ];
		
		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		public function PartStraight() {
			super(TrackStraightGFX, 0, this._directions);		
		}
	}
}