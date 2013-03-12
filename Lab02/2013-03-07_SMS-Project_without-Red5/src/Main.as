package
{	
	import com.kristymiller.events.StopStreamEvent;
	import com.kristymiller.ui.LandingView;
	import com.kristymiller.ui.RecordView;
	
	import flash.display.FrameLabel;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.osmf.logging.Log;
	
	[SWF(width="640", height="620", frameRate="60", backgroundColor="#14181C")]
	
	public class Main extends Sprite
	{
		 private var _landing:LandingView;
		 private var _record:RecordView;
		
		public function Main()
		{
			init();
		}
		
		private function init():void{
			_landing = new LandingView();
			this.addChild(_landing);
			
			_landing.record.addEventListener(MouseEvent.CLICK, recordView);
		}
		
		// Record View
		private function recordView(event:MouseEvent):void
		{
			// Stop the current streaming video if there is one
			_landing.stopStream();
			
			this.removeChild(_landing);
			
			_record = new RecordView();
			this.addChild(_record);
			
			_record.watch.addEventListener(MouseEvent.CLICK, watchView);
		}
		
		// Watch View
		private function watchView(e:MouseEvent):void
		{
			this.removeChild(_record);
			init();
		}
	}
}