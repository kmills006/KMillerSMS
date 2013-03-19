package com.kristymiller.stream 
{
	import adobe.utils.CustomActions;
	
	import com.kristymiller.events.DurationEvent;
	import com.kristymiller.ui.LandingView;
	
	import flash.display.MovieClip;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class Stream extends MovieClip
	{
		
		private var _nc:NetConnection;
		private var _ncClient:Object;
		private var _server:String = "rtmp://localhost/oflaDemo";
		public var _ns:NetStream;
		private var _nsClient:Object;
		private var _video:Video;
		private var _duration:Number = 0;
		
		// Stream
		public function Stream():void
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
		
		// Net Status Event
		private function ncNSE(event:NetStatusEvent):void
		{
			trace("NETSTATUS[NetStream]: " + event.info.code);
			
			switch(event.info.code){
				case "NetConnection.Connect.Success":
					_ns = new NetStream(_nc);
					_ns.addEventListener(NetStatusEvent.NET_STATUS, nsNSE);
					_ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, aee);
					_ns.play("guilt_trip.flv");
					//_ns.play("startrekintodarkness_vp6.flv");
					//_ns.play("RecordedStream.flv");
					
					_nsClient = new Object();
					_nsClient.onMetaData = omd;
					_nsClient.onCuePoint = ocp;
					_ns.client = _nsClient;
					
					_video = new Video(570, 350);
					_video.attachNetStream(_ns);
					this.addChild(_video);
				break;
				
				case "NetConnection.Connect.InvalidApp":
					trace("Connection failed because application is invalid");
				break;
				
				case "NetConnection.Connect.Rejected":
					trace("Connection Rejected");
				break;
				
				case "NetConnection.Connect.Failed":
					trace("Connection Failed");
				break;
				
				case "NetConnection.Connect.Closed":
					trace("Connection Closed");
				break;
			}
		}
	
		// Net Stream Error 
		private function nsNSE(event:NetStatusEvent):void{
			trace("NETSTATUS[NetStream]: " + event.info.code);
			
			switch(event.info.code){
				case "NetStream.Failed":
					trace("Connection successful, but stream failed.");
					break;		
			
				case "NetStream.Play.StreamNotFound":
					trace("Connection successful, but stream not found.");
				break;	
				
				case "NetStream.Play.InsufficientBW":
					trace("Connection successful, but bandwidth is insufficient.");
				break;
				
				case "NetStream.Play.Reset":
					trace("Server stream reset.");
				break;
				
				case "NetStream.Play.Start":
					trace("Server stream started.");
				break;
				
				case "NetStream.Buffer.Full":
					trace("Stream buffer is full.");
				break;
				
				case "NetStream.Pause.Notify":
					trace("Server stream paused.");
				break;
				
				case "NetStream.Unpause.Notify":
					trace("Server stream resumed.");
				break;		
				
				case "NetStream.Play.Stop":
					trace("Stream was stopped.");
				break;		
				
				case "NetStream.Buffer.Flush":
					trace("Stream buffer was flushed.");
				break;
				
				case "NetStream.Buffer.Empty":
					trace("Stream buffer is empty.");
				break;
			}
		}
		
		// Asynch Error
		private function aee(event:AsyncErrorEvent):void{

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
		
		// On Meta Data
		private function omd(o:Object):void{
			trace("OnMetaData");
			trace("Duration: " + o.duration);
			_duration = o.duration;
			
			if(_duration){
				var evt:DurationEvent = new DurationEvent("duration_loaded");
				this.dispatchEvent(evt);	
			}
		}
		
		// On Cue Points
		private function ocp(o:Object):void{
			trace("OnCuePoint");
			trace(o.name + " at " + o.time);
		}
		
		// Getting for Duration
		public function get duration():Number
		{
			return _duration;
		}
		
		// Toggle Play Click
		public function togglePause():void{
			_ns.togglePause();
		}
		
		// Change Volume
		public function changeVolume(newVol:SoundTransform):void{
			_ns.soundTransform = newVol;
		}
		
		// Mute Volume
		public function muteVol(mutedVol:SoundTransform):void{
			_ns.soundTransform = mutedVol;
		}
		
		// Seek
		public function seekSlider(newPos:Number):void{
			_ns.seek(newPos);
		}
		
		// Pause Stream
		public function pauseStream():void{
			_ns.pause();
		}
		
		// Play Stream
		public function playStream():void{
			_ns.play();
		}
		
		// Stop Stream
		public function stopStream():void{
 			_ns.close();
		}
	}
}