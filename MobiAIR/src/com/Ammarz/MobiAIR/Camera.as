package com.Ammarz.MobiAIR
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	//import mx.utils.NameUtil;

	public class Camera extends EventDispatcher
	{
		//events:
		//public static const MOVE_EVENT:String = "MoveEvent";
		public static const RESIZE_EVENT:String = "ResizeEvent";
		
		
		private var _camRect:Rectangle;
		private var _oldCamRect:Rectangle;
		private var _positionPoint:Point;
		
		public function Camera(x:Number = 0,y:Number = 0,width:Number = 600,height:Number = 400)
		{
			_camRect = new Rectangle(x,y,width,height);
			_positionPoint = new Point(x,y);
			_oldCamRect = _camRect.clone();
		}
		
		//Getters and setters:
		public function get x():Number
		{
			return _camRect.x;
		}
		public function set x(val:Number):void
		{
			_camRect.x = Math.ceil(val);
			_positionPoint.x = _camRect.x;
		}
		
		public function get y():Number
		{
			return _camRect.y;
		}
		public function set y(val:Number):void
		{
			_camRect.y = Math.ceil(val);
			_positionPoint.y = _camRect.y;
		}
		
		public function get width():Number
		{
			return _camRect.width;
		}
		public function set width(val:Number):void
		{
			_camRect.width = Math.ceil(val);
		}
		
		public function get height():Number
		{
			return _camRect.height;
		}
		public function set height(val:Number):void
		{
			_camRect.height = Math.ceil(val);
			if (_camRect.height != _oldCamRect.height)
			{
				//dispatchEvent(new Event(RESIZE_EVENT));
				_oldCamRect.height = _camRect.height;
			}
		}
		
		public function get point():Point
		{
			return _positionPoint;
		}
		
		public function get rect():Rectangle
		{
			return _camRect;
		}
		
		public function getDepthX(d:Number):int
		{
			var t:Number = _camRect.x;
			return Math.round(t / d);
		}
		public function getDepthY(d:Number):int
		{
			var t:Number = _camRect.y;
			return Math.round(t / d);
		}
	}
}