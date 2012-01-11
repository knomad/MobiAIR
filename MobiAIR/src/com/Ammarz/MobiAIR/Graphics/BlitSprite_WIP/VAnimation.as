package com.Ammarz.MobiAIR.Graphics.BlitSprite_WIP
{
	import com.Ammarz.MobiAIR.utilz;
	
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class VAnimation
	{
		public var bitmap:Vector.<BitmapData>;
		public var bitmapM:Vector.<BitmapData>;
		public var speed:Number;
		public var loop:Boolean;
		public var returnTo:int;
		public var offset:Point;
		
		
		public function VAnimation(bd:Vector.<BitmapData>,pSpeed:Number=1,pLoop:Boolean=false,pOffset:Point = null,ret:int=-1,makeMirror:Boolean=false)
		{
			bitmap = utilz.splitBitmap(bd,width,height);
			
			if (makeMirror)
			{
				bitmapM = utilz.splitBitmapM(bd,width,height);
			}
			
			loop = pLoop;
			speed = pSpeed;
			returnTo = ret;
			if (pOffset)
			{
				offset = pOffset;
			}else
			{
				offset = new Point();
			}
		}
		
		public function dispose():void
		{
			var i:int;
			for (i=0;i<bitmap.length;i++)
			{
				bitmap[i].dispose();
				bitmapM[i].dispose();
			}
		}
	}
}