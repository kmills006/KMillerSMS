package com.kristymiller.events
{
	import flash.events.Event;
	
	public class NetConnectSuccessEvent extends Event
	{
		public static const NETCONNECT_SUCCESS:String  = "netconnect_success";
		
		public function NetConnectSuccessEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new NetConnectSuccessEvent(type, bubbles, cancelable);
		}
	}
}