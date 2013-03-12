package com.kristymiller.events
{
	import flash.events.Event;
	
	public class StopStreamEvent extends Event
	{
		public static const STOP_STREAM:String = "stop_stream";
		
		public function StopStreamEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event{
			return new StopStreamEvent(type, bubbles, cancelable);
		}
	}
}