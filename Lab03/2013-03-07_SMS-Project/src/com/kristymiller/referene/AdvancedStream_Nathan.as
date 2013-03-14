/* 
	Live Demo 2013-03-07
	Publish
	By Nathan 
*/

package{
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.display.StageAlign;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.media.Video;
	import flash.events.NetStatusEvent;
	import flash.events.AsyncErrorEvent;
	
	[SWF( width = "640" , height = "480" )]
	
	public class Stream extends MovieClip{
		var nc:NetConnection;
		var ncClient:Object;
		var Server:String = "rtmp://localhost/oflaDemo/";
		var ns:NetStream;
		var nsClient:Object;
		var video:Video;
		
		function Stream():void{
			nc = new NetConnection();
			nc.addEventListener( NetStatusEvent.NET_STATUS , ncNSE );
			ncClient = new Object();
			ncClient.onBWCheck = onBWCheck;
			ncClient.onBWDone = onBWDone;
			nc.client = ncClient;
			nc.connect( Server );
			stage.addEventListener( KeyboardEvent.KEY_DOWN , nsPausePlay );
			stage.addEventListener( MouseEvent.CLICK , FullScreen );
		}
		
		function ncNSE( event:NetStatusEvent ):void{
			trace( "NETSTATUS [ NetStream ]: " + event.info.code );
			
			switch ( event.info.code ) {
				case "NetConnection.Connect.Success":
					ns = new NetStream( nc );
					ns.addEventListener( NetStatusEvent.NET_STATUS , nsNSE );
					ns.addEventListener( AsyncErrorEvent.ASYNC_ERROR , aee );
					ns.play( "avatar.flv" );
					//ns.play( "Test.flv" );
					//ns.play( "RecordedStream.flv" );
					//ns.play( "StreamNotFound.flv" );
					nsClient = new Object();
					nsClient.onMetaData = omd;
					nsClient.onCuePoint = ocp;
					ns.client = nsClient;
					video = new Video( 640 , 480 );
					video.attachNetStream( ns );
					addChild( video );
					nc.call( "checkBandwidth" , null );
					trace( "Connection successful." );
					break;
				
				case "NetConnection.Connect.InvalidApp":
					trace( "Connection failed because application is invalid." );
					break;
				
				case "NetConnection.Connect.Rejected":
					trace ( "Connection rejected." );
					break;
				
				case "NetConnection.Connect.Failed":
					trace( "Connection failed." );
					break;
				
				case "NetConnection.Connect.Closed":
					trace ( "Connection closed." );
					break;				
			}
		}
		
		function nsNSE( event:NetStatusEvent ):void{
			trace( "NETSTATUS [ NetStream ]: " + event.info.code );
			
			switch ( event.info.code ){
				case "NetStream.Failed":
					trace( "Connection successful, but stream failed." );
					break;		
				
				case "NetStream.Play.StreamNotFound":
					trace( "Connection successful, but stream not found." );
					break;	
				
				case "NetStream.Play.InsufficientBW":
					trace( "Connection successful, but bandwidth is insufficient." );
					break;
				
				case "NetStream.Play.Reset":
					trace( "Server stream reset." );
					break;
				
				case "NetStream.Play.Start":
					trace( "Server stream started." );
					break;
				
				case "NetStream.Buffer.Full":
					trace( "Stream buffer is full." );
					break;
				
				case "NetStream.Pause.Notify":
					trace( "Server stream paused." );
					break;
				
				case "NetStream.Unpause.Notify":
					trace( "Server stream resumed." );
					break;		
				
				case "NetStream.Play.Stop":
					trace( "Stream was stopped." );
					break;		
				
				case "NetStream.Buffer.Flush":
					trace( "Stream buffer was flushed." );
					break;
				
				case "NetStream.Buffer.Empty":
					trace( "Stream buffer is empty." );
					break;
			}
		}
		
		function onBWCheck( O:Object ):Number{
			return 0;
		}
		function onBWDone( O:Object ):void{
			/*if( O.length > 0 ){
			trace( "Server to Client Bandwidth: " + O[ 0 ] );
			trace( "Server Latency: " + O[ 3 ] );
			}*/
			
			trace( "Kbit Down: " + O[ "kbitDown" ] );
			trace( "Latency: " + O[ "latency" ] );
			trace( "Duration: " + O[ "duration" ] );
		}
		
		function aee( event:AsyncErrorEvent ):void{
			trace( event.text );
		}
		
		function omd( O:Object ):void{
			trace( "OnMetaData" );
			trace( "Duration: " + O.duration );
		}
		function ocp( O:Object ):void{
			trace( "OnCuePoint" );
			trace( O.name + " at " + O.time );
		}
		
		function nsPausePlay( event:KeyboardEvent ):void{
			ns.togglePause();
			trace( "Server stream paused or resumed." );
		}
		
		function FullScreen( event:MouseEvent ):void{
			if (stage.displayState == StageDisplayState.NORMAL){
				stage.displayState = StageDisplayState.FULL_SCREEN;
				trace( "Fullscreen." );
			}else{
				stage.displayState = StageDisplayState.NORMAL;
				trace( "Default screen." );
			}
			//stage.align = StageAlign.TOP_LEFT;
		}
	}
}