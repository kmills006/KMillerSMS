package com.kristymiller.events
{
	import flash.events.Event;
	
	public class DurationEvent extends Event
	{
		public static const DURATION_LOADED:String = "duration_loaded";
		
		public function DurationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new DurationEvent(type, bubbles, cancelable);
		}
	}
}