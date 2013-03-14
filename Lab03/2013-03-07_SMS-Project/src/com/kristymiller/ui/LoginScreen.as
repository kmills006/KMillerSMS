package com.kristymiller.ui
{
	import com.kristymiller.events.LoginCancelEvent;
	import com.kristymiller.events.LoginSuccessEvent;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	public class LoginScreen extends LoginScreenBase
	{
		
		public function LoginScreen()
		{
			super();
			
			this.SubmitBtn.stop();
			this.SubmitBtn.buttonMode = true;
			this.SubmitBtn.addEventListener(MouseEvent.CLICK, submitClick);
			this.SubmitBtn.addEventListener(MouseEvent.MOUSE_OVER, hoverState);
			
			// Cancel
			this.CancelBtn.stop();
			this.CancelBtn.buttonMode = true;
			this.CancelBtn.addEventListener(MouseEvent.CLICK, cancelClick);
			this.CancelBtn.addEventListener(MouseEvent.MOUSE_OVER, hoverState);
			
			this.pword.addEventListener(KeyboardEvent.KEY_DOWN, enterSubmit);
		}
		
		// Enter Submit
		private function enterSubmit(e:KeyboardEvent):void
		{
			if(e.keyCode == 13){
				submitClick(null);
			}
		}
		
		// Submit Click
		private function submitClick(e:MouseEvent):void{
			if(this.username.text == "admin" && this.pword.text == "dinos"){
				var evt:LoginSuccessEvent = new LoginSuccessEvent("login_success");
				this.dispatchEvent(evt);
			}else{
				trace("Incorrect Login Information");
			}
		}
		
		// Cancel Click
		private function cancelClick(e:MouseEvent):void
		{
			var evt:LoginCancelEvent = new LoginCancelEvent("login_cancel");
			this.dispatchEvent(evt);
		}
		
		// Hover State
		private function hoverState(e:MouseEvent):void
		{
			e.currentTarget.gotoAndStop(2);
			e.currentTarget.addEventListener(MouseEvent.MOUSE_OUT, regularState);
		}
		
		// Regular State
		private function regularState(e:MouseEvent):void
		{
			e.currentTarget.gotoAndStop(1);
		}
	}
}