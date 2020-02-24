package {
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------
	import se.lnu.stickossdk.system.Engine;
	
	import state.SplashScreenState;
	
	//--------------------------------------------------------------------------
	// SWF properties
	//--------------------------------------------------------------------------
	[SWF(width="800", height="600", frameRate="60", backgroundColor="#000000")]
	
	//----------------------------------------------------------------------
	// Constructor method
	//----------------------------------------------------------------------
	public class RunBettyRun extends Engine {
		[Embed(source="../asset/Roboto/Roboto-Bold.ttf", fontName="Roboto", embedAsCFF="false")]
		public const ROBOTO:Class;
		
		[Embed(	source="../asset/Arco/ARCO.otf", fontName="ARCO", embedAsCFF="false")]
		public static const ARCO:Class;
		
		public function RunBettyRun() {
			
		}
		
		//----------------------------------------------------------------------
		// Override public methods
		//----------------------------------------------------------------------
		override public function setup():void {
			this.initId = 46;
			this.initDisplayState = SplashScreenState;
			this.initDebugger = true;
			this.initBackgroundColor = 0x14033F;			
		}		
	}
}