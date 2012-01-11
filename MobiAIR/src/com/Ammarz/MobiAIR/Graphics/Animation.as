package com.Ammarz.MobiAIR.Graphics
{
	import com.Ammarz.MobiAIR.utilz;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class Animation
	{
		public var bitmap:Vector.<BitmapData>;
		public var bitmapM:Vector.<BitmapData>;
		public var speed:Number;
		public var loop:Boolean;
		public var returnTo:int;
		public var offset:Point;
		
		public function Animation(bd:Vector.<BitmapData>,width:int,height:int,pSpeed:Number=1,pLoop:Boolean=false,pOffset:Point = null,ret:int=-1)
		{	
			bitmap = bd;
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
		
		public function setMirror(bd:Vector.<BitmapData>):void
		{
			bitmapM = bd;
		}
		
		public function createMirror():void
		{
			bitmapM = new Vector.<BitmapData>();
			for each (var b:BitmapData in bitmap)
			{
				bitmapM.push(utilz.mirrorBitmap(b));
			}
		}
		
		public function dispose():void
		{
			var i:int;
			for (i=0;i<bitmap.length;i++)
			{
				bitmap[i].dispose();
				if (bitmapM)
					bitmapM[i].dispose();
			}
		}
	}
}