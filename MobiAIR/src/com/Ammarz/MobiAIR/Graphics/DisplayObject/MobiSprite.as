/*
	Animated sprite optimized for iOS
	Holds only one animation passed as a vector of BitmapData
	Hint:
	var myAnimation = utilz.mcToAnimation(myMC).bitmap;
	var mySprite:iPhoneSprite = new iPhoneSprite(myAnimation);
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
	
	/*
	todo:
	make it use Animation class rather than a victor
	unify it with the mirror version
	*/
	/**
	 * A Sprite object optimized to run on mobile devices (USE MobiSpriteM if you want to use mirroring)
	 * @see com.Ammarz.MobiEngine.Graphics.DisplayObject.MobiSpriteM
	 * */
	public class MobiSprite extends GameObject{

		private var _bitmaps:Vector.<BitmapData>;
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
		private var _backwards:Boolean;
		private var _callbackEnabled:Boolean;
		private var _callback:Function;
		private var _args:Object;
		
		public function MobiSprite(bitmap:Vector.<BitmapData>,speed:Number=1,cam:Camera=null,ix:int = 0,iy:int = 0,offset:Point = null,startFrame:int=0) {
			_speed = speed;
			_frame = 0;
			_frameTimer = 0;
			_width = bitmap[0].width;
			_height = bitmap[0].height;
			_bitmaps = bitmap;
			_cam = cam;
			if (cam)
			{
				_position = new Point(ix,iy);
			}else
			{
				x = ix;
				y = iy;
			}
			_numFrames = bitmap.length;
			_play = false;
			_visible = true;
			if (offset)
			{
				_offset = offset;
			}else
			{
				_offset = new Point();
			}
			
			bitmapData = bitmap[startFrame];

			update(0);
		}
		
		public function update(elapsed:Number = 1.0):void
		{
			//_rotation += _speed * 4;
			if (_play)
				_frameTimer += _speed * elapsed;
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
						if (_backwards)
							_frame = 0;
						else
							_frame = _numFrames - 1;
						_play = false;
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
							{
								_callback();
							}
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
							this.bitmapData = _bitmaps[_frame];
						}
					}else
					{
						this.visible = false;
					}
				}else
				{
					if (_oldFrame != _frame)
					{
						this.bitmapData = _bitmaps[_frame];
					}
				}
			}else
			{
				this.visible = false;
			}
			
			_oldFrame = _frame;
		}
		/*
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
		*/
		
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
		public function play(loops:Boolean = false,frame:int = -1,playBackwards:Boolean = false,enableCallback:Boolean = false):void
		{
			if (frame>-1)
			{
				_frame = frame;
			}
			_backwards = playBackwards;
			_play = true;
			_loop = loops;
			_callbackEnabled = enableCallback;
		}

		public function stop(frame:int = -1):void
		{
			if (frame>-1)
			{
				_frame = frame;
			}
			_play = false;
		}
		
		public function setCallback(callback:Function,args:Object=null,enableCallback:Boolean = true):void
		{
			_callback = callback;
			_args = args;
			_callbackEnabled = enableCallback;
		}
		
		final public function dispose():void
		{
			if (_bitmaps)
			{
				for each (var b:BitmapData in _bitmaps)
				{
					b.dispose();
				}
			}
		}
		
		final public function frameBitmaps():Vector.<BitmapData>
		{
			return _bitmaps;
		}
	}
	
}
