package com.Ammarz.MobiAIR
{
	
	import com.GameHelpers.GameMath;
	import com.Ammarz.MobiAIR.Graphics.BlitSprite_WIP.AnimatedSprite;
	import com.Ammarz.MobiAIR.Graphics.Animation;
	import com.Ammarz.MobiAIR.Graphics.DisplayObject.MobiSprite;
	import com.Ammarz.MobiAIR.Graphics.DisplayObject.MobiSpriteM;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.sampler.startSampling;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;

	public class utilz
	{
		private static var i:int
		
		
		public static function createMirroredSpriteRaw(bitmap:BitmapData,width:int,height:int,numFrames:int = 0):BitmapData
		{	
			if (numFrames == 0)
			{
				numFrames = bitmap.width / width;
			}
			
			var clipRect:Rectangle = new Rectangle(0,0,width,height);
			var mat:Matrix;
			mat = new Matrix();
			mat.scale(-1,1);
			mat.translate(bitmap.width,0);
			var flipedBD:BitmapData = new BitmapData(bitmap.width,bitmap.height,true,0x00000);
			flipedBD.draw(bitmap,mat);
			return flipedBD;
		}
		
		public static function splitBitmap(bd:BitmapData,width:int,height:int,numFrames:int = 0):Vector.<BitmapData>
		{
			if (numFrames <= 0)
			{
				numFrames = numFrames = bd.width / width;
			}
			var _splitBD:Vector.<BitmapData> = new Vector.<BitmapData>();
			//var i:int
			var newBD:BitmapData;
			var rect:Rectangle = new Rectangle(0,0,width,height);
			var point:Point = new Point(0,0);
			for (i=0;i< numFrames;i++)
			{
				newBD = new BitmapData(width,height,true,0x000000);
				rect.x = i * width;
				newBD.copyPixels(bd,rect,point);
				_splitBD.push(newBD);
			}
			return _splitBD;
		}
		
		public static function splitTileSheet(bd:BitmapData,tileSize:uint,sep:uint=0):Vector.<BitmapData>
		{
			var hlen:uint = Math.floor(bd.width / (tileSize + sep))+sep;
			var vlen:uint = Math.floor(bd.height / (tileSize + sep))+sep;
			
			var v:uint;
			var h:uint;
			var res:Vector.<BitmapData> = new Vector.<BitmapData>();
			var newTile:BitmapData;
			var rect:Rectangle = new Rectangle(0,0,tileSize,tileSize);
			var point:Point = new Point();
			for (v = 0;v<vlen;v++)
			{
				for (h=0;h<hlen;h++)
				{
					newTile = new BitmapData(tileSize,tileSize,true);
					rect.x = (h * (tileSize + sep))+sep;
					rect.y = (v * (tileSize + sep))+sep;
					newTile.copyPixels(bd,rect,point);
					res.push(newTile);
				}
			}
			
			return res;
		}
		
		public static function showChildren(dso:Sprite,flag:Boolean = true):void
		{
			var num:uint = dso.numChildren;
			for (i = 0 ; i < num ; i++)
			{
				dso.getChildAt(i).visible = false;
			}
		}
		
		public static function dpToBitmap(mc:DisplayObject,frame:int = 0,trans:Boolean = true,width:Number = 0,height:Number = 0,scale:Number = 1):BitmapData
		{
			
			if (width == 0)
			{
				width = Math.ceil(mc.width * scale / mc.scaleX);
			}else
			{
				width = Math.ceil(width);
			}
			if (height == 0)
			{
				height = Math.ceil(mc.height * scale / mc.scaleY);
			}else
			{
				height = Math.ceil(height);
			}
			
			if (frame > 0)
			{
				MovieClip(mc).gotoAndStop(frame);
			}
			
			var mat:Matrix;
			var bd:BitmapData = new BitmapData(width,height,trans,0x000000);
			if (scale != 1)
			{
				mat = new Matrix();
				mat.scale(scale * mc.scaleX,scale * mc.scaleY);
				bd.draw(mc,mat);
			}else
			{
				mat = new Matrix();
				mat.scale(mc.scaleX,mc.scaleY);
				bd.draw(mc,mat);
			}

			return bd;
		}
		
		/*
		public static function mcToBitmaps(mc:MovieClip,width:Number = 0,height:Number = 0):Vector.<BitmapData>
		{
			mc.stop();
			var bdv:Vector.<BitmapData> = new Vector.<BitmapData>();
			var newBD:BitmapData;
			//var i:int
			for (i=0;i<=mc.framesLoaded;i++)
			{
				newBD = new BitmapData(mc.width,mc.height,true,0x000000);
				newBD.draw(mc);
				bdv.push(newBD);
				mc.nextFrame();
			}
			
			return bdv;
		}
		*/
		
		public static function mcToSheet(mc:MovieClip,width:Number = 0,height:Number = 0,scale:Number = 1):BitmapData
		{
			mc.stop();
			
			if (width == 0)
			{
				width = Math.ceil(mc.width * scale);
			}else
			{
				width = Math.ceil(width);
			}
			if (height == 0)
			{
				height = Math.ceil(mc.height * scale);
			}else
			{
				height = Math.ceil(height);
			}
			trace("BDW: " + Math.ceil(mc.framesLoaded * width).toString());
			trace("BDH: " + Math.ceil(height).toString());
			var newBD:BitmapData = new BitmapData(Math.ceil(mc.framesLoaded * width),Math.ceil(height),true,0x000000);
			//var clip:Rectangle = new Rectangle(0,0,width,height);
			//var i:int
			for (i=0;i<mc.framesLoaded;i++)
			{
				var mat:Matrix;
				mat = new Matrix();
				mat.scale(scale,scale);
				mat.translate(i * Math.ceil(width),0);
				
				//clip.x = i * Math.ceil(width);
				newBD.draw(mc,mat,null,null,null,true);
				mc.nextFrame();
			}
			
			return newBD;
		}
		
		/**
		 * renders a movieclip to a Vector containing bitmaps
		 * @param mc the movieclip you want to render
		 * @param width the size of the bitmaps (if you use scale you should take it into count or use "mcToBitmapsAutoScale")
		 * @param height same as the above!
		 * @param scale this will scale the movieclip, usefull for multiscreen support
		 * @param transparent if false the bitmaps will appear as boxes
		 * @param fillColor the color it fill the bitmaps with in case you use transparency
		 * @param smoothing smooth the bitmaps when scaled or rotated (slow)
		 * @param startFrame the frame where you want to start rendering frames on the movieclip
		 * @param endFrame the last frame you want to include (0 will render to the whole movieclip frames)
		 * @return a Vector.<BitmapData> containing the frames you've rendered
		 * */
		public static function mcToBitmaps(mc:MovieClip,width:Number = 0,height:Number = 0,scale:Number = 1,transparent:Boolean = true,fillColor:uint = 0,smoothing:Boolean = false,startFrame:uint = 1,endFrame:uint = 0):Vector.<BitmapData>
		{
			mc.stop();
			if (width == 0)
				width = Math.ceil(mc.width * scale);
			else
				width = Math.ceil(width);
			if (height == 0)
				height = Math.ceil(mc.height * scale);
			else
				height = Math.ceil(height);
			if (endFrame == 0)
			{
				endFrame = mc.framesLoaded;
			}
			var mat:Matrix;
			if (scale != 1)
			{
				mat = new Matrix();
				mat.scale(scale,scale);
			}
			
			var bits:Vector.<BitmapData> = new Vector.<BitmapData>();
			var bit:BitmapData;
			//var i:uint;
			var clip:Rectangle = new Rectangle(0,0,width,height);
			for (i = startFrame; i <= endFrame ; i++)
			{
				mc.gotoAndStop(i);
				bit = new BitmapData(width,height,transparent,fillColor);
				bit.draw(mc,mat,null,null,clip,smoothing);
				bits.push(bit);
			}
			
			return bits;
		}
		
		/**
		 * almost the same as mcToBitmaps, but it will multiply the width and height by the scale value you provide
		 * @param mc the movieclip you want to render
		 * @param width the actual width of the movieclip inside Flash, if you pass 0 it will automatically calculate it but its not reliable
		 * @param height same as the above!
		 * @param scale this will scale the movieclip, usefull for multiscreen support
		 * @param transparent if false the bitmaps will appear as boxes
		 * @param fillColor the color it fill the bitmaps with in case you use transparency
		 * @param smoothing smooth the bitmaps when scaled or rotated (slow)
		 * @param startFrame the frame where you want to start rendering frames on the movieclip
		 * @param endFrame the last frame you want to include (0 will render to the whole movieclip frames)
		 * @return a Vector.<BitmapData> containing the frames you've rendered
		 * */
		public static function mcToBitmapsAutoScale(mc:MovieClip,width:Number = 0,height:Number = 0,scale:Number = 1,transparent:Boolean = true,fillColor:uint = 0,smoothing:Boolean = false,startFrame:uint = 1,endFrame:uint = 0):Vector.<BitmapData>
		{
			return mcToBitmaps(mc,width * scale,height * scale,scale,transparent,fillColor,smoothing,startFrame,endFrame);
		}

		
		public static function splitBitmapM(bd:BitmapData,width:int,height:int,numFrames:int = 0):Vector.<BitmapData>
		{
			if (numFrames <= 0)
			{
				numFrames = numFrames = bd.width / width;
			}
			bd = createMirroredSpriteRaw(bd,width,height,numFrames);
			var _splitBD:Vector.<BitmapData> = new Vector.<BitmapData>();
			//var i:int
			var newBD:BitmapData;
			var rect:Rectangle = new Rectangle(0,0,width,height);
			var point:Point = new Point(0,0);
			for (i=numFrames-1;i >= 0;i--)
			{
				newBD = new BitmapData(width,height,true,0x000000);
				rect.x = i * width;
				newBD.copyPixels(bd,rect,point);
				_splitBD.push(newBD);
			}
			return _splitBD;
		}
		
		public static function mirrorBitmap(bd:BitmapData):BitmapData
		{
			var mirrored:BitmapData = new BitmapData(bd.width,bd.height,bd.transparent,0x000000);
			var mat:Matrix = new Matrix();
			mat.scale(-1,1);
			mat.translate(bd.width,0);
			mirrored.draw(bd,mat);
			return mirrored;
		}
		
		/*
		public static function createSpriteFromMC(mc:MovieClip,speed:Number = 1,cam:Camera = null,ix:int = 0,iy:int = 0,offset:Point = null,mirrored:Boolean = false):iPhoneSpriteM
		{
			var 
			var s:iPhoneSpriteM = new iPhoneSpriteM(
		}
		*/
		
		public static function mcToAnimation(mc:MovieClip,w:Number = 0,h:Number = 0,scale:Number = 1,makeMirror:Boolean = false,animSpeed:Number = 1,loop:Boolean = true,off:Point = null,ret:int = -1,firstFrame:uint = 1,lastFrame:uint = 0):Animation
		{
			if (w == 0)
			{
				w = Math.ceil(mc.width * scale);
			}else
			{
				w = Math.ceil(w);
			}
			if (h == 0)
			{
				h = Math.ceil(mc.height * scale);
			}else
			{
				h = Math.ceil(h);
			}
			
			/*
			var len:int = mc.framesLoaded;
			var vc:Vector.<BitmapData> = new Vector.<BitmapData>();
			
			var f:int;
			
			for (f = 1 ; f <= len ; f++)
			{
				vc.push(utilz.dpToBitmap(mc,f,false,w,h,scale));
			}
			*/
			
			var an:Animation = new Animation(mcToBitmaps(mc,w,h,scale,true,0,true,firstFrame,lastFrame),w,h,animSpeed,loop,off,ret);
			if (makeMirror)
			{
				an.createMirror();
			}
			//var an:Animation = new Animation(,w,h,animSpeed,loop,off,ret,makeMirror);
			
			return an;
		}
		
		public static function mcToAnimationAutoScale(mc:MovieClip,w:Number = 0,h:Number = 0,scale:Number = 1,makeMirror:Boolean = false,animSpeed:Number = 1,loop:Boolean = true,off:Point = null,ret:int = -1,firstFrame:uint = 1,lastFrame:uint = 0):Animation
		{
			return mcToAnimation(mc,w*scale,h*scale,scale,makeMirror,animSpeed,loop,off,ret,firstFrame,lastFrame);
		}
		
		
		public static function makeText(textFormat:TextFormat,txt:String = "",x:int = 0,y:int = 0):TextField
		{
			var newTF:TextField = new TextField();
			newTF.autoSize = TextFieldAutoSize.LEFT;
			//newTF.embedFonts = true;
			newTF.selectable = false;
			newTF.defaultTextFormat = textFormat;
			newTF.textColor = GameMath.RGB2Hex(0,0,0);
			newTF.antiAliasType = AntiAliasType.ADVANCED;
			newTF.text = txt;
			//newTF.defaultTextFormat.size = 20;
			newTF.x = x;
			newTF.y = y;
			
			return newTF;
		}
		
		public static function makeTextFormat(font:String):TextFormat
		{
			var newTF:TextFormat = new TextFormat();
			//newTF.font = font;
			newTF.color = 0x000000;
			newTF.size = 25;
			return newTF;
		}
		
		public static function getAsset(swf:MovieClip,className:String):Class
		{
			//var dynClass : Class = Class(getDefinitionByName(("fully.qualified.ClassName"));
			return Class(getDefinitionByName((className)));
		}
	}
}