package
{	
	import com.kristymiller.events.LoginCancelEvent;
	import com.kristymiller.events.LoginSuccessEvent;
	import com.kristymiller.ui.LandingView;
	import com.kristymiller.ui.LoginScreen;
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
		 private var _appBlock:ApplicationBlock;
		 private var _loginScreen:LoginScreen;
		
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
			
			_appBlock = new ApplicationBlock();
			_loginScreen = new LoginScreen();
			
			var sW:Number = stage.stageWidth/2;
			var lW:Number = _loginScreen.width/2;
			var sH:Number = stage.stageHeight/2;
			var lH:Number = _loginScreen.height/2;

			_loginScreen.x = sW-lW;
			_loginScreen.y = sH-lH;
			
			this.addChild(_appBlock);
			this.addChild(_loginScreen);
			
			// Needs to pause the stream and resume if the cancel button was clicked only
			// _landing.togglePause();
			
			_loginScreen.addEventListener(LoginCancelEvent.LOGIN_CANCEL, cancelClick);
			_loginScreen.addEventListener(LoginSuccessEvent.LOGIN_SUCCESS, successLogin);

		}
		
		// Success Login
		private function successLogin(e:Event):void
		{
			this.removeChild(_landing);
			this.removeChild(_loginScreen);
			this.removeChild(_appBlock);
			
			_record = new RecordView();
			this.addChild(_record);
			
			_record.watch.addEventListener(MouseEvent.CLICK, watchView);
		}
		
		private function cancelClick(e:Event):void
		{
			this.removeChild(_loginScreen);
			this.removeChild(_appBlock);
			
			// Should resume the video playback where it left off when the login screen was opened
		}
		
		// Watch View
		private function watchView(e:MouseEvent):void
		{
			this.removeChild(_record);
			init();
		}
	}
}