package com.Ammarz.MobiAIR
{
	import com.Ammarz.MobiAIR.ScreenSystem.BaseScreen;
	import com.Ammarz.MobiAIR.ScreenSystem.ScreenController;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public final class MobiAIR
	{
		private static var _screenController:ScreenController;
		private static var _container:Sprite;
		private static var _globalScale:Number = 1;
		private static var _fps:FPSCounter;
		private static var _initCallback:Function;
		private static var _fpsText:TextField;
		public function MobiAIR()
		{
			
		}
		/**
		 * <h1>PhoneEngine.init()</h1>
		 * initializes the phone engine, should be called once during the app runtime
		 * 
		 * Example use:</br>
		 * <code>PhoneEngine.init(this);</code>
		 * @param stage the place to render stuff on, for example the main sprite
		 * @a function called after engine is done initializing (ex: set the start screen)
		*/
		public static function init(container:Sprite,initCallback:Function):void
		{
			_container = container;
			_container.stage.addEventListener(Event.ENTER_FRAME,initDelay);
			__initTimer = 30;
			_initCallback = initCallback;
		}
		
		private static function actualInit():void
		{
			_screenController = new ScreenController();
			_container.addChild(_screenController);
			_screenController.init();
			_fps = new FPSCounter();
			_fps.reset();
			_container.addEventListener(Event.ENTER_FRAME,update);
			_initCallback();
			_initCallback = null;
			keepFPSTextAtTop();
		}
		
		private static var __initTimer:int;
		private static function initDelay(event:Event):void
		{
			__initTimer--;
			if (__initTimer <= 0)
			{
				__initTimer = 0;
				_container.stage.removeEventListener(Event.ENTER_FRAME,initDelay);
				actualInit();
			}
		}
		
		
		public static function update(e:Event):void
		{
			_fps.update();
			_screenController.update(_fps.elapsed);
			if (_fpsText)
			{
				_fpsText.text = _fps.FPS.toString();
			}
		}
		
		/**
		 * switch the screen to another one, first it fades out, calls dispose on the old screen, calls init on the new screen, then fade in
		 * @param screen the new screen
		 * @param transitionSpeed 0 - 1 (I usually use 0.3)
		 * @param transitionSpeedIn if == 0 the new screen will fade in based on transitionSpeed, while if its > 0 the screen will fade in at that speed
		 * */
		public static function setScreen(screen:BaseScreen,transitionSpeed:Number = 0,transitionSpeedIn:Number = 0):void
		{
			_screenController.setScreen(screen,transitionSpeed,transitionSpeedIn);
		}
		
		/**
		 * sets the global scale of the game, useful when adapting different screen resolutions
		 * I don't suggest changing this after the game is running.
		 * */
		public static function set globalScale(v:Number):void
		{
			_globalScale = v;
		}
		public static function get globalScale():Number
		{
			return _globalScale;
		}
		
		public static function get stage():Stage
		{
			return _container.stage;
		}
		
		public static function get container():Sprite
		{
			return _container;
		}
		
		/**
		 * a shortcut that just multiplies the value passed by the globalScale and returns it
		 * */
		public static function applyScale(v:Number):Number
		{
			return v * _globalScale;
		}
		
		/**
		 * devides the value by globalScale 
		 * */
		public static function removeScale(v:Number):Number
		{
			return v / _globalScale;
		}
		
		/**
		 * shows text representing the screen fps at the specified position on the screen
		 * */
		public static function enableFPS(px:Number = 10,py:Number = 10):void
		{
			_fpsText = new TextField();
			_fpsText.defaultTextFormat = new TextFormat(null,applyScale(14),0xFFFFFF);
			_fpsText.autoSize = TextFieldAutoSize.LEFT;
			container.addChild(_fpsText);
		}
		
		public static function keepFPSTextAtTop():void
		{
			if (_fpsText)
			{
				container.removeChild(_fpsText);
				container.addChild(_fpsText);
			}
		}
	}
}