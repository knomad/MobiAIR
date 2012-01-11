package com.Ammarz.Radio {
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	public class ZRadioButton extends MovieClip{
		
		private var _dot:MovieClip;
		private var _enabled:Boolean;
		private var _radioGroup:ZRadioGroup;
		
		public function ZRadioButton() {
			super();
			_enabled = false;
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_DOWN,handleMouse);
		}
		
		protected function setupDot(myDot:MovieClip):void
		{
			_dot = myDot;
		}
		
		private function handleMouse(event:MouseEvent):void
		{
			if (_radioGroup)
			{
				_radioGroup.radioButtonClicked(this);
			}
			setEnabled(true);
		}
		
		internal function setup(radioGroup:ZRadioGroup):void
		{
			_radioGroup = radioGroup;
		}
		
		internal function setEnabled(flag:Boolean):void
		{
			_dot.visible = flag;
			_enabled = flag;
		}
		
		public function set radioEnabled(v:Boolean):void
		{
			_enabled = v;
			_dot.visible = v;
			_radioGroup.radioButtonClicked(this);
		}

	}
	
}
