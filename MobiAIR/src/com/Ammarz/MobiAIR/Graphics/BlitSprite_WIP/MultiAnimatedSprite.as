package com.Ammarz.MobiAIR.Graphics.BlitSprite_WIP
{
	import com.Ammarz.MobiAIR.Camera;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class MultiAnimatedSprite
	{
		private var _sprites:Vector.<AnimatedSprite>;
		private var _dict:Dictionary;
		private var _mirrored:Boolean;
		private var _play:Boolean;
		private var _cam:Camera;
		private var _canvas:BitmapData;
		private var _newSprite:AnimatedSprite;
		private var _x:Number;
		private var _y:Number;
		private var _masterSpeed:Number;
		private var _currentSprite:int;
		private var _sprSTR:String;
		
		public function MultiAnimatedSprite(cam:Camera,canv:BitmapData,play:Boolean,x:int=0,y:int=0,speed:Number = 1,loop:Boolean = true)
		{
			_sprites = new Vector.<AnimatedSprite>();
			_dict = new Dictionary();
			_cam = cam;
			_canvas = canv;
			_play = play;
			_x = x;
			_y = y;
			_masterSpeed = speed;
		}
		
		public function addAnimation(name:String,bitmap:BitmapData,width:int,height:int,speed:Number,numFrames:int = 0,offset:Point=null,mirrorBD:BitmapData = null,loop:Boolean = true):void
		{
			_newSprite = new AnimatedSprite(_cam,bitmap,width,height,speed,_canvas,_play,_x,_y,numFrames,offset,mirrorBD);
			_newSprite.x = _x;
			_newSprite.y = _y;
			_newSprite.loop = loop;
			_sprites.push(_newSprite);
			_dict[name] = _sprites.length - 1;
			if (_sprites.length == 1)
			{
				_currentSprite = 0;
				_sprSTR = name;
				//update(0);
			}
		}
		
		public function setAnimation(id:String,play:Boolean=false,frame:int=0):void
		{
			_play = play;
			_currentSprite = _dict[id];
			_sprites[_currentSprite].frame = 0;
			_sprites[_currentSprite].play = play;
			_sprites[_currentSprite].x = _x;
			_sprites[_currentSprite].y = _y;
			_sprSTR = id;
		}
		
		public function setAnimationC(id:String,play:Boolean=false,frame:int=0):void
		{
			if (id == _sprSTR)
			{
				return;
			}
			
			_play = play;
			_currentSprite = _dict[id];
			_sprites[_currentSprite].frame = 0;
			_sprites[_currentSprite].play = play;
			_sprites[_currentSprite].x = _x;
			_sprites[_currentSprite].y = _y;
			_sprSTR = id;
		}
		
		public function update(gameSpeed:Number):void
		{
			_sprites[_currentSprite].mirror = _mirrored;
			_sprites[_currentSprite]._masterSpeed = _masterSpeed;
			_sprites[_currentSprite].update(gameSpeed);
		}
		
		public function set play(v:Boolean):void
		{
			if (_sprites.length == 0)
			{
				return;
			}else
			{
				_sprites[_currentSprite].play = v;
			}
		}
		
		public function  get play():Boolean
		{
			if (_sprites.length == 0)
			{
				return false;
			}
			
			return _sprites[_currentSprite].play;
		}
		
		public function set x(v:Number):void
		{
			_x = v;
			_sprites[_currentSprite].x = v;
		}
		public function get x():Number
		{
			return _x;
		}
		public function set y(v:Number):void
		{
			_y = v;
			_sprites[_currentSprite].y = v;
		}
		public function get y():Number
		{
			return _y;
		}
		public function set speed(v:Number):void
		{
			_masterSpeed = v;
		}
		public function get speed():Number
		{
			return _masterSpeed;
		}
		public function set mirror(v:Boolean):void
		{
			_mirrored = v;
		}
		public function get mirror():Boolean
		{
			return _mirrored;
		}
		
	}
}