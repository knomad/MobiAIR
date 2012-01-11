package com.Ammarz.MobiAIR.Graphics
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	public class AnimationPackage
	{
		
		private var _animations:Vector.<Animation>;
		private var _animDict:Dictionary;
		public function AnimationPackage()
		{
			_animations = new Vector.<Animation>();
			_animDict = new Dictionary(true);
		}
		
		public function addAnimation(anim:Animation,name:String):void
		{
			_animations.push(anim);
			_animDict[name] = anim;
		}
		
		public function dispose():void
		{
			var i:int;
			for (i=0;i<_animations.length;i++)
			{
				_animations[i].dispose();
			}
		}
		
		public function get animations():Vector.<Animation>
		{
			return _animations;
		}
		
		public function byName(name:String):Animation
		{
			return _animDict[name];
		}
		
	}
}