package test
{
	import test.common.TimeTest;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;

	/**
	 * @author Juan Delgado
	 */
	public class BitmapDataTest extends TimeTest
	{
		private var bmp : Bitmap;
		
		private var bitmapData : BitmapData;
		
		private var maxWidth : int;
		
		private var maxHeight : int;
		
		private var currentPixels : int;
		
		private var maxPixels : int;
		
		override public function getName() : String
		{
			return "BitmapDataTest";
		}
		
		override public function run() : void
		{
			maxWidth = stage.stageWidth;
			maxHeight = stage.stageHeight;
			
			bitmapData = new BitmapData(maxWidth, maxHeight, false);
			
			bmp = new Bitmap(bitmapData);
			addChild(bmp);
			
			currentPixels = 1;
			maxPixels = maxWidth * maxHeight;
			
			super.run();
		}
		
		override protected function enterFrame(event : Event) : void
		{
			super.enterFrame(event);
			
			var i : int = 0; // x index
			var j : int = 0; // y index
			var k : int = 0; // pixel counter

			while (k < currentPixels)
			{
				bitmapData.setPixel(i, j, Math.random() * 0xFFFFFF);
				
				i++;

				if (i >= maxWidth) // jump the line
				{
					i = 0;
					j++;
				}
				
				k++;

				if (currentPixels >= maxPixels) // drew the whole screen, what a champion!
				{
					stop();
					break;
				}
			}
			
			currentPixels += 50;
		}
		
		override protected function stop() : void
		{
			result += "Total pixels: " + currentPixels;
			
			super.stop();
		}
	}
}
