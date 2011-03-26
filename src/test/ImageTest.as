package test
{
	import test.common.TimeTest;

	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Juan Delgado
	 */
	public class ImageTest extends TimeTest
	{
		private var timer : Timer;
		
		private var images : Vector.<Image> = new Vector.<Image>();
		
		override public function getName() : String
		{
			return "ImageTest";
		}
		
		override public function run() : void
		{
			super.run();
					
			timer = new Timer(100);
			timer.addEventListener(TimerEvent.TIMER, addImages);
			timer.start();
		}

		override protected function enterFrame(event : Event) : void
		{
			super.enterFrame(event);
			
			for each(var image : Image in images)
			{
				image.x += (image.xTo - image.x) / 3;
				image.y += (image.yTo - image.y) / 3;

				if(Math.abs(image.x - image.xTo) < 1)
				{
					image.x = image.xTo;
					image.xTo = Math.ceil(Math.random() * stage.stageWidth);
				}

				if(Math.abs(image.y - image.yTo) < 1)
				{
					image.y = image.yTo;
					image.yTo = Math.ceil(Math.random() * stage.stageHeight);
				}
			}
		}

		override protected function stop() : void
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, addImages);
			timer = null;
			
			result = images.length.toString();
			humanReadableResult = "Total images drawn: " + result;
			
			images = null;
			
			super.stop();
		}

		private function addImages(event : TimerEvent) : void
		{
			for(var i : int = 0; i < 10; i++)
			{
				var image : Image = new Image();
				addChild(image);
				
				images.push(image);
			}
		}
	}
}

import flash.display.Sprite;

internal class Image extends Sprite
{
	public var xTo : int = 0;
	
	public var yTo : int = 0;
	
	[Embed(source="../assets/wikipedia.png")]
	private var ImageClass : Class;
	
	public function Image()
	{
		addChild(new ImageClass());
	}
}