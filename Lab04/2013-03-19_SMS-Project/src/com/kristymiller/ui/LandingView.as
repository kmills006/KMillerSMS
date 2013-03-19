package com.kristymiller.ui
{	
	import com.kristymiller.events.DurationEvent;
	import com.kristymiller.tools.SliderManager;
	
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import com.kristymiller.stream.Stream;

	public class LandingView extends LandingBase
	{
		private var _stream:Stream;
		private var _volSlider:MovieClip;
		private var _volManager:SliderManager;
		private var _seekSlider:MovieClip;
		private var _seekManager:SliderManager;
		private var _pos:Number = 0;
		private var _duration:Number = 0;
		private var _st:SoundTransform;
		
		public function LandingView()
		{
			super();
			
			// Record  
			this.record.stop();
			this.record.buttonMode = true;
			this.record.addEventListener(MouseEvent.MOUSE_OVER, hoverState);
			
			// Watch 
			this.watch.stop();
			this.watch.buttonMode = true;
			
			// Chat
			this.chatBtn.stop();
			this.chatBtn.buttonMode = true;
			this.chatBtn.addEventListener(MouseEvent.MOUSE_OVER, hoverState);
			
			// Select Video DropDown
			this.selectVideo.stop();
			this.selectVideo.addEventListener(MouseEvent.MOUSE_OVER, hoverState);
			
			// Play/Pause Btn
			this.audioControls.PlayBtn.gotoAndStop(1);
			this.audioControls.PlayBtn.addEventListener(MouseEvent.MOUSE_OVER, hoverState);
			this.audioControls.PlayBtn.addEventListener(MouseEvent.CLICK, togglePause);
			
			// Volume Slider
			_volSlider = this.audioControls.VolumeSlider;

			// Volume Icon
			this.audioControls.VolumeIcon.stop();
			this.audioControls.VolumeIcon.addEventListener(MouseEvent.CLICK, muteClick);
			
			// Seek Slider
			_seekSlider = this.audioControls.SeekSlider;
			
			// FullScreen Icon
			this.Fullscreen.buttonMode = true;
			this.Fullscreen.addEventListener(MouseEvent.CLICK, onFullscreenClick);
			
			
			// Initialize Functions
			initSliders();
			initStream();
			 
			_stream.addEventListener(DurationEvent.DURATION_LOADED, onDurationLoaded);
		}
		
		// Initialize Streaming Video
		public function initStream():void
		{
			// Stream
			_stream = new Stream();
			_stream.x = 35;
			_stream.y = this.logo.height + 30;
			this.addChild(_stream);
			
			// !! dont forget to ask alejandro why the stream doesn't have a width when using red5 but does when calling local files
		}
		
		// Initialize Slider Controls
		private function initSliders():void
		{
			// Volume Manager
			_volManager = new SliderManager();
			_volManager.setUpAssets(_volSlider.Handle, _volSlider.Track);
			_volManager.addEventListener(Event.CHANGE, onVolChange);
			
			// Seek Manager
			_seekManager = new SliderManager();
			_seekManager.setUpAssets(_seekSlider.Handle, _seekSlider.Track);
			_seekManager.addEventListener(Event.CHANGE, onSeekChange);
		}
		
		// On Duration Loaded
		// Getting the Duration from the stream
		private function onDurationLoaded(e:Event):void
		{
			_duration = _stream.duration;
		}
		
		// On Volume Change
		private function onVolChange(e:Event):void
		{	
			if(this.audioControls.VolumeIcon.currentFrame == 2){
				this.audioControls.VolumeIcon.gotoAndStop(1);
			}
			
			_st = new SoundTransform;
			_st.volume = e.currentTarget.pct;
			_stream.changeVolume(_st);
		}
		
		// On Seek Change
		private function onSeekChange(e:Event):void
		{
			_pos = _seekManager.pct * _duration;
			_stream.seekSlider(_pos);
		}

		// Mute Click
		private function muteClick(e:MouseEvent):void
		{
			_st = new SoundTransform();
			_st.volume = 0;
			_stream.muteVol(_st);
			
			this.audioControls.VolumeIcon.gotoAndStop(2);
			this.audioControls.VolumeIcon.addEventListener(MouseEvent.CLICK, unmuteClick);
		}
		
		// Unmute Click
		private function unmuteClick(e:MouseEvent):void
		{
			_st = new SoundTransform();
		}
		
		// Toggle Pause
		private function togglePause(e:MouseEvent):void
		{
			_stream.togglePause();

			switch(this.audioControls.PlayBtn.currentFrame){
				case 2:
					this.audioControls.PlayBtn.gotoAndStop(3);
				break;
				
				case 4:
					this.audioControls.PlayBtn.gotoAndStop(1);
				break;
			}
		}
		
		
		// FullScreen Click
		private function onFullscreenClick(e:MouseEvent):void
		{
			if(stage.displayState == StageDisplayState.NORMAL){
				stage.displayState = StageDisplayState.FULL_SCREEN;
				trace("Full Screen");
			}else{
				stage.displayState = StageDisplayState.NORMAL;
				trace("Default Screen");
			}
		}
		
		// Hover States
		private function hoverState(e:MouseEvent):void
		{
			if(e.currentTarget == this.audioControls.PlayBtn){
				if(e.currentTarget.currentFrame == 1){
					e.currentTarget.gotoAndStop(2);
				}if(e.currentTarget.currentFrame == 3){
					e.currentTarget.gotoAndStop(4);
				}
			}else{
				e.currentTarget.gotoAndStop(2);	
			}
			
			e.currentTarget.addEventListener(MouseEvent.MOUSE_OUT, regularState);	
		}
		
		// Regular States
		private function regularState(e:MouseEvent):void
		{
			if(e.currentTarget == this.audioControls.PlayBtn){
				if(e.currentTarget.currentFrame == 2){
					e.currentTarget.gotoAndStop(1);
				}if(e.currentTarget.currentFrame == 4){
					e.currentTarget.gotoAndStop(3);
				}
			}else{
				e.currentTarget.gotoAndStop(1);	
			}
		}
		
		// Stop Stream
		public function stopStream():void{
			_stream.stopStream();
		}
	}
}