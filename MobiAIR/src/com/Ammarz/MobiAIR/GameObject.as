package com.Ammarz.MobiAIR {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class GameObject extends Bitmap {

		internal var _collisionBox:Rectangle;
		public function GameObject() {
			super();
		}
		
		/**
		 * unused!
		 * */
		public function setCollisionBox(size:Number,center:Boolean=true):void
		{
			var offset:Number;
			if (center)
			{
				offset = size / -2;
			}else
			{
				offset = 0;
			}
			_collisionBox = new Rectangle(offset,offset,size,size);
		}
		
		/**
		 * global X (x position multiplied by global scale
		 * */
		public function set gX(value:Number):void
		{
			x = value * MobiAIR.globalScale;
		}
		
		/**
		 * global Y (y position multiplied by global scale
		 * */
		public function set gY(value:Number):void
		{
			y = value * MobiAIR.globalScale;
		}
		
		public function get gX():Number
		{
			return x / MobiAIR.globalScale;
		}
		
		public function get gY():Number
		{
			return y / MobiAIR.globalScale;
		}
		
		/**
		 * set position and multiply it by global scale
		 * */
		public function setPosition(newX:Number,newY:Number):void
		{
			x = newX * MobiAIR.globalScale; y = newY * MobiAIR.globalScale;
		}
		
		
	}
	
}
