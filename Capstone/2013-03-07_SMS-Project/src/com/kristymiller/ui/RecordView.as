package com.kristymiller.ui
{
	import com.kristymiller.custom.CustomComboBox;
	import com.kristymiller.events.NetConnectFailedEvent;
	import com.kristymiller.events.NetConnectSuccessEvent;
	import com.kristymiller.events.PublishEvent;
	import com.kristymiller.publish.Publish;
	
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class RecordView extends RecordBase
	{
		private var _publish:Publish;
		private var _myTimer:Timer;

		private var _camDD:CustomComboBox;
		private var _selectedCam:String = "0"; // setting the default camera to built in isight
		
		private var _micDD:CustomComboBox;
		private var _selectedMic:int;
		
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
			_publish.addEventListener(NetConnectFailedEvent.NETCONNECT_FAILED, netconnectFailed);
			
			// Camera Drop Down
			_camDD = new CustomComboBox();
			_camDD.width = 150;
			_camDD.prompt = "Select Camera";
			
			_camDD.dataProvider = new DataProvider(_publish.camNames);
			_camDD.y = this.recordbtn.y; 
			_camDD.x = 30;
			_camDD.addEventListener(Event.CHANGE, onCamChange);
			this.addChild(_camDD);
			
			// Mic Drop Down
			_micDD = new CustomComboBox();
			_micDD.width = 150;
			_micDD.prompt = "Select Microphone";
			
			_micDD.dataProvider = new DataProvider(_publish.micNames);
			_micDD.y = this.recordbtn.y;
			_micDD.x = 460;
			_micDD.addEventListener(Event.CHANGE, onMicChange);
			this.addChild(_micDD);
		}
		
		// On Camera Change
		private function onCamChange(e:Event):void
		{
			_selectedCam = ComboBox(e.target).selectedItem.data;
			
			switch(_selectedCam){
				case "Built-in iSight":
					trace("iSight camera selected");
					_selectedCam = "0";
				break;
				
				default:
					trace("No camera selected");
				break;
			}
		}
		
		// On Microphone Change
		private function onMicChange(e:Event):void
		{	
			switch(ComboBox(e.target).selectedItem.data){
				case "Built-in Input":
					_selectedMic = -1;
				break;
				
				case "Built-in Microphone":
					_selectedMic = 0;
				break;
				
				default:
					trace("No Microphone Selected");
				break;
			}
		}
		
		// NetConnect Success
		private function netConnectSuccess(e:Event):void
		{	
			// if the connection was successful allow the user to click the record button
			this.recordbtn.addEventListener(MouseEvent.CLICK, startRecording);
		}

		// NetConnect Failed
		private function netconnectFailed(e:Event):void
		{
			// present error message to user
		}
		
		// Start Recording
		private function startRecording(e:MouseEvent):void{
			_publish.loadCamera(_selectedCam, _selectedMic);
			
			this.recordbtn.gotoAndStop(3);
			
			_publish.x = 31;
			_publish.y = this.logo.height + 10;
			this.addChild(_publish);
			
			this.recordbtn.addEventListener(MouseEvent.CLICK, stopRecording);
		}
		
		// Stop Recording
		private function stopRecording(e:MouseEvent):void{
			_publish.nsPublish();
			
			_myTimer = new Timer(2000, 1);
			_myTimer.addEventListener(TimerEvent.TIMER, turnOffCam);
			_myTimer.start();

			this.recordbtn.gotoAndStop(1);
		}
		
		// Turn Off Camera
		private function turnOffCam(e:TimerEvent):void
		{
			_publish.turnOffCam();
			this.removeChild(_publish);
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