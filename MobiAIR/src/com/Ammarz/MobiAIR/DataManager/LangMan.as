package com.Ammarz.MobiAIR.DataManager
{
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.utils.CharacterUtil;
	
	/**
	 * <b>Language Manager</g>
	 * this is some sort of a scripting engine which parse a text file containing sequencial commands
	 * something like events, can be used for easily managing game events, scripted cut-scenes, dialogs ... etc
	 * 
	 * I used this in a game but it still needs some work, a redesign and obviously alot of comments and examples, I suggest you not use this!
	 * */
	
	public final class LangMan
	{
		private static var lang:Dictionary;
		private static var conv:Array;
		private static var pos:int;
		private static var _name:String;
		private static var _img:uint;
		private static var _eof:Boolean;
		private static var _params:Vector.<String>;
		private static const NEW_LINE:RegExp = /\*/g;
		
		public function LangMan()
		{
		}
		
		/**
		 * set a string containing the script and parse it
		 * */
		public static function init(raw:String):void
		{

			lang = new Dictionary();
			var lines:String;
			var l:Array;
			var d:Array;
			var c:Array;
			var t:Array;
			var i:int;
			
			var cName:String;
			
			l = raw.split("\r\n");
			
			for each (var s:String in l)
			{

				if (s.length <= 1)
				{
					continue;
				}else
				{
					if (s.charAt(0) == "@")
					{
						continue;
					}else if (s.charAt(0) == "#")
					{
						c = s.split(" ");
						if (c[0] == "#event")
						{
							d = new Array();
							cName = c[1];
						}else if (c[0] == "#end")
						{
							lang[cName] = d;
						}else if (c[0] == "#set")
						{
							c = String(c[1]).split(",");
							if (c[1] == "null")
								d.push([1,c[0],""]);
							else
								d.push([1,c[0],c[1]]);
						}
						else if (c[0] == "#com")
						{
							t = new Array();
							t.push(2);
							for (i = 1; i < c.length ; i++)
							{
								t.push(c[i]);
							}
							d.push(t);
						}
						
					}else
					{
						d.push([0,s.replace(NEW_LINE,"\n")]);
					}
				}
			}
			
		}
		
		/**
		 * start reading an event
		 * */
		public static function startEvent(name:String,startPos:int = 0):void
		{
			conv = lang[name];
			pos = startPos;
			
			if (conv[pos][0] == 1)
			{
				pos--;
				next();
			}else
			{
				_name = "";
				_img = 0;
			}
			
		}
		
		
		public static function next():void
		{
			if (pos >= conv.length - 1 || !conv)
			{
				_eof = true;
				return;
			}else
			{
				pos++;
				if (conv[pos][0] == 1)
				{
					while (conv[pos][0] == 1)
					{
						_name = conv[pos][2];
						_img = conv[pos][1];
						pos++;
					}
				}else if (conv[pos][0] == 2)
				{
					_params = new Vector.<String>();
					var i:int;
					for (i = 2 ; i < conv[pos].length ; i++)
					{
						_params.push(conv[pos][i]);
					}
				}
			}
		}
		
		public static function get text():String
		{
			if (conv[pos][0] == 0 && conv)
			{
				return conv[pos][1];
			}else
			{
				return "";
			}
		}
		
		public static function get isCommand():Boolean
		{
			if (conv)
				return conv[pos][0] == 2;
			return false;
		}
		
		public static function get command():String
		{
			if (conv[pos][0] == 2 && conv)
			{
				return conv[pos][1];
			}else
			{
				return "";
			}
		}
		
		public static function get name():String
		{
			return _name;
		}
		
		public static function get image():uint
		{
			return _img;
		}
		
		public static function get eof():Boolean
		{
			if (conv)
				return _eof;
			return false;
		}
		
		public static function get conversation():Array
		{
			return conv;
		}
		
		public static function get params():Vector.<String>
		{
			return _params;
		}
	}
}