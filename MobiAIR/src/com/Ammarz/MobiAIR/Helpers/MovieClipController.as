package com.Ammarz.MobiAIR.Helpers
{
	import flash.display.MovieClip;
	
	
	/**
	 * a class that manually animate movieclips and adds some more functionality like custom speed, timer based frames, reverse, and from, to (frame)
	 **/
	public class MovieClipController
	{
		
		private var _movieClips:Vector.<MovieClip>;
		private var _frame:uint;
		private var _start:uint;
		private var _end:uint;
		private var _speed:Number;
		private var _loop:Boolean;
		private var _timer:Number;
		private var _play:Boolean;
		private var _reverse:Boolean;
		private var _len:uint;
		
		public function MovieClipController()
		{
			_movieClips = new Vector.<MovieClip>();
			_frame = 1;
			_len = 0;
		}
		
		/**
		 * adds a movieclip to the list, you can use it to control multiple movieclips at once
		 * */
		public function attachMovieClip(mc:MovieClip):void
		{
			trace("attach movie clip: " + mc.name);
			_len++;
			mc.gotoAndStop(_frame);
			_movieClips.push(mc);
		}
		
		/**
		 * remove a movieclip from the control list
		 * */
		public function detachMovieClip(mc:MovieClip):void
		{
			_len--;
			_movieClips.splice(_movieClips.indexOf(mc),1);
		}
		
		/**
		 * sets animation options
		 * @param loop duh!
		 * @param speed 1 = normal speed, 0.5 half the speed, 2 double the speed ... etc
		 * @param start specify which frame the animation start
		 * @param end the last frame before stopping or looping, 0 continues to the end of the movieclip
		 * */
		public function setAnimation(loop:Boolean = true,speed:Number = 1,start:uint = 1,end:uint = 0):void
		{
			trace("set animation: " + start.toString() + " , " + end.toString());
			_loop = loop;
			_speed = speed;
			_start = start;
			_frame = _start;
			updateFrames();
			if (end > 0)
				_end = end;
			else
				_len > 0 ? _end = _movieClips[0].framesLoaded : _end = 1;
		}
		
		
		/**
		 * play the animation
		 * @param setTo aka goto the specified frame then play normally, just like gotoAndPlay, 0 = just leave it alone and play
		 * @param resetTimer resets the frame timer, you would mostly keep it true
		 * */
		public function play(setTo:uint = 0,resetTimer:Boolean = true):void
		{
			if (setTo > 0)
			{
				updateFrames(setTo);
			}
			
			if (resetTimer)
			{
				_timer = 0;
			}
			
			_play = true;
		}
		
		public function stop(atFrame:uint = 0):void
		{
			_play = false;
			if (atFrame > 0){_frame = atFrame;}
			updateFrames();
		}
		
		private function updateFrames(frame:uint = 0):void
		{
			if (frame > 0)
				_frame = frame;
			
			for each (var m:MovieClip in _movieClips)
			{
				m.gotoAndStop(_frame);
			}
		}
		
		/**
		 * updates the timers and frame switching, call this every enter frame
		 * */
		public function update(elapsed:Number = 1):void
		{
			if (_play && _len > 0)
			{
				
				updateFrames();
				
				_timer += _speed * elapsed;
				while (_timer >= 1)
				{
					_timer--;
					_reverse ? _frame-- : _frame++;
					
					if (_loop)
					{
						if (_reverse)
						{
							if (_frame < _start)
								_frame = _end;
						}else
						{
							if (_frame > _end)
								_frame = _start;
						}
					}else
					{
						if (_reverse)
						{
							if (_frame < _start)
							{
								_frame = _start;
								_play = false;
							}
						}else
						{
							if (_frame > _end)
							{
								_frame = _end;
								_play = false;
							}
						}
					}
				}
			}
		}
		
		public function set frame(v:uint):void
		{
			_frame = v;
		}
		public function get frame():uint
		{
			return _frame;
		}
		
		public function set speed(v:uint):void
		{
			_speed = v;
		}
		public function get speed():uint
		{
			return _speed;
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