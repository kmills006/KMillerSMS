package com.kristymiller.publish
{
	import com.kristymiller.events.NetConnectFailedEvent;
	import com.kristymiller.events.NetConnectSuccessEvent;
	import com.kristymiller.events.PublishEvent;
	
	import flash.display.MovieClip;
	import flash.events.AsyncErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class Publish extends MovieClip
	{
		private var _nc:NetConnection;
		private var _ncClient:Object;
		private var _ns:NetStream;
		private var _nsClient:Object;
		private var _server:String = "rtmp://localhost/oflaDemo";
		private var _cam:Camera;
		private var _mic:Microphone;
		private var _video:Video;
		private var _recording:Boolean;
		
		public function Publish()
		{
			super();
			
			_nc = new NetConnection();
			_nc.addEventListener(NetStatusEvent.NET_STATUS, ncNSE);
			_ncClient = new Object();
			_ncClient.onBWCheck = onBWCheck;
			_ncClient.onBWDone = onBWDone;
			_nc.client = _ncClient;
			_nc.connect(_server);
		}
		
		// NetStream Record
		public function nsRecord():void{
			if(!_recording){
				if(_cam != null)_ns.attachCamera(_cam);
				if(_mic != null)_ns.attachAudio(_mic);
				
				_ns.publish("RecordingStream", "record");
				_recording = true;
			}
		}
		
		// NetStream Publish
		public function nsPublish():void{
			if(_recording)_ns.close();
			
			trace("Publishing");
		}
		
		// NETSTATUS[NetConnection] Event
		private function ncNSE(e:NetStatusEvent):void
		{
			trace("NETSTATUS[NetConnection]: " + e.info.code);
			
			switch(e.info.code){
				case "NetConnection.Connect.Success":
					var successEvt:NetConnectSuccessEvent = new NetConnectSuccessEvent("netconnect_success");
					this.dispatchEvent(successEvt);
				break;
				
				case "NetConnection.Connect.InvalidApp":
					trace("Connection failed because application is invalid");
				break;
				
				case "NetConnection.Connect.Rejected":
					trace("Connection Rejected");
				break;
				
				case "NetConnection.Connect.Failed":
					trace("Connection Failed");
					
					var failedEvt:NetConnectFailedEvent = new NetConnectFailedEvent("netconnect_failed");
					this.dispatchEvent(failedEvt);
				break;
				
				case "NetConnection.Connect.Closed":
					trace("Connection Closed");
				break;
			}
		}
		
		// Load Camera
		public function loadCamera():void{
			
			_ns = new NetStream(_nc);
			_ns.addEventListener(NetStatusEvent.NET_STATUS, nsNSE);
			_ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, aee);
			
			_nsClient = new Object();
			_video = new Video(570, 379.4);
			
			this.addChild(_video);
			
			_cam = Camera.getCamera();
			_mic = Microphone.getMicrophone();
			
			if(_cam != null)_video.attachCamera(_cam);
			
			nsRecord();
		}
		
		// NETSTATUS[NetStream] Event
		private function nsNSE(e:NetStatusEvent):void{
			trace("NETSTATUS[NetStream]: " + e.info.code);
			
			switch ( e.info.code ){
				case "NetStream.Failed":
					trace( "Connection successful, but stream failed." );
					break;				
				
				case "NetStream.Record.NoAccess":
					trace( "Connection successful, but unable to access stream." );
					break;
				
				case "NetStream.Publish.Start":
					trace( "Publishing successful." );
					break;
				
				case "NetStream.Publish.BadName":
					trace( "Attempt to publish stream with invalid name." );
					break;
				
				case "NetStream.Play.StreamNotFound":
					trace( "Connection successful, but stream not found." );
					break;				
				
				case "NetStream.Buffer.Full":
					trace( "Stream buffer is full." );
					break;
				
				case "NetStream.Buffer.Empty":
					trace( "Stream buffer is empty." );
					break;
			}
		}
		
		// Async Error
		private function aee(e:AsyncErrorEvent):void
		{
			trace(e.text);
		}
		
		// On Bandwidth Check
		private function onBWCheck(o:Object):Number{
			return 0;
		}
		
		// On Bandwidth Done
		private function onBWDone(o:Object):void{
			trace("KB Down: " + o["kb down"]);
			trace("Latency: " + o["latency"]);
		}
		
		// Turn Off Camera
		public function turnOffCam():void{
			trace("turn off camera");
			if(_video){
				_video.attachCamera(null);
				_video.clear();
				this.removeChild(_video);
			}
		}
	}
}