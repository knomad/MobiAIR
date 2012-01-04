package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.TextField;
	
	public class MobiAIR extends Sprite
	{
		public function MobiAIR()
		{
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var text:TextField = new TextField();
			text.text = "Hello github ;)";
			addChild(text);
		}
	}
}