package com.kristymiller.custom
{
	import fl.controls.ComboBox;
	
	import flash.text.TextFormat;
	
	public class CustomComboBox extends ComboBox
	{
		public function CustomComboBox()
		{
			super();
			
			var tf:TextFormat = new TextFormat("Verdana", 12, 0x000000);
			textField.setStyle("textFormat", tf);
			
			dropdown.setStyle("cellRenderer", CustomCellRenderer);
		}
	}
}