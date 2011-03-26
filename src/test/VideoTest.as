package test
{

	import test.common.Test;

	import flash.events.NetStatusEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.events.StageVideoEvent;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/**
	 * @author Juan Delgado
	 */
	public class VideoTest extends Test
	{
		private var nc : NetConnection;
		
		private var ns : NetStream;
		
		private const VIDEO_FILE : String = "assets/I-Am-Legend-Trailer.m4v";
		
		override public function getName() : String
		{
			return "VideoTest";
		}
		
		override public function run() : void
		{
			super.run();
			
			_updateSignal.dispatch(this, "run called, waiting for stage video availability");
			
			stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, stageVideoAvailable);
		}
		
		private function stageVideoAvailable(event : StageVideoAvailabilityEvent) : void
		{
			const available : Boolean = (event.availability == StageVideoAvailability.AVAILABLE);

			_updateSignal.dispatch(this, "stageVideoAvailable: " + available);
			
			if(available)
			{
				const videos : Vector.<StageVideo> = stage.stageVideos;
				var sv : StageVideo;

				if(videos.length >= 1)
				{
					nc = new NetConnection();
					nc.connect(null);
					
					ns = new NetStream(nc);
					ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
					ns.client = this;
							
					sv = videos[0];
					sv.addEventListener(StageVideoEvent.RENDER_STATE, stageVideoStateChange);
					sv.attachNetStream(ns);
					
					ns.play(VIDEO_FILE);
				}
			}
			else
			{
				_updateSignal.dispatch(this, "Stage video not available");
				stop();
			}
		}
		
		private function onNetStatus(event : NetStatusEvent) : void
		{
			_updateSignal.dispatch(this, "NetStatus: " + event.info);
			
			switch(event.info)
			{
				case "NetStream.Play.StreamNotFound":
				
					_updateSignal.dispatch(this, "Video not found");
					stop();
					
					break;
					
				case "NetStream.Play.Stop":
					
					stop();
					break;
			}
		}
		
		private function stageVideoStateChange(event : StageVideoEvent) : void
		{	
			_updateSignal.dispatch(this, "stageVideoStateChange: " + event.status);
		}
	}
}
