package com.GameHelpers
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.MouseEvent;

	public class UserInput
	{
		private static var INSTANCE:UserInput;
		private const CHECK_RANGE:int = 222;
		private var _stage:Stage;
		private var _keys:Vector.<Boolean>;
		private var _oldKeys:Vector.<Boolean>; // used to detect key Presses and releases
		private var _mouse:Boolean;
		private var _oldMouse:Boolean;
		
		private static var LOCK:Boolean;
		
		//Pass the stage to this from a display object
		public function UserInput(stage:Stage)
		{
			INSTANCE = this;
			_stage = stage;
			_stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			_stage.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			_stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			_keys = new Vector.<Boolean>();
			_oldKeys = new Vector.<Boolean>();
			
			_mouse = false;
			_oldMouse = false;
			
			var i:int;
			for (i = 0 ; i < CHECK_RANGE ; i++)
			{
				_keys.push(false);
				_oldKeys.push(false);
			}
		}
		
		public static function Init(stage:Stage):void
		{
			if (!INSTANCE)
			{
				LOCK = true;
				INSTANCE = new UserInput(stage);
			}
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			_keys[event.keyCode] = true;
		}
		private function keyUpHandler(event:KeyboardEvent):void
		{
			_keys[event.keyCode] = false;
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			trace("mouse down");
			_mouse = true;
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			_mouse = false;
		}
		
		//MUST be called at the end of loop that checks for user input in case of Pressed and Released checks
		private function Update():void
		{
			var i:int;
			for (i=0;i<CHECK_RANGE;i++)
			{
				_oldKeys[i] = _keys[i];
			}
			_oldMouse = _mouse;
		}
		
		//checks if a key is just pressed...
		private function Pressed(key:uint):Boolean
		{
			if (_keys[key] && !_oldKeys[key])
			{
				LOCK = false;
				return true;
			}
			else
				return false;
		}
		
		//checks if a key is just pressed...
		private function Released(key:uint):Boolean
		{
			if (!_keys[key] && _oldKeys[key])
				return true;
			else
				return false;
		}
		
		//checks if a key is being pressed...
		private function IsDown(key:uint):Boolean
		{
			return _keys[key];
		}
		
		private function get MouseDown():Boolean
		{
			return _mouse;
		}
		
		private function get MouseReleased():Boolean
		{
			if (!_mouse && _oldMouse)
			{
				return true;
			}else
			{
				return false;
			}
		}
		private function get MousePressed():Boolean
		{
			if (_mouse && !_oldMouse)
			{
				LOCK = false;
				return true;
			}else
			{
				return false;
			}
		}
		
		private function get mouseX():Number
		{
			return _stage.mouseX;
		}
		
		private function get mouseY():Number
		{
			return _stage.mouseY;
		}
		
		
		//Static functions: =============================================
		public static function Update():void
		{
			INSTANCE.Update();
		}
		
		//checks if a key is just pressed...
		public static function Pressed(key:uint):Boolean
		{
			return INSTANCE.Pressed(key);
		}
		
		//checks if a key is just pressed...
		public static function Released(key:uint):Boolean
		{
			return INSTANCE.Released(key);
		}
		
		//checks if a key is being pressed...
		public static function IsDown(key:uint):Boolean
		{
			return INSTANCE.IsDown(key);
		}
		
		public static function get MouseDown():Boolean
		{
			return INSTANCE._mouse;
		}
		
		public static function get MouseReleased():Boolean
		{
			return INSTANCE.MouseReleased;
		}
		public static function get MousePressed():Boolean
		{
			return INSTANCE.MousePressed;
		}
		
		public static function get mouseX():Number
		{
			return INSTANCE._stage.mouseX;
		}
		
		public static function get mouseY():Number
		{
			return INSTANCE._stage.mouseY;
		}
		
		public static function reset():void
		{
			var i:int;
			for (i = 0 ; i < INSTANCE.CHECK_RANGE ; i++)
			{
				INSTANCE._keys[i] = false;
				INSTANCE._oldKeys[i] = false;
			}
			INSTANCE._mouse = false;
			INSTANCE._oldMouse = false;
			LOCK = true;
		}
	}
	
}