package com.kristymiller.ui
{
	import flash.events.MouseEvent;

	public class RecordView extends RecordBase
	{
		public function RecordView()
		{
			super();
			
			// Watch
			this.watch.stop();
			this.watch.buttonMode = true;
			this.watch.gotoAndStop(2);
			this.watch.addEventListener(MouseEvent.MOUSE_OVER, hoverState);
			
			// Record
			this.record.stop();
			this.record.buttonMode = true;
			this.record.gotoAndStop(2);
			
			// Reccord Button
			this.recordbtn.stop();
			this.recordbtn.buttonMode = true;
			this.recordbtn.addEventListener(MouseEvent.MOUSE_OVER, hoverState);
		}
		
		// Hover State
		private function hoverState(e:MouseEvent):void
		{
			if(e.currentTarget == this.watch){
				e.currentTarget.gotoAndStop(1);
			}else{
				e.currentTarget.gotoAndStop(2);
			}
			
			e.currentTarget.addEventListener(MouseEvent.MOUSE_OUT, regularState);
		}
		
		// Regular State
		private function regularState(e:MouseEvent):void
		{
			if(e.currentTarget == this.watch){
				e.currentTarget.gotoAndStop(2);
			}else{
				e.currentTarget.gotoAndStop(1);
			}
		}
	}
}