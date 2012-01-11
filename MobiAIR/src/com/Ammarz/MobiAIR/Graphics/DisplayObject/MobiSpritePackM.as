package com.Ammarz.MobiAIR.Graphics.DisplayObject {
	import com.Ammarz.MobiAIR.Camera;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.Ammarz.MobiAIR.GameObject;
	import com.Ammarz.MobiAIR.Graphics.Animation;
	import com.Ammarz.MobiAIR.Graphics.AnimationPackage;
	
	public class MobiSpritePackM extends GameObject{

		private var _animationPack:AnimationPackage;
		//private var thiss:Vector.<Bitmap>;
		//private var this:Bitmap;
		private var _speed:Number;
		private var _oldFrame:int;
		private var _frame:int;
		private var _frameTimer:Number;
		private var _numFrames:int;
		private var _height:int;
		private var _width:int;
		private var _rotation:Number;
		private var _cam:Camera;
		private var _position:Point;
		private var _play:Boolean;
		private var _visible:Boolean;
		private var _offset:Point;
		private var _loop:Boolean;
		private var _currentAnim:Vector.<BitmapData>;
		private var _currentAnimM:Vector.<BitmapData>;
		private var _anim:Animation;
		private var _mOffset:int;
		private var _hWidth:Number;
		private var _mirrored:Boolean;
		
		
		// Animated sprite optimized for iPhone and works great on all other devices
		// this sprite does not mirror or rotate or scale
		public function MobiSpritePackM(animPack:AnimationPackage,speed:Number,cam:Camera=null,ix:int = 0,iy:int = 0) {
			super();
			_speed = speed;
			_frame = 0;
			_frameTimer = 0;
			_animationPack = animPack;
			_width = _animationPack.animations[0].bitmap[0].width;
			_hWidth = Math.round(_width / 2);
			_height = _animationPack.animations[0].bitmap[0].height;
			_cam = cam;
			if (cam)
			{
				_position = new Point(ix,iy);
			}else
			{
				x = ix;
				y = iy;
			}
			_currentAnim = _animationPack.animations[0].bitmap;
			_numFrames = _currentAnim.length;
			_anim = _animationPack.animations[0];
			_play = false;
			_visible = true;
			_offset = _animationPack.animations[0].offset;
			_loop = _animationPack.animations[0].loop;
			_oldFrame = -1;
			_mOffset = _offset.x;
			
			update(0);
		}
		
		public function update(gameSpeed:Number = 1.0):void
		{
			//_rotation += _speed * 4;
			if (_play)
				_frameTimer += _anim.speed * gameSpeed;
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
						if (_anim.returnTo >= 0)
						{
							setAnim(_anim.returnTo,true,0);
						}else
						{
							_frame = _numFrames - 1;
							_play = false;
						}
					}
				}
				_frameTimer -= 1;
			}
			
			while (_frameTimer < 0)
			{
				_frame--;
				if (_frame < 0)
				{
					if (_loop)
					{
						_frame = _numFrames - 1;
					}else
					{
						_frame = 0;
						_play = false;
					}
				}
				_frameTimer += 1;
			}
			if (_visible)
			{
				if (_cam)
				{
					if (_mirrored)
					{
						_mOffset = -(_hWidth + _offset.x + _hWidth);
					}else
					{
						_mOffset= _offset.x;
					}
					if (_position.x + _mOffset + _width > _cam.x && _position.x + _mOffset < _cam.rect.right)
					{
						if (_position.y + _offset.y + _height > _cam.y && _position.y + _offset.y < _cam.rect.bottom)
						{
							this.visible = true;
						}else
						{
							this.visible = false;
						}
						
						x = _position.x - _cam.x + _mOffset;
						y = _position.y - _cam.y + _offset.y;
						
						if (_oldFrame != _frame)
						{
							if (_mirrored)
							{
								this.bitmapData = _currentAnimM[_frame];
							}else
							{
								this.bitmapData = _currentAnim[_frame];
							}
						}
					}else
					{
						this.visible = false;
					}
				}else
				{
					if (_oldFrame != _frame)
					{
						if (_mirrored)
						{
							this.bitmapData = _currentAnimM[_frame];
						}else
						{
							this.bitmapData = _currentAnim[_frame];
						}
					}
				}
			}else
			{
				this.visible = false;
			}
			_oldFrame = _frame;
		}
		
		public function get X():int
		{
			return _position.x;
		}
		public function set X(v:int):void
		{
			_position.x = v;
		}
		public function get Y():int
		{
			return _position.y;
		}
		public function set Y(v:int):void
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
		public function set frame(v:int):void
		{
			if (v > 0 && v < _numFrames)
			{
				_frame = v;
			}
		}
		public function get frame():int
		{
			return _frame;
		}
		public function get isPlaying():Boolean
		{
			return _play;
		}
		public function play(frame:int = -1):void
		{
			if (frame>-1)
			{
				_frame = frame;
			}
			_play = true;
		}
		public function stop(frame:int = -1):void
		{
			if (frame>-1)
			{
				_frame = frame;
			}
			_play = false;
		}
		public function setAnim(id:int,autoPlay:Boolean = true,frame:int = 0):void
		{
			_anim = _animationPack.animations[id];
			_currentAnim = _anim.bitmap;
			_currentAnimM = _anim.bitmapM;
			_offset = _anim.offset;
			_loop = _anim.loop;
			_play = autoPlay;
			_frame = frame;
			_oldFrame = -1;
			_numFrames = _currentAnim.length;
			_width = _currentAnim[0].width;
			_hWidth = Math.round(_width / 2);
			_height = _currentAnim[0].height;
		}
		
		public function setByName(name:String,autoPlay:Boolean = true,frame:int = 0):void
		{
			_anim = _animationPack.byName(name);
			_currentAnim = _anim.bitmap;
			_currentAnimM = _anim.bitmapM;
			_offset = _anim.offset;
			_loop = _anim.loop;
			_play = autoPlay;
			_frame = frame;
			_oldFrame = -1;
			_numFrames = _currentAnim.length;
			_width = _currentAnim[0].width;
			_hWidth = Math.round(_width / 2);
			_height = _currentAnim[0].height;
		}
		public function get mirror():Boolean
		{
			return _mirrored;
		}
		public function set mirror(v:Boolean):void
		{
			_mirrored = v;
		}
	}
	
}
