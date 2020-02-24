package object.track.part {
	//-------------------------------------------------------------------------
	// Imports
	//-------------------------------------------------------------------------
	import object.track.Part;
	import asset.TrackLeftGFX;

	//--------------------------------------------------------------------------
	// Public class
	//--------------------------------------------------------------------------
	/**
	 * Represents a left corner part.
	 */
	public class PartLeft extends Part {
		/**
		 *  List used to set the new direction of the track after the part has been placed. 
		 */
		private var _directions:Vector.<uint> = new <uint>[1,2,3,0];

		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		public function PartLeft() {
			super(TrackLeftGFX, 1, this._directions);
		}
	}
}