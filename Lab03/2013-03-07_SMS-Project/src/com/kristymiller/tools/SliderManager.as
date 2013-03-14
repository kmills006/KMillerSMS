package com.kristymiller.tools
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class SliderManager extends EventDispatcher
	{
		private var _handle:Sprite;
		private var _track:Sprite;
		private var _pct:Number;
		private var _oldX:Number;
		
		public function SliderManager()
		{
		}
		
		public function setUpAssets(handle:Sprite, track:Sprite):void
		{
			_handle = handle;
			_track = track;
			
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			if(_handle.stage == null)
			{
				_handle.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}else{
				_handle.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			
		}
		
		private function onAddedToStage(event:Event):void
		{
			_handle.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_handle.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		
		protected function onMouseUp(event:MouseEvent):void
		{
			// stop dragging the handle
			_handle.stopDrag();
			_handle.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			// start being able to drag the handle
			_oldX = _handle.x;
			_handle.startDrag(false, new Rectangle(0, 0, _track.width - _handle.width, 0));
			_handle.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			_pct = (_handle.x / (_track.width - _handle.width));
			
			if(_oldX != _handle.x)
			{
				var e:Event = new Event(Event.CHANGE);
				dispatchEvent(e);
			}
			
			_oldX = _handle.x;
			
		}
		
		public function get pct():Number
		{
			return _pct;
		}

		public function set pct(value:Number):void
		{
			_pct = value;
			_handle.x = _pct * _track.width;
		}

	}
}