package com.kristymiller.events
{
	import flash.events.Event;
	
	public class NetConnectFailedEvent extends Event
	{
		public static const NETCONNECT_FAILED:String = "netconnect_failed";
		
		public function NetConnectFailedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new NetConnectFailedEvent(type, bubbles, cancelable);
		}
	}
}