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
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import org.osmf.layout.HorizontalAlign;
	
	public class E3_AnimationPackage extends BaseScreen
	{	
		
		private var _ship:MobiSpritePack;
		
		public function E3_AnimationPackage()
		{
			super();
		}
		
		private function initShip():void
		{
			//get movieclips containing animations
			var raw_mc1:MovieClip = new Assets.ship_Damaged1();
			var raw_mc2:MovieClip = new Assets.ship_Damaged2();
			var raw_mc3:MovieClip = new Assets.ship_Damaged3();
			var raw_mc4:MovieClip = new Assets.ship_Damaged4();
			
			// I want the ship to appear bigger than it's originally is
			var shipScale:Number = 3 * MobiAIR.globalScale;
			
			//render movieclipts to animations
			var anim1:Animation = utilz.mcToAnimationAutoScale(raw_mc1,93,83,shipScale,false,0.5);
			var anim2:Animation = utilz.mcToAnimationAutoScale(raw_mc2,93,83,shipScale,false,0.5);
			var anim3:Animation = utilz.mcToAnimationAutoScale(raw_mc3,93,83,shipScale,false,0.5);
			var anim4:Animation = utilz.mcToAnimationAutoScale(raw_mc4,93,83,shipScale,false,0.5);
			
			//create an package and put the animations inside it and give each a unique IDs
			var animationPackage:AnimationPackage = new AnimationPackage();
			animationPackage.addAnimation(anim1,"d1");
			animationPackage.addAnimation(anim2,"d2");
			animationPackage.addAnimation(anim3,"d3");
			animationPackage.addAnimation(anim4,"d4");
			
			//now create the ship and pass the animation package
			_ship = new MobiSpritePack(animationPackage);
			_ship.gX = MobiAIR.stage.stageWidth / 2 - anim1.bitmap[0].width / 2;
			_ship.gY = 100;
			_ship.setByName("d1");
			addChild(_ship);
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
			initShip();
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
			_ship.update(elapsed);
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
					_ship.setByName(btnName);
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