/* 
	Live Demo 2013-03-12
	Publish
	By Nathan 
*/

package{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.events.NetStatusEvent;
	import flash.events.AsyncErrorEvent;
	
	[SWF( width = "640" , height = "480" )]
	
	public class Publish extends MovieClip{
		var nc:NetConnection;
		var Server:String = "rtmp://localhost/oflaDemo";
		var ns:NetStream;
		var nsClient:Object;
		var camera:Camera;
		//var CameraNames:Array = Camera.names;
		var microphone:Microphone;
		//var MicrophoneNames:Array = Microphone.names;
		var video:Video;
		var Recording:Boolean;
		
		function Publish():void{
			nc = new NetConnection();
			nc.addEventListener( NetStatusEvent.NET_STATUS , ncNSE ); 	
			nc.connect( Server );
			
			function nsRecord( event:MouseEvent ):void{
				if( !Recording ){
					if( camera != null )ns.attachCamera( camera );
					if( microphone != null )ns.attachAudio( microphone );
					ns.publish( "RecordedStream" , "record" );
					//ns.publish( "RecordedStream" , "append" );
					Recording = true;
				}
				
				trace( "Recording" );
			}
			
			function nsPublish( event:KeyboardEvent ):void{
				if( Recording )ns.close();
				trace( "Publishing" );
			}
			
			stage.addEventListener( MouseEvent.CLICK , nsRecord );
			stage.addEventListener( KeyboardEvent.KEY_DOWN , nsPublish );
		}
		
		function ncNSE( event:NetStatusEvent ):void{
			trace( "NETSTATUS [ NetStream ]: " + event.info.code );
			
			if ( event.info.code == "NetConnection.Connect.Success" ){
				ns = new NetStream( nc );
				ns.addEventListener( NetStatusEvent.NET_STATUS , nsNSE );
				ns.addEventListener( AsyncErrorEvent.ASYNC_ERROR , aee );
				nsClient = new Object();
				ns.client = nsClient;					
				video = new Video( 640 , 480 );
				addChild( video );
				//trace( CameraNames );
				camera = Camera.getCamera();
				//camera = Camera.getCamera(CameraNames[3]);
				//trace( MicrophoneNames );
				microphone = Microphone.getMicrophone();
				//microphone = Microphone.getAudio(MicrophoneNames[3]);
				if( camera != null )video.attachCamera( camera );
			}
			
			function nsNSE( event:NetStatusEvent ):void{
				trace( "NETSTATUS [ NetStream ]: " + event.info.code );
				
				switch ( event.info.code ){
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
			
			function aee( event:AsyncErrorEvent ):void{
				trace( event.text );
			}
		}
	}
}