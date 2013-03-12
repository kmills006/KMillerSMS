package com.kristymiller.ui
{	
	import com.kristymiller.tools.SliderManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import stream.Stream;

	public class LandingView extends LandingBase
	{
		private var _stream:Stream;
		private var _volSlider:MovieClip;
		private var _volManager:SliderManager;
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
			
			// Chage
			this.chatBtn.stop();
			this.chatBtn.buttonMode = true;
			this.chatBtn.addEventListener(MouseEvent.MOUSE_OVER, hoverState);
			
			// Select Video DropDown
			this.selectVideo.stop();
			this.selectVideo.buttonMode = true;
			this.selectVideo.addEventListener(MouseEvent.MOUSE_OVER, hoverState);
			
			// Play/Pause Btn
			this.audioControls.PlayBtn.gotoAndStop(1);
			this.audioControls.PlayBtn.buttonMode = true;
			this.audioControls.PlayBtn.addEventListener(MouseEvent.MOUSE_OVER, hoverState);
			this.audioControls.PlayBtn.addEventListener(MouseEvent.CLICK, playPauseClick);
			
			// Volume Slider
			this.audioControls.VolumeSlider.Handle.buttonMode = true;
			_volSlider = this.audioControls.VolumeSlider;

			// Volume Icon
			this.audioControls.VolumeIcon.stop();
			this.audioControls.buttonMode = true;
			this.audioControls.VolumeIcon.addEventListener(MouseEvent.CLICK, muteClick);
			
			// Initialize Functions
			initSliders();
			initStream();
		}
		
		// Initialize Streaming Video
		private function initStream():void
		{
			// Stream
			_stream = new Stream();
			_stream.x = 35;
			_stream.y = this.logo.height;
			this.addChild(_stream);
		}
		
		// Initialize Slider Controls
		private function initSliders():void
		{
			_volManager = new SliderManager();
			_volManager.setUpAssets(_volSlider.Handle, _volSlider.Track);
			_volManager.addEventListener(Event.CHANGE, onVolChange);
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
		
		// Play/Pause Click
		private function playPauseClick(e:MouseEvent):void
		{
			_stream.togglePlayClick(e);

			switch(this.audioControls.PlayBtn.currentFrame){
				case 2:
					this.audioControls.PlayBtn.gotoAndStop(3);
				break;
				
				case 4:
					this.audioControls.PlayBtn.gotoAndStop(1);
				break;
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