package test.common
{
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * @author Juan Delgado
	 */
	public class TimeTest extends Test
	{
		protected var minFramesPerSecond : int = 10;
		
		private var time : Number = -1;
		
		private var maxDelay : Number;
		
		override public function run() : void
		{
			super.run();
			
			// That's the time a frame would take to render at minFramesPerSecond
			maxDelay = (1/minFramesPerSecond) * 1000;

			addEventListener(Event.ENTER_FRAME, enterFrame);
		}

		protected function enterFrame(event : Event) : void
		{
			if(time != -1)
			{
				if(getTimer() - time > maxDelay)
				{
					stop();
				}
			}
			
			time = getTimer();
		}

		override protected function stop() : void
		{
			removeEventListener(Event.ENTER_FRAME, enterFrame);
			
			super.stop();
		}
	}
}
