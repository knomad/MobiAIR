package com.Ammarz.Radio {
	
	public class ZRadioGroup {
		
		private var _radioButtons:Vector.<ZRadioButton>;
		private var _selected:int;
		
		public function ZRadioGroup() {
			_radioButtons = new Vector.<ZRadioButton>();
		}
		
		public function addRadioButton(radioButton:ZRadioButton):void
		{
			radioButton.setup(this);
			radioButton.setEnabled(false);
			_radioButtons.push(radioButton);
			_selected = 0;
		}
		
		internal function radioButtonClicked(radioButton:ZRadioButton):void
		{
			setAll(false,radioButton);
			_selected = _radioButtons.indexOf(radioButton);
		}
		
		private function setAll(flag:Boolean,except:ZRadioButton = null):void
		{
			for each (var r:ZRadioButton in _radioButtons)
			{
				if (except)
				{
					if (r !=except)
					{
						r.setEnabled(flag);
					}
				} else
				{
					r.setEnabled(flag);
				}
			}
		}
		
		public function get selected():int
		{
			return _selected;
		}
		
		public function set selected(v:int):void
		{
			setAll(false,_radioButtons[v]);
			_radioButtons[v].setEnabled(true);
			_selected = v;
		}

	}
	
}
