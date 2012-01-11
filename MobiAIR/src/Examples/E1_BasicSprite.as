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
	
	public class E1_BasicSprite extends BaseScreen
	{	
		
		//this is the basic sprite
		private var _sprite:MobiSprite;
		
		public function E1_BasicSprite()
		{
			super();
		}
		
		override public function init():void
		{
			//initialize the movie clip you want to use
			var movieClip:MovieClip = new Assets.FX_TorpidoExplosion();
			
			/* render the movieclip to BitmapData's and store it in a vector
			utilz.mcToBitmapsAutoScale will conver the MovieCLip to render the movieclip and scale it depending on the value we set at MobiAIR_Test.as
			The cool thing is that this way you can support many screens without having to include graphics for each resolution ... its all vector!!
			Make sure to explore Assets.fla to see how movieclips should be structured*/
			var frames:Vector.<BitmapData> = utilz.mcToBitmapsAutoScale(movieClip,106,73,MobiAIR.globalScale);
			
			/* create a sprite (bascially a container) and pass the frames
			note that you can use these frames on many sprites without risking memory */
			_sprite = new MobiSprite(frames);
			
			//play the animation
			_sprite.play(true);
			
			//setPosition will set the position and multiply it by globalScale so you don't have to alter the code on different resolutions
			//gX, gY can be used as x, y but also takes count of the globalScale
			//while this method is awesome in some cases you should still take count of aspect ratio differences
			_sprite.setPosition(100,100);
			
			//normally add the sprite on the stage
			addChild(_sprite);
			
			createNavigationButtons();
			createTitle("Example 1 - Basic Sprite");
		}
		
		override public function update(elapsed:Number=1):void
		{
			//you must update the sprite on each frame
			_sprite.update(elapsed);
		}
		
		protected function handleButtons(btnName:String):void
		{
			trace(btnName);
			switch (btnName)
			{
				case "nextButton":
					MobiAIR.setScreen(new E2_LotsOfSprites(),0.05);
					break;
				case "prevButton":
					MobiAIR.setScreen(new E3_AnimationPackage(),0.05);
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
			tf.defaultTextFormat = new TextFormat(null,MobiAIR.applyScale(20),0x33CCFF,null,null,null,null,null,HorizontalAlign.CENTER);
			tf.x = 0;
			tf.y = MobiAIR.applyScale(10);
			tf.width = MobiAIR.stage.stageWidth;
			tf.text = text;
			addChild(tf);
		}
	}
}