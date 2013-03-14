package com.kristymiller.events
{
	import flash.events.Event;
	
	public class PublishEvent extends Event
	{
		public static const PUBLISH_EVENT:String = "publish_event";
		
		public function PublishEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new PublishEvent(type, bubbles, cancelable);
		}
	}
}