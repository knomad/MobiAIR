package com.GameHelpers
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class GameMath
	{
		
		public static function Distance2D(Ax:Number,Ay:Number,Bx:Number,By:Number):Number
		{
			var dx:Number;
			var dy:Number;
			dx = Ax-Bx;
			dy = Ay-By;
			return Math.sqrt(dx*dx + dy*dy)
		}
		
		public static function Rad(deg:Number):Number
		{
			return deg * Math.PI/180;
		}
		
		public static function Deg(rad:Number):Number
		{
			return rad / Math.PI * 180;
		}

		
		public static function RGB2Hex(r:uint,g:uint,b:uint):uint
		{
			return (r << 16 | g << 8 | b);
		}
		
		public static function SmoothValue(dest:Number,current:Number,speed:Number):Number
		{
			return current + (dest - current) * speed;
		}
		
		public static function SmoothValueMaxed(dest:Number,current:Number,speed:Number,maxSpeed:Number):Number
		{
			var ret:Number;
			var step:Number = (dest - current) / speed;
			
			if (step >= 0)
			{
				(step > maxSpeed) ? ret = current + maxSpeed : ret = current + step;
			}else
			{
				(step < -maxSpeed) ? ret = current - maxSpeed : ret = current + step;
			}
			
			
			return ret;
		}
		
		public static function pointInRecs(point:Point,recs:Vector.<Rectangle>):Boolean
		{
			var ret:Boolean = false;
			var i:uint;
			var l:uint = recs.length;
			for (i = 0;i<l;i++)
			{
				if (recs[i].containsPoint(point))
				{
					ret = true;
					break;
				}
			}
			return ret;
		}
		
		public static function rayCastRects(startPoint:Point,targetPoint:Point,rects:Vector.<Rectangle>,acc:Number=1):Point
		{
			var i:uint;
			var steps:int = Math.ceil(Distance2D(startPoint.x,startPoint.y,targetPoint.x,targetPoint.y));
			var angle:Number = LookAt(startPoint.x,startPoint.y,targetPoint.x,targetPoint.y);
			var point:Point = new Point();
			for (i = 0;i < steps;i+= acc)
			{
				point.x = startPoint.x + (Math.cos(angle) * i);
				point.y = startPoint.y + (Math.sin(angle) * i);
				if (pointInRecs(point,rects))
				{
					return point;
				}
			}
			return null;
		}
		
		public static function d_Collision(oX:Number,oY:Number,tX:Number,tY:Number,d:Number):Boolean
		{
			return Distance2D(oX,oY,tX,tY) < d;
		}
		
		public static function SmoothAngle(dest:Number,Current:Number,speed:Number):Number
		{
			return WrapAngle(SmoothValue(0,WrapAngle(Current+180-dest)-180,speed)+dest)
		}
		
		
		public static function LookAt(x:Number,y:Number,atX:Number,atY:Number):Number
		{
			return Math.round(Math.atan2(atY - y,atX - x) / Math.PI * 180);
		}
		
		public static function WrapAngle(angle:Number):Number
		{
			while (angle >= 360)
			{
				angle -= 360;
			}
			while (angle < 0)
			{
				angle += 360;
			}
			return angle;
		}
		
		public static function ObjectLineIntersect(mc:Object,px:Number,py:Number,Ang:Number,acc:Number,MaxDist:Number,perPixel:Boolean):Boolean
		{
			var TestX:Number;
			var TestY:Number;
			var ret:Boolean = false;
			var cDist:Number;
			
			for (cDist = 0; cDist < MaxDist ; cDist += acc)
			{
				TestX = px + (Math.cos(Ang) * cDist);
				TestY = py + (Math.sin(Ang) * cDist);
				if (mc.hitTest(px,py,perPixel))
				{
					ret = true;
					break;
				}
			}
			return ret;
		}
		
		public static function InsertChild(object:DisplayObjectContainer,child:DisplayObjectContainer,to:int=0):void
		{
			object.addChild(child);
			var i:int;
			for (i = object.numChildren - 2; i >= to;i--)
			{
				object.swapChildrenAt(i,i+1);
			}
		}
		
		public static function ReverseIndex(ind:int,length:int):int
		{
			return length - 1 - ind;
		}
		
		public static function easeTo( current:Number, target:Number, easeFactor:Number = 10 ):Number
		{  
			return current -= ((current - target) / easeFactor );
		}
		
		/*
		public static function clone(obj:Object):Object {
			if (typeof (this) == "object")
			{
				var to = (this instanceof Array )?[]:{};
				for (var i in this)
				{
					to[i] = (typeof (this[i]) == "object") ? this[i].clone () : this[i];
				}
				return to;
			}
			trace ("Warning! Object.clone can not be used on MovieClip or XML objects");
			return undefined;
		}
		*/
		
		/*
		public static findIntersection(p1:Point,p2:Point,p3:Point,p4:Point):Point
		{
			
			var xD1:Number;
			var yD1:Number;
			var xD2:Number;
			var yD2:Number;
			var xD3:Number;
			var yD3:Number;
			
			var dot:Number;
			var deg:Number;
			var len1:Number;
			var len2:Number;
			
			var segmentLen1:Number;
			var segmentLen2:Number;
			
			var ua:Number;
			var ub:Number;
			var div:Number;
			
			// calculate differences  
			xD1 = p2.x - p1.x;
			xD2 = p4.x - p3.x;
			yD1 = p2.y - p1.y;
			yD2 = p4.y - p3.y;
			xD3 = p1.x - p3.x;
			yD3 = p1.y - p3.y;
			
			// calculate the lengths of the two lines  
			len1 = Math.sqrt((xD1 * xD1 + yD1 * yD1);
			len2 = Math.sqrt(xD2 * xD2 + yD2 * yD2);
			
			// calculate angle between the two lines.  
			dot = (xD1 * xD2 + yD1 * yD2); // dot product  
			deg = dot / (len1 * len2);
			
			// if abs(angle)==1 then the lines are parallell,  
			// so no intersection is possible  
			if (Math.abs((deg) == 1) return new Point(0,0);
			
			// find intersection Pt between two lines  
			var pt:Point = new Point(0, 0);
			div = yD2 * xD1 - xD2 * yD1;
			ua = (xD2 * yD3 - yD2 * xD3) / div;
			ub = (xD1 * yD3 - yD1 * xD3) / div;
			pt.x = p1.x + ua * xD1;
			pt.y = p1.y + ua * yD1;
			
			// calculate the combined length of the two segments  
			// between Pt-p1 and Pt-p2  
			xD1 = pt.X - p1.X;
			xD2 = pt.X - p2.X;
			yD1 = pt.Y - p1.Y;
			yD2 = pt.Y - p2.Y;
			segmentLen1 = Math.sqrt(xD1 * xD1 + yD1 * yD1) + Math.sqrt(xD2 * xD2 + yD2 * yD2);
			
			// calculate the combined length of the two segments  
			// between Pt-p3 and Pt-p4  
			xD1 = pt.X - p3.X;
			xD2 = pt.X - p4.X;
			yD1 = pt.Y - p3.Y;
			yD2 = pt.Y - p4.Y;
			segmentLen2 = (float)Math.Sqrt(xD1 * xD1 + yD1 * yD1) + (float)Math.Sqrt(xD2 * xD2 + yD2 * yD2);
			
			// if the lengths of both sets of segments are the same as  
			// the lenghts of the two lines the point is actually  
			// on the line segment.  
			
			// if the point isn’t on the line, return null  
			if (Math.abs(len1 - segmentLen1) > 0.01 || Math.abs(len2 - segmentLen2) > 0.01)
				return Point.Zero;
			
			// return the valid intersection  
			return pt;
		}
		*/
		
		//---------------------------------------------------------------
		//Checks for intersection of Segment if as_seg is true.
		//Checks for intersection of Line if as_seg is false.
		//Return intersection of Segment AB and Segment EF as a Point
		//Return null if there is no intersection
		//---------------------------------------------------------------
		public static function intersection(p1:Point, p2:Point, p3:Point, p4:Point):Point {
			var x1:Number = p1.x, x2:Number = p2.x, x3:Number = p3.x, x4:Number = p4.x;
			var y1:Number = p1.y, y2:Number = p2.y, y3:Number = p3.y, y4:Number = p4.y;
			var z1:Number= (x1 -x2), z2:Number = (x3 - x4), z3:Number = (y1 - y2), z4:Number = (y3 - y4);
			var d:Number = z1 * z4 - z3 * z2;
			 
			// If d is zero, there is no intersection
			if (d == 0) return null;
			 
			// Get the x and y
			var pre:Number = (x1*y2 - y1*x2), post:Number = (x3*y4 - y3*x4);
			var x:Number = ( pre * z2 - z1 * post ) / d;
			var y:Number = ( pre * z4 - z3 * post ) / d;
			 
			// Check if the x and y coordinates are within both lines
			if ( x < Math.min(x1, x2) || x > Math.max(x1, x2) ||
			x < Math.min(x3, x4) || x > Math.max(x3, x4) ) return null;
			if ( y < Math.min(y1, y2) || y > Math.max(y1, y2) ||
			y < Math.min(y3, y4) || y > Math.max(y3, y4) ) return null;
			 
			// Return the point of intersection
			return new Point(x, y);
		}

		
	}
}