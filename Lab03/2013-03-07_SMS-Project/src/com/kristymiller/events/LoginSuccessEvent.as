package com.kristymiller.events
{
	import flash.events.Event;
	
	public class LoginSuccessEvent extends Event
	{
		public static const LOGIN_SUCCESS:String = "login_success";
		
		public function LoginSuccessEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
		public override function clone():Event
		{
			return new LoginSuccessEvent(type, bubbles, cancelable);
		}
	}
}