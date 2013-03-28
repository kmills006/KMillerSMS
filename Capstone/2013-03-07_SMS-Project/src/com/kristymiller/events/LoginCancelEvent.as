package com.kristymiller.events
{
	import flash.events.Event;
	
	public class LoginCancelEvent extends Event
	{
		public static const LOGIN_CANCEL:String = "login_cancel";
		
		public function LoginCancelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new LoginCancelEvent(type, bubbles, cancelable);
		}
	}
}