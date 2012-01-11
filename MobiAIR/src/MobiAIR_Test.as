package
{
	import Examples.E1_BasicSprite;
	
	import com.Ammarz.MobiAIR.MobiAIR;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	
	[SWF(frameRate="30",backgroundColor="0x000000")]
	public class MobiAIR_Test extends Sprite
	{
		public function MobiAIR_Test()
		{
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			
			//this will initialize the engine, it will wait a bit till the stage adapts the screen resolution.
			//then it will call the init function.
			MobiAIR.init(this,init);
		}
		
		private function init():void
		{
			//the global scale is an idea I came up with to automatically scale everything depending on the screen
			//resolution, so it makes multiscreen development easier
			//here I am using 320 (3gs) as a base
			MobiAIR.globalScale = stage.stageWidth / 320;
			MobiAIR.enableFPS();
			//now show Example one ... go check it out right now!
			MobiAIR.setScreen(new E1_BasicSprite());
		}
	}
}