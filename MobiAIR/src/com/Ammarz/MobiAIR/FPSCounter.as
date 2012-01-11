package com.Ammarz.MobiAIR
{
	import flash.display.Sprite;
	import flash.utils.getTimer;

	/**
	 * a helper class to calculate frame elapsed time and FPS 
	 * @exampleText and here's how to use it
	 * <listing version="3.0">
	 * private var _fpsCounter:FPSCounter;
	 * public function init():void
	 * {
	 *	_fpsCounter = new FPSCounter();
	 * }
	 * public function onEnterFrame(e:Event):void
	 * {
	 * _fpsCounter.update();
	 * _yourBall.x += ballSpeed * _fpsCounter.elapsed;
	 * }
	 * </listing>
	 * ASDocs is F***ing stupid!
	 **/
	public class FPSCounter
	{
		//private var _parent:Sprite;
		private var _currentTimer:int;
		private var _prevTime:int;
		private var _speed:Number;
		private var _fps:int;
		
		public static var elapsed:Number;
		
		
		final public function FPSCounter()
		{
			
		}
		
		/**
		 * calculates fps and elapsed time
		 * put at the start of a loop 
		 **/
		final public function update():void
		{
			_currentTimer = getTimer();
			_speed = (_currentTimer - _prevTime)/30;
			_fps = 1000 / (_currentTimer - _prevTime);
			_prevTime = _currentTimer;
		}
		
		final public function reset():void
		{
			_prevTime = getTimer();
		}
		
		/**
		 * returns the ratio of the time passed since the previous frame and the time it was supposed to, multiply your motion and timing math with this to maintain smooth animations if the FPS is low.
		 * it should return a number close to 1 if the FPS is noraml, the number will increase on lower FPS thus increasing the speed of your animations to make up for the lower FPS.
		 **/
		
		final public function get elapsed():Number
		{
			return _speed;
		}
		
		/**
		 * returns FPS (frames per second) for debuging reasons
		 **/
		final public function get FPS():int
		{
			return _fps;
		}
		
	}
}