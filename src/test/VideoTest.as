package test
{
	import test.common.Test;

	import flash.media.StageVideo;

	/**
	 * @author Juan Delgado
	 */
	public class VideoTest extends Test
	{
		override public function run() : void
		{
			
			super.run();
			
			try
			{
				var videos : Vector.<StageVideo> = stage.stageVideos;
				var sv : StageVideo;

				if (videos.length >= 1)
				{
					sv = videos[0];
					result = "GOOD";
				}
				else
				{
					result = "BAD";
				}
				
				stop();
				
			}
			catch(e : Error)
			{
				result = "NOT WORKING";
				stop();
			}
		}
		
		override public function getName() : String
		{
			return "VideoTest";
		}
	}
}
