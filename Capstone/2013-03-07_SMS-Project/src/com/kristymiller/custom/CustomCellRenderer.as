package com.kristymiller.custom
{
	import fl.controls.listClasses.CellRenderer;
	
	import flash.text.TextFormat;
	
	public class CustomCellRenderer extends CellRenderer
	{
		public function CustomCellRenderer()
		{
			super();
			this.setStyle("textFormat", true);
			this.setStyle("textFormat", new TextFormat("Verdana", 10, 0x000000));
		}
	}
}