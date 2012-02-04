package Examples
{
	import com.Ammarz.MobiAIR.Graphics.DisplayObject.MobiSprite;
	import com.Ammarz.MobiAIR.MobiAIR;
	import com.Ammarz.MobiAIR.ScreenSystem.BaseScreen;
	import com.Ammarz.MobiAIR.utilz;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.osmf.layout.HorizontalAlign;
	
	public class E2_LotsOfSprites extends BaseScreen
	{	
		
		//this is the basic sprite
		private var _sprites:Vector.<MobiSprite>;
		private var _frames:Vector.<BitmapData>;
		private var _spriteCountText:TextField;
		
		public function E2_LotsOfSprites()
		{
			super();
		}
		
		override public function init():void
		{
			var movieClip:MovieClip = new Assets.FX_TorpidoExplosion();
			
			_frames = utilz.mcToBitmapsAutoScale(movieClip,106,73,MobiAIR.globalScale);
			_sprites = new Vector.<MobiSprite>();
			var i:int;
			for (i = 0 ; i < 5 ; i++)
			{
				addExplosion();
			}
			
			createNavigationButtons();
			createTitle("Example 2 - Many sprites\nTouch the screen to add more");
			createSpriteCountText();
			updateSpriteCount();
		}
		
		private function addExplosion(posX:Number = -1 , posY:Number = -1,randomFrame:Boolean = true):void
		{
			if (posX < 0) posX = Math.random() * MobiAIR.stage.stageWidth;
			if (posY < 0) posY = Math.random() * MobiAIR.stage.stageHeight;
			
			var exp:MobiSprite = new MobiSprite(_frames);
			exp.x = posX - _frames[0].width / 2;
			exp.y = posY - _frames[0].height / 2;
			
			exp.play(true);
			if (randomFrame) exp.frame = Math.floor(Math.random() * exp.numFrames);
			
			addChild(exp);
			_sprites.push(exp);
		}
		
		private function createSpriteCountText():void
		{
			_spriteCountText = new TextField();
			_spriteCountText.autoSize = TextFieldAutoSize.CENTER;
			_spriteCountText.defaultTextFormat = new TextFormat(null,MobiAIR.applyScale(14),0xFFFFFF);
			_spriteCountText.x = MobiAIR.stage.stageWidth / 2;
			_spriteCountText.y = MobiAIR.applyScale(60);
			addChild(_spriteCountText);
		}
		
		private function updateSpriteCount():void
		{
			_spriteCountText.text = _sprites.length.toString() + " sprite on screen!";
		}
		
		override public function handleAction(px:int, py:int, button:uint=0):void
		{
			super.handleAction(px,py,button);
			if (button == 0)
			{
				addExplosion(px,py,false);
				updateSpriteCount();
			}
		}
		
		override public function update(elapsed:Number=1):void
		{
			//update all sprites
			for each (var s:MobiSprite in _sprites)
			{
				s.update(elapsed);
			}
		}
		
		protected function handleButtons(btnName:String):void
		{
			switch (btnName)
			{
				case "nextButton":
					MobiAIR.setScreen(new E3_AnimationPackage(),0.05);
					break;
				case "prevButton":
					MobiAIR.setScreen(new E1_BasicSprite(),0.05);
					break;
			}
		}
		
		private function createNavigationButtons():void
		{
			//create a button to switch to the next example
			var nextButtonMC:MovieClip = new Assets.BTN_Next();
			
			//set the postion, the prerendered bitmap will be placed at that position
			nextButtonMC.x = MobiAIR.stage.stageWidth  - MobiAIR.applyScale(10 + nextButtonMC.width);
			nextButtonMC.y = MobiAIR.stage.stageHeight - MobiAIR.applyScale(10 + nextButtonMC.height);
			
			//give it a name and it will be passed to the callback function
			nextButtonMC.name = "nextButton";
			
			/*render the movieclip and check for input
			this method will check manually without additional events.*/
			setupStaticGUI(nextButtonMC,handleButtons);
			
			//create the previous button
			var prevButtonMC:MovieClip = new Assets.BTN_Prev();
			prevButtonMC.x = MobiAIR.applyScale(10);
			prevButtonMC.y = MobiAIR.stage.stageHeight - MobiAIR.applyScale(10 + prevButtonMC.height);
			prevButtonMC.name = "prevButton";
			setupStaticGUI(prevButtonMC,handleButtons);
		}
		
		private function createTitle(text:String):void
		{
			//make screen title
			var tf:TextField = new TextField();
			tf.multiline = true;
			tf.defaultTextFormat = new TextFormat(null,20,0x33CCFF,null,null,null,null,null,HorizontalAlign.CENTER);
			tf.x = 0;
			tf.y = MobiAIR.applyScale(10);
			tf.width = MobiAIR.stage.stageWidth;
			tf.text = text;
			addChild(tf);
		}
	}
}