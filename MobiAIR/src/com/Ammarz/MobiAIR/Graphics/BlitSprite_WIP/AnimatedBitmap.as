package com.Ammarz.MobiAIR.Graphics.BlitSprite_WIP
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class AnimatedBitmap extends Bitmap
	{
		private var _bitmapData:Vector.<BitmapData>;
		private var _frame:int;
		private var _numFrames:uint;
		
		public function AnimatedBitmap(bitmapData:BitmapData=null)
		{
			super(bitmapData);
			_bitmapData = new Vector.<BitmapData>();
			_bitmapData.push(bitmapData);
			if (bitmapData)
			{
				_frame = 0;
				_numFrames = 1;
			}else
			{
				_frame = 0;
				_numFrames = 0;
			}
			
		}
		
		public function addFrame(bitData:BitmapData):void
		{
			_numFrames++;
			_bitmapData.push(bitData);
			if (!bitmapData)
			{
				bitmapData = bitData;
			}
		}
		
		public function setFrame(frameIndex:uint):void
		{
			if (_frame == frameIndex)
			{
				return;
			}
			if (frameIndex <= _bitmapData.length - 1)
			{
				_frame = frameIndex;
				bitmapData = _bitmapData[_frame];
			}
		}
		
		public function get numFrames():uint
		{
			return _numFrames;
		}
		
		
	}
}