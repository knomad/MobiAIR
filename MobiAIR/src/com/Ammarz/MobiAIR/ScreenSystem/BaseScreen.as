package com.Ammarz.MobiAIR.ScreenSystem {
	import com.Ammarz.MobiAIR.MobiAIR;
	import com.Ammarz.MobiAIR.utilz;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class BaseScreen extends Sprite{
		
		internal var _screenWidth:Number;
		internal var _screenHeight:Number;
		protected var _buttons:Vector.<Rectangle>;
		protected var _buttonActions:Vector.<Function>;
		protected var i:uint;
		private var _bCount:uint;
		private var _bitmaps:Vector.<BitmapData>;
		private var _names:Vector.<String>;

		
		public function BaseScreen(screenW:Number = 0,screenH:Number = 0) {
			if (screenW > 0)
			{
				_screenWidth = screenW;
				_screenHeight = screenH;
			}else
			{
				_screenWidth = MobiAIR.stage.stageWidth;
				_screenHeight = MobiAIR.stage.stageHeight;
			}
			
			_buttons = new Vector.<Rectangle>();
			_buttonActions = new Vector.<Function>();
			_bCount = 0;
			_bitmaps = new Vector.<BitmapData>();
			_names = new Vector.<String>();
		}
		
		//override this:
		public function init():void
		{
			
		}
		
		//override this:
		public function update(elapsed:Number = 1):void
		{
			
		}
		
		//override this:
		public function dispose():void
		{
			for each (var bm:BitmapData in _bitmaps)
			{
				bm.dispose();
			}
		}
		
		public function handleAction(px:int,py:int,button:uint = 0):void
		{
			//override me plz :D
		}
		
		public function runCommand(command:String,par:Vector.<String> = null):void
		{
			
		}
		
		public function handleActionEnd(px:int,py:int):void
		{
			for (i = 0; i < _bCount; i++)
			{
				if (_buttons[i].contains(px,py))
				{
					if (_buttonActions[i].length > 0)
					{
						_buttonActions[i](_names[i]);
					}else
					{
						_buttonActions[i]();
					}
				}
			}
		}
		public function handleMove(px:int,py:int):void
		{
			
		}
		
		
		/**
		 * takes a movieclipt, renders it to a bitmap, adds it to the screen and automatically check for touch input if you pass a function to be called back
		 * the GUI will be placed based on the x and y of the DisplayObject you passed and it will be multiplied by the global scale.
		 * @param displayObject the flash object to be rendered
		 * @param action the function to call if the user touched or clicked the gui
		 * @param noGraphic will not display the graphic, but use its coordinates to check for user input
		 * @param bMode "button mode" adds a little animation, its experimental so I don't suggest using it
		 * @param autoRemove automatically removes the movieClip you used from its parent if it has one
		 * @param scale applies additional scale to the object, will not affect the position
		 * @param useGlobalScaling automatically scale the rendered bitmap to the global scaling
		 * @param usePositionScaling automatically multiply the position by global scale
		 * */
		final protected function setupStaticGUI(displayObject:MovieClip,action:Function = null,noGraphic:Boolean = false,bMode:Boolean = false,autoRemove:Boolean=true,scale:Number = 1,useGlobalScaling:Boolean = true,usePositionScaling:Boolean = false):Bitmap
		{
			var bitmapGUI:Bitmap;
			
			var scl:Number = useGlobalScaling ? MobiAIR.globalScale * scale : scale;
			var pscl:Number = usePositionScaling ? MobiAIR.globalScale : 1;
			
			var xpos:Number = displayObject.x * pscl;
			var ypos:Number = displayObject.y * pscl;
			
			if (!noGraphic)
			{
				displayObject.stop();
				if (bMode)
				{
					//var bitmapGUI:Bitmap;
					bitmapGUI = new Bitmap(utilz.dpToBitmap(displayObject,0,true,0,0,scl));
					bitmapGUI.x = xpos;
					bitmapGUI.y = ypos;
					
					addChild(bitmapGUI);
					_bitmaps.push();
				}else{
					
				}
				bitmapGUI = new Bitmap(utilz.dpToBitmap(displayObject,0,true,0,0,scl));
				bitmapGUI.x = xpos;
				bitmapGUI.y = ypos;
				if (displayObject.parent)
					displayObject.parent.addChild(bitmapGUI);
				else
					addChild(bitmapGUI);
				_bitmaps.push();
			}else
			{
				
			}
			if (action != null)
			{
				var hotspot:Rectangle = new Rectangle(xpos,ypos,displayObject.width * scl,displayObject.height * scl);
				_buttons.push(hotspot);
				_buttonActions.push(action);
				_names.push(displayObject.name);
				_bCount++;
			}
			
			if (autoRemove)
			{
				if (displayObject.parent)
				{
					displayObject.parent.removeChild(displayObject);
				}
			}
			
			return bitmapGUI;
		}
		
		
		/**
		 * not sure if this would actually improve performance!
		 * */
		final protected function setupGUIText(tf:TextField):void
		{
			tf.x *= MobiAIR.globalScale;
			tf.y *= MobiAIR.globalScale;
			
			tf.autoSize = TextFieldAutoSize.LEFT;
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = tf.getTextFormat().font;
			tf.width *= MobiAIR.globalScale;
			tf.height *= MobiAIR.globalScale;
			textFormat.size = Number(tf.getTextFormat().size) * MobiAIR.globalScale;
			textFormat.color = tf.getTextFormat().color;
			
			tf.defaultTextFormat = textFormat;
			tf.setTextFormat(textFormat);
			
			/*
			if (bringToFront)
			{
				var depth:int = getChildIndex(tf);
				var num:int = numChildren;
				while (depth < num - 1)
				{
					swapChildrenAt(depth,depth + 1);
					depth++;
				}
				
			}
			*/
			
			tf.parent.removeChild(tf);
			addChild(tf);
			
			tf.cacheAsBitmap = true;
		}

	}
	
}
