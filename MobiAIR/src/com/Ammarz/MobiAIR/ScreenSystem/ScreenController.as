package com.Ammarz.MobiAIR.ScreenSystem {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	
	public class ScreenController extends Sprite {
		
		/*
		todo:
		-make it statically accessable
		-make an overlay system which can handle infinite overlays
		-clean the code.
		*/

		private var _activeScreen:BaseScreen;
		private var _nextScreen:BaseScreen;
		private var _transition:Boolean;
		private var _transitionX:Number;
		private var _transitionSpeed:Number;
		private var _transitionSpeed2:Number;
		private var _transitionPhase:uint;
		private var _fader:Shape;
		private var _waitTimer:Number;
		private var _forcePause:Boolean;
		private var _lockControls:Boolean;
		public static var touchX:Number;
		public static var touchY:Number;
		public var autoFreeControls:Boolean;
		private var _touchScreenMode:Boolean;
		private var _useBackButton:Boolean;
		
		/**
		 * handles screen switching, transitions, input events ... and some other stuff
		 * @param touchScreenMode (int) which input mode to use <b>0: auto, 1:mouse, 2: touch screen</b>
		 * */
		final public function ScreenController(touchScreenMode:int = 0) {
			_lockControls = false;
			autoFreeControls = true;
			if (touchScreenMode == 0)
			{
				switch (Capabilities.os.substr(0,3))
				{
					case "Win":
					case "Mac":
						_touchScreenMode = false;
						break;
					default:
						_touchScreenMode = true;
				}
			}else if (touchScreenMode == 1) _touchScreenMode = false; else _touchScreenMode = true;
		}
		
		final public function setPause(v:Boolean):void
		{
			_forcePause = v;
		}
		
		final public function init():void
		{
			if (_touchScreenMode)
			{
				stage.addEventListener(TouchEvent.TOUCH_BEGIN,onTap);
				stage.addEventListener(TouchEvent.TOUCH_MOVE,onMove);
				stage.addEventListener(TouchEvent.TOUCH_END,onEnd);
			}else
			{
				stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
				stage.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
				stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
			}
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,kbButton);
			
			_forcePause = false;
			_fader = new Shape();
			_fader.graphics.beginFill(0);
			_fader.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			_fader.graphics.endFill();
			_fader.alpha = 0;
			
			_transitionX = 0;
		}
		
		protected function kbButton(event:KeyboardEvent):void
		{
			_activeScreen.handleAction(-1000,-1000,event.keyCode);
			if (!_useBackButton)
			{
				if (event.keyCode == Keyboard.BACK || event.keyCode == Keyboard.MENU)
				{
					event.preventDefault();
				}
			}
		}
		
		public function currentScreen():BaseScreen
		{
			return _activeScreen;
		}
		
		final private function mouseDown(event:MouseEvent):void
		{
			touchX = event.stageX; touchY = event.stageY;
			if (_activeScreen) if (!_forcePause) if (!_lockControls)
			_activeScreen.handleAction(mouseX,mouseY);
		}
		final private function mouseUp(event:MouseEvent):void
		{
			touchX = event.stageX; touchY = event.stageY;
			if (_activeScreen) if (!_forcePause) if (!_lockControls)
			_activeScreen.handleActionEnd(mouseX,mouseY);
		}
		
		final private function mouseMove(event:MouseEvent):void
		{
			touchX = event.stageX; touchY = event.stageY;
			if (_activeScreen) if (!_forcePause) if (!_lockControls)
			_activeScreen.handleMove(mouseX,mouseY);
		}
		
		
		final private function onTap(event:TouchEvent):void
		{
			touchX = event.stageX; touchY = event.stageY;
			if (_activeScreen) if (!_forcePause) if (!_lockControls)
			_activeScreen.handleAction(event.stageX,event.stageY);
		}
		final private function onEnd(event:TouchEvent):void
		{
			touchX = event.stageX; touchY = event.stageY;
			if (_activeScreen) if (!_forcePause) if (!_lockControls)
			_activeScreen.handleActionEnd(event.stageX,event.stageY);
		}
		final private function onMove(event:TouchEvent):void
		{
			touchX = event.stageX; touchY = event.stageY;
			if (_activeScreen) if (!_forcePause) if (!_lockControls)
			_activeScreen.handleMove(event.stageX,event.stageY);
		}
		
		final public function set lockControls(v:Boolean):void
		{
			_lockControls = v;
		}
		
		final public function get lockControls():Boolean
		{
			return _lockControls;
		}
		
		final public function setScreen(newScreen:BaseScreen,transitionSpeed:Number = 0,transitionSpeedIn:Number = 0):void
		{
			if (_transition)
			{
				return;
			}
			if (autoFreeControls)
				_lockControls = false;
			
			if (_activeScreen)
			{
				if (transitionSpeed > 0)
				{
					if (transitionSpeedIn == 0)
						_transitionSpeed2 = transitionSpeed;
					else
						_transitionSpeed2 = transitionSpeedIn;
					
					_nextScreen = newScreen;
					_transition = true;
					_transitionPhase = 1;
					_transitionX = 0;
					_transitionSpeed = transitionSpeed;
					_fader.alpha = 0;
					addChild(_fader);
				}else
				{
					_transitionSpeed = 0;
					_transitionSpeed2 = 0;
					_activeScreen.dispose();
					removeChild(_activeScreen);
					_activeScreen = newScreen;
					_activeScreen.init();
					addChild(_activeScreen);
				}
			}else
			{
				_activeScreen = newScreen;
				_activeScreen.init();
				addChild(_activeScreen);
				_activeScreen.x = 1;
				_activeScreen.x = 0;
				_activeScreen.visible = true;
			}
		}
		
		final public function runCommand(com:String,args:Vector.<String> = null):void
		{
			_activeScreen.runCommand(com,args);
		}
		
		/**
		 * updates the game
		 * @param elapsed the ratio between the time pased since the last frame and how it's supposed to be, or just leave it as 1 if you're lazy.
		 * @default 1
		 * @see com.Ammarz.PhoneEngine.FPSCounter
		 **/
		final public function update(elapsed:Number = 1):void
		{
			if (!_activeScreen)
			{
				return;
			}
			if (!_transition)
			{
				if (!_forcePause)
				_activeScreen.update(elapsed);
			}else
			{
				if (_transitionPhase == 1)
				{
					if (_transitionX >= 1)
					{
						_transitionX = 1;
						_transitionPhase = 2;
						removeChild(_activeScreen);
						_activeScreen.dispose();
						_activeScreen = _nextScreen;
						_nextScreen = null;
						_activeScreen.init();
						addChild(_activeScreen);
						this.swapChildren(_activeScreen,_fader);
						_waitTimer = 0;
					}else
					{
						_transitionX += _transitionSpeed * elapsed;
					}
				}else if(_transitionPhase == 2)
				{
					_waitTimer += elapsed;
					if (_waitTimer > 30)
					{
						_transitionPhase = 3;
					}
				}else if (_transitionPhase == 3)
				{
					if (_transitionX <= 0)
					{
						_transitionX = 0;
						_transitionPhase = 0;
						_transition = false;
						removeChild(_fader);
						_activeScreen.visible = true;
					}else
					{
						_transitionX -= _transitionSpeed2 * elapsed;
					}
				}
				_fader.alpha = _transitionX;
				
			}
		}

	}
	
}
