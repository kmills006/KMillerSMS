package com.kristymiller.ui
{
	import com.kristymiller.events.NetConnectSuccessEvent;
	import com.kristymiller.events.PublishEvent;
	import com.kristymiller.publish.Publish;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class RecordView extends RecordBase
	{
		private var _publish:Publish;
		private var _myTimer:Timer;
		
		public function RecordView()
		{
			super();
			
			_publish = new Publish();
			
			// Watch
			this.watch.stop();
			this.watch.buttonMode = true;
			this.watch.gotoAndStop(2);
			this.watch.addEventListener(MouseEvent.MOUSE_OVER, hoverState);
			
			// Record
			this.record.stop();
			this.record.buttonMode = true;
			this.record.gotoAndStop(2);
			
			// Record Button
			this.recordbtn.stop();
			this.recordbtn.buttonMode = true;
			this.recordbtn.addEventListener(MouseEvent.MOUSE_OVER, hoverState);
			
			_publish.addEventListener(NetConnectSuccessEvent.NETCONNECT_SUCCESS, netConnectSuccess);
			
			this.recordbtn.addEventListener(MouseEvent.CLICK, startRecording);
		}
		
		private function netConnectSuccess(e:Event):void
		{
			trace("net connect success");
		}
		
		// Start Recording
		private function startRecording(e:MouseEvent):void{
			_publish.nsRecord();
			
			this.recordbtn.gotoAndStop(3);
			
			_publish.x = 31;
			_publish.y = this.logo.height + 10;
			this.addChild(_publish);
			
			this.recordbtn.addEventListener(MouseEvent.CLICK, stopRecording);
		}
		
		// Stop Recording
		private function stopRecording(e:MouseEvent):void{
			_publish.nsPublish();
			
			_myTimer = new Timer(4000, 1);
			_myTimer.addEventListener(TimerEvent.TIMER, turnOffCam);
			_myTimer.start();

			this.recordbtn.gotoAndStop(1);
		}
		
		// Turn Off Camera
		private function turnOffCam(e:TimerEvent):void
		{
			_publish.turnOffCam();
		}
		
		// Hover State
		private function hoverState(e:MouseEvent):void{
			if(e.currentTarget == this.watch){
				e.currentTarget.gotoAndStop(1);
			}if(e.currentTarget == this.recordbtn && e.currentTarget.currentFrame == 3){
				// do nothing
			}else{
				e.currentTarget.gotoAndStop(2);
			}
			
			e.currentTarget.addEventListener(MouseEvent.MOUSE_OUT, regularState);
		}
		
		// Regular State
		private function regularState(e:MouseEvent):void{
			if(e.currentTarget == this.watch){
				e.currentTarget.gotoAndStop(2);
			}if(e.currentTarget == this.recordbtn && e.currentTarget.currentFrame == 3){
				// do nothing
			}else{
				e.currentTarget.gotoAndStop(1);
			}
		}
	}
}