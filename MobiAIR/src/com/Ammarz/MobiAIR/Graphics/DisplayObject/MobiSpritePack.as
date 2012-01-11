

/*
	Animated sprite optimized for iOS, Does not handle mirrors, use iSpritePackM instead
	Holds multiple animations
	pass animations as AnimationPackage
	hint:
	_animPack = new AnimationPackage();
	_animPack.addAnimation(utilz.mcToAnimation(new myAnimatedMovieClip1()),"Anim1");
	_animPack.addAnimation(utilz.mcToAnimation(new myAnimatedMovieClip2()),"Anim2");
	_animPack.addAnimation(utilz.mcToAnimation(new myAnimatedMovieClip3()),"Anim3");
	... etc
*/


package com.Ammarz.MobiAIR.Graphics.DisplayObject {
	import com.Ammarz.MobiAIR.Camera;
	import com.Ammarz.MobiAIR.GameObject;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.Ammarz.MobiAIR.Graphics.Animation;
	import com.Ammarz.MobiAIR.Graphics.AnimationPackage;
	
	/**
	 * A Sprite object that can hold multiple animations
	 * 
	 * (USE MobiSpritePackM if you want to use mirroring)
	 * @see com.Ammarz.MobiEngine.Graphics.DisplayObject.MobiSpritePackM
	 * @see com.Ammarz.MobiEngine.Graphics.AnimationPackage
	 * */
	public class MobiSpritePack extends GameObject{

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
		private var _anim:Animation;
		private var _currentAnimID:int;
		private var _backwards:Boolean;
		private var _callbackEnabled:Boolean;
		private var _callback:Function;
		private var _args:Object;
		
		
		/**
		 * @param AnimPack the animation package which contains a group of Animations
		 * @param speed animation speed (1: full speed, 0.5: half speed, 2: double the speed)
		 * @param cam just don't use this for now!
		 * @param ix don't use
		 * @param iy don't use
		 * @param don't use
		 * 
		 * */
		public function MobiSpritePack(animPack:AnimationPackage,cam:Camera=null,ix:int = 0,iy:int = 0) {
			super();
			_speed = 1;
			_frame = 0;
			_frameTimer = 0;
			_animationPack = animPack;
			_width = _animationPack.animations[0].bitmap[0].width;
			_height = _animationPack.animations[0].bitmap[0].height;
			_cam = cam;
			_backwards = false;
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
			_currentAnimID = 0;
			
			update(0);
		}
		
		public function update(gameSpeed:Number = 1.0):void
		{
			//_rotation += _speed * 4;
			if (_play)
				_frameTimer += _anim.speed * gameSpeed;
			while (_frameTimer >= 1)
			{
				if (_backwards)
					_frame--;
				else
					_frame++;
				
				if (_frame >= _numFrames || _frame < 0)
				{
					if (_loop)
					{
						if (_backwards)
							_frame = _numFrames - 1;
						else
							_frame = 0;
					}else
					{
						if (_anim.returnTo >= 0)
						{
							setAnim(_anim.returnTo,true,0);
						}else
						{
							if (_backwards)
								_frame = 0;
							else
								_frame = _numFrames - 1;
							_play = false;
						}
					}
					if (_callbackEnabled)
					{
						if (_callback != null)
						{
							if (_args)
							{
								_callback(_args);
							}
							else
								_callback();
						}
					}
				}
				_frameTimer -= 1;
			}
			/*
			//Handle negative speed ... not needed after _backward:boolean
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
			*/
			
			if (_visible)
			{
				if (_cam)
				{
					if (_position.x + _offset.x + _width > _cam.x && _position.x + _offset.x < _cam.rect.right)
					{
						if (_position.y + _offset.y + _height > _cam.y && _position.y + _offset.y < _cam.rect.bottom)
						{
							this.visible = true;
						}else
						{
							this.visible = false;
						}
						
						x = _position.x - _cam.x + _offset.x;
						y = _position.y - _cam.y + _offset.y;
						
						if (_oldFrame != _frame)
						{
							this.bitmapData = _currentAnim[_frame];
						}
					}else
					{
						this.visible = false;
					}
				}else
				{
					if (_oldFrame != _frame)
					{
						this.bitmapData = _currentAnim[_frame];
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
		public function get animID():int
		{
			return _currentAnimID;
		}
		public function get isPlaying():Boolean
		{
			return _play;
		}
		
		public function get numFrames():uint
		{
			return _numFrames;
		}
		
		public function set backwards(v:Boolean):void
		{
			_backwards = v;
		}
		public function get backwards():Boolean
		{
			return _backwards;
		}
		public function set callbackEnabled(v:Boolean):void
		{
			_callbackEnabled = v;	
		}
		public function get callbackEnabled():Boolean
		{
			return _callbackEnabled;
		}
		public function set callback(f:Function):void
		{
			_callback = f;
		}
		public function get callback():Function
		{
			return _callback;
		}
		public function set callbackArgs(args:Object):void
		{
			_args = args;
		}
		public function get callbackArgs():Object
		{
			return _args;
		}
		public function play(frame:int = -1,playBackwards:Boolean = false):void
		{
			if (frame>-1)
			{
				_frame = frame;
			}
			_backwards = playBackwards;
			_play = true;
		}
		public function stop(frame:int = -1):void
		{
			if (frame>-1)
			{
				_frame = frame;
			}
			_frameTimer = 0;
			_play = false;
		}
		
		public function setAnim(id:int,autoPlay:Boolean = true,frame:int = 0):void
		{
			_anim = _animationPack.animations[id];
			_currentAnimID = id;
			_currentAnim = _anim.bitmap;
			_offset = _anim.offset;
			_loop = _anim.loop;
			_play = autoPlay;
			_frame = frame;
			_oldFrame = -1;
			_numFrames = _currentAnim.length;
			bitmapData = _currentAnim[_frame];
		}
		
		public function setByName(name:String,autoPlay:Boolean = true,frame:int = 0,playBackwards:Boolean = false,callbackEnabled:Boolean = false):void
		{
			_anim = _animationPack.byName(name);
			_currentAnimID = _animationPack.animations.indexOf(_anim);
			_currentAnim = _anim.bitmap;
			_offset = _anim.offset;
			_loop = _anim.loop;
			_play = autoPlay;
			_frame = frame;
			_oldFrame = -1;
			_frameTimer = 0;
			_numFrames = _currentAnim.length;
			_backwards = playBackwards;
			_callbackEnabled = callbackEnabled;
			bitmapData = _currentAnim[_frame];
		}
		
		public function setCallback(callback:Function,args:Object=null,enableCallback:Boolean = true):void
		{
			_callback = callback;
			_args = args;
			_callbackEnabled = enableCallback;
		}
		
		public function dispose():void
		{
			_anim = null;
			_currentAnim = null;
			_animationPack.dispose();
			_animationPack = null;
		}
	}
	
}
