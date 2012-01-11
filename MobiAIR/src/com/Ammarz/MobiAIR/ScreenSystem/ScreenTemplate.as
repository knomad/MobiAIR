package com.CardGame.Screens
{
	import com.Ammarz.MobiAIR.ScreenSystem.BaseScreen;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	
	[Embed (source = "media/assets.swf",symbol="MainMenuUI")]
	public final class MainMenu extends BaseScreen
	{
		//public var bg:MovieClip;

		public function MainMenu()
		{
			super();
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			super.dispose();
		}
		
		override public function handleActionEnd(px:int, py:int):void
		{
			// TODO Auto Generated method stub
			super.handleActionEnd(px, py);
		}
		
		override public function init():void
		{
			super.init();
		}
		
		private function handleReplayButton():void
		{

		}
		
	}
}