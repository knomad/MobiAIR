package com.Ammarz.MobiAIR.DataManager
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	
	/**
	 * a class to load a list of files sequencially, its badly designed when I still new to AS3, so I want to rewrite it, I'll add comments and make an example when its done.
	 * */
	public class ExternalFilesLoader extends EventDispatcher
	{
		public static var EFL:ExternalFilesLoader;
		public static var EVENT_LOADING_DONE:String = "LoadingComplete";
		
		private var _progress:Number;
		private var _filesQueue:Array;
		private var _currentFile:int;
		private var _loader:Loader;
		private var _dict:Dictionary;
		private var _fileCount:int;
		private var _currentFileName:String;
		private var _isLoading:Boolean;
		private var _soundLoader:Sound;
		private var _urlLoader:URLLoader;
		
		public function ExternalFilesLoader()
		{
			_loader = new Loader();
			_urlLoader = new URLLoader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,fileLoadingComplete);
			_urlLoader.addEventListener(Event.COMPLETE,fileLoadingComplete);
			EFL = this;
		}
		
		public function StartNewSession():void
		{
			_filesQueue = new Array();
			_fileCount = 0;
			_dict = new Dictionary();
		}
		
		public function LoadBitmap(path:String,id:String):void
		{
			_fileCount++;
			_filesQueue.push(new Array(path,id,0));
		}
		
		public function LoadSound(path:String,id:String):void
		{
			_fileCount++;
			_filesQueue.push(new Array(path,id,1));
		}
		
		public function LoadXML(path:String,id:String):void
		{
			_fileCount++;
			_filesQueue.push(new Array(path,id,2));
		}
		
		public function startLoading():void
		{
			_isLoading = true;
			_currentFile = 0;
			_progress = 0;
			_currentFileName = _filesQueue[0][0];
			if (_filesQueue[0][2] == 0)
			{
				_loader.load(new URLRequest(_filesQueue[0][0]));
				//_progress = _currentFile / _fileCount;
			}else if (_filesQueue[0][1] == 1)
			{
				_soundLoader = new Sound();
				_soundLoader.addEventListener(Event.COMPLETE,fileLoadingComplete);
				_soundLoader.load(new URLRequest(_filesQueue[0][0]));
			}else if (_filesQueue[0][1] == 2)
			{
				//_urlLoader = new URLLoader();
				_urlLoader.load(new URLRequest(_filesQueue[0][0]));
			}
		}
		
		private function fileLoadingComplete(event:Event):void
		{
			_currentFile++;
			
			if (_filesQueue[0][2] == 0)
			{
				_dict[_filesQueue[0][1]] = event.currentTarget.content;
			}else if (_filesQueue[0][2] == 1)
			{
				_dict[_filesQueue[0][1]] = event.currentTarget;
			}else if (_filesQueue[0][2] == 2)
			{
				_dict[_filesQueue[0][1]] = new XML(event.currentTarget.data);
			}
			
			
			_filesQueue.shift();
			if (_filesQueue.length > 0)
			{
				_progress = _currentFile / _fileCount;
				_currentFileName = _filesQueue[0][0];
				if (_filesQueue[0][2] == 0)
				{
					_loader.load(new URLRequest(_filesQueue[0][0]));
				}else if (_filesQueue[0][2] == 1)
				{
					_soundLoader = new Sound();
					_soundLoader.addEventListener(Event.COMPLETE,fileLoadingComplete);
					_soundLoader.load(new URLRequest(_filesQueue[0][0]));
				}else if (_filesQueue[0][1] == 2)
				{
					//_urlLoader = new URLLoader();
					_urlLoader.load(new URLRequest(_filesQueue[0][0]));
				}
			}else
			{
				dispatchEvent(new Event(EVENT_LOADING_DONE));
				_isLoading = false;
			}
		}
		
		public function get isLoading():Boolean
		{
			return _isLoading;
		}
		
		public function getFile(id:String):Object
		{
			return _dict[id];
		}
		
		public function getBitmapData(id:String):BitmapData
		{
			return BitmapData(_dict[id].bitmapData);
		}
		
		public function getSound(id:String):Sound
		{
			return Sound(_dict[id]);
		}
		public function getXML(id:String):XML
		{
			return XML(_dict[id]);
		}
		
		public function get currentFileName():String
		{
			return _currentFileName;
		}
		
		public function get fileCount():int
		{
			return _fileCount;
		}
		
		public function get currentFileIndex():int
		{
			return _currentFile;
		}
		
		public function disposeBD(id:String):void
		{
			_dict[id].bitmapData.dispose();
			_dict[id] = null;
		}
		
		public function get loadPercent():Number
		{
			return _currentFile / _fileCount;
		}
	}
}