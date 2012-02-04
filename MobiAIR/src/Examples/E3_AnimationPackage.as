package Examples
{
	import com.Ammarz.MobiAIR.Graphics.Animation;
	import com.Ammarz.MobiAIR.Graphics.AnimationPackage;
	import com.Ammarz.MobiAIR.Graphics.DisplayObject.MobiSprite;
	import com.Ammarz.MobiAIR.Graphics.DisplayObject.MobiSpritePack;
	import com.Ammarz.MobiAIR.MobiAIR;
	import com.Ammarz.MobiAIR.ScreenSystem.BaseScreen;
	import com.Ammarz.MobiAIR.utilz;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import org.osmf.layout.HorizontalAlign;
	
	public class E3_AnimationPackage extends BaseScreen
	{	
		
		private var _sprite:MobiSpritePack;
		
		public function E3_AnimationPackage()
		{
			super();
		}
		
		private function initSprite():void
		{
			//get movieclips containing animations
			var raw_mc1:MovieClip = new Assets.char1();
			var raw_mc2:MovieClip = new Assets.char2();
			var raw_mc3:MovieClip = new Assets.char3();
			var raw_mc4:MovieClip = new Assets.char4();
			
			//add glow filter for the fun of it, it won't affect the performance since its going to be prerendered
			var glow:GlowFilter = new GlowFilter(0xFFFFFF,1,6,6,3,3);
			raw_mc1.filters = [glow];
			raw_mc2.filters = [glow];
			raw_mc3.filters = [glow];
			raw_mc4.filters = [glow];
			
			// I want the ship to appear bigger than it's originally is
			var charScale:Number = 0.5 * MobiAIR.globalScale;
			
			//render movieclipts to animations
			var anim1:Animation = utilz.mcToAnimationAutoScale(raw_mc1,148,198,charScale,false,0.7);
			var anim2:Animation = utilz.mcToAnimationAutoScale(raw_mc2,172,198,charScale,false,1);
			var anim3:Animation = utilz.mcToAnimationAutoScale(raw_mc3,246,198,charScale,false,1);
			var anim4:Animation = utilz.mcToAnimationAutoScale(raw_mc4,219,198,charScale,false,1);
			
			//create an package and put the animations inside it and give each a unique IDs
			var animationPackage:AnimationPackage = new AnimationPackage();
			animationPackage.addAnimation(anim1,"d1");
			animationPackage.addAnimation(anim2,"d2");
			animationPackage.addAnimation(anim3,"d3");
			animationPackage.addAnimation(anim4,"d4");
			
			//now create the ship and pass the animation package
			_sprite = new MobiSpritePack(animationPackage);
			_sprite.gX = 30;
			_sprite.gY = 100;
			_sprite.setByName("d1");
			
			addChild(_sprite);
		}
		
		private function initAnimationButtons():void
		{
			var btnMC:MovieClip = new Assets.PurpleBox();
			
			var i:int;
			for (i = 1 ; i <= 4 ; i++)
			{
				btnMC.name = "d" + i.toString();
				btnMC.x = MobiAIR.applyScale(45) + (i - 1) * (MobiAIR.applyScale(btnMC.width + 22));
				btnMC.y = MobiAIR.stage.stageHeight - MobiAIR.applyScale(120);
				setupStaticGUI(btnMC,handleButtons,false,true,false,1.5);
			}
		}
		
		override public function init():void
		{
			initSprite();
			initAnimationButtons();
			createNavigationButtons();
			createTitle("Animation Package\nclick the buttons to switch animations");
		}
		
		
		override public function handleAction(px:int, py:int, button:uint=0):void
		{
			if (button == 0)
			{
				
			}
		}
		
		override public function update(elapsed:Number=1):void
		{
			_sprite.update(elapsed);
		}
		
		protected function handleButtons(btnName:String):void
		{
			switch (btnName)
			{
				case "nextButton":
					MobiAIR.setScreen(new E1_BasicSprite(),0.05);
					break;
				case "prevButton":
					MobiAIR.setScreen(new E2_LotsOfSprites(),0.05);
					break;
				default:
					_sprite.setByName(btnName);
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
		
		override public function dispose():void
		{
			_sprite.dispose();
		}
	}
}