package com.Ammarz.MobiAIR.Graphics.BlitSprite_WIP {
	import com.Ammarz.MobiAIR.Camera;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class AnimatedSprite {

		internal var _bitmap:BitmapData;
		internal var _canvas:BitmapData;
		internal var _speed:Number;
		internal var _position:Point;
		internal var _frame:int;
		internal var _frameTimer:Number;
		internal var _numFrames:int;
		internal var _height:int;
		internal var _width:int;
		internal var _rect:Rectangle;
		internal var _mixAlpha:Boolean = true;
		internal var _rotation:Number;
		internal var _cam:Camera;
		internal var _isInsideCam:Boolean;
		internal var _offset:Point;
		internal var _mirrorBD:BitmapData;
		internal var _mirrorEnabled:Boolean;
		internal var _mirror:Boolean;
		internal var _mOffset:Point;
		internal var _play:Boolean;
		private var _temp:int;
		internal var _masterSpeed:Number;
		private var _loop:Boolean;
		private var _intPos:Point;
		
		public function AnimatedSprite(cam:Camera,bitmap:BitmapData,width:int,height:int,speed:Number,canvas:BitmapData,play:Boolean=false,x:Number = 0,y:Number = 0,numFrames:int = 0,offset:Point=null,mirrorBD:BitmapData = null) {
			_bitmap = bitmap;
			_canvas = canvas;
			_speed = speed;
			_position = new Point(x,y);
			_frame = 0;
			_frameTimer = 0;
			_width = width;
			_height = height;
			_mixAlpha = true;
			_rotation = 0;
			_cam = cam;
			_offset = new Point();
			_play = play;
			_masterSpeed = 1;
			_loop = true;
			_intPos = new Point();
			
			
			if (offset == null)
			{
				_offset = new Point();
			}else
			{
				_offset = offset;
			}
			
			if (numFrames == 0)
			{
				_numFrames = bitmap.width / width;
			}

			_rect = new Rectangle(0,0,_width,_height);
			
			if (mirrorBD != null)
			{
				_mirrorEnabled = true;
				_mirrorBD = mirrorBD;
				_mirror = false;
				_mOffset = new Point(offset.x * -1,offset.y);
			}else
			{
				_mirror = false;
				_mirrorEnabled = false;
			}
		}
		
		public function update(gameSpeed:Number = 1.0):void
		{
			_frameTimer += _speed * gameSpeed * _masterSpeed;
			
			if (_play)
			{
				while (_frameTimer >= 1)
				{
					_frame++;
					if (_frame >= _numFrames)
					{
						if (_loop)
						{
							_frame = 0;
						}else
						{
							_frame = _numFrames - 1;
							_play = false;
						}
					}
					_frameTimer -= 1;
				}
				while (_frameTimer < 0)
				{
					_frame--;
					if (_frame < 0)
					{
						_frame = _numFrames - 1;
					}
					_frameTimer += 1;
				}
			}
			
			
			if (insideCam())
			{
				if (_mirror)
				{
					_intPos.x = Math.round(_position.x);
					_intPos.y = Math.round(_position.y);
					_rect.x = (_numFrames - _frame - 1) * _width;
					_canvas.copyPixels(_mirrorBD,_rect,_position.subtract(_cam.point).add(_offset),null,null,_mixAlpha);
				}else
				{
					_intPos.x = Math.round(_position.x);
					_intPos.y = Math.round(_position.y);
					_rect.x = _frame * _width;
					_canvas.copyPixels(_bitmap,_rect,_position.subtract(_cam.point).add(_offset),null,null,_mixAlpha);
				}
			}
		}
		
		
		public function get x():Number
		{
			return _position.x;
		}
		public function set x(v:Number):void
		{
			_position.x = v;
		}
		public function get y():Number
		{
			return _position.y;
		}
		public function set y(v:Number):void
		{
			_position.y = v;
		}
		
		public function set frameSpeed(v:Number):void
		{
			_speed = v;
		}
		public function get frameSpeed():Number
		{
			return _speed;
		}
		
		private function insideCam():Boolean
		{
			if (_mirror)
			{
				_temp = _offset.x;
			}else
			{
				_temp = -_offset.x;
			}
			if (_position.x + _temp <= _cam.rect.right && _position.x + _width + _temp >= _cam.rect.x)
			{
				if (_position.y <= _cam.rect.bottom && _position.y - _height >= _cam.rect.y)
				{
					_isInsideCam = true;
					return true;
				}
			}
			
			_isInsideCam = false;
			return false;
		}
		
		public function get isInsideCam():Boolean
		{
			return _isInsideCam;
		}
		
		public function set mirror(v:Boolean):void
		{
			if (!_mirrorEnabled)
			{
				return;
			}
			_mirror = v;
		}
		
		public function get mirror():Boolean
		{
			return _mirror;
		}
		
		public function set play(v:Boolean):void
		{
			_play = v;
		}
		
		public function get play():Boolean
		{
			return _play;
		}
		
		public function set frame(v:int):void
		{
			if (v >= _numFrames)
			{
				v = _numFrames - 1;
			}
			if (v < 0)
			{
				v = 0;
			}
			_frame = 0;
			_frameTimer = 0;
		}
		public function get frame():int
		{
			return _frame;
		}
		
		public function set loop(v:Boolean):void
		{
			_loop = v;
		}
		
		public function get loop():Boolean
		{
			return _loop;
		}
	}
	
}
