package test
{
	import test.common.TimeTest;

	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Juan Delgado
	 */
	public class DrawingAPITest extends TimeTest
	{
		private var timer : Timer;
		
		private var circles : Vector.<Circle> = new Vector.<Circle>();
		
		override public function getName() : String
		{
			return "DrawingAPITest";
		}
		
		override public function run() : void
		{
			super.run();
			
			timer = new Timer(100);
			timer.addEventListener(TimerEvent.TIMER, addCircles);
			timer.start();
		}

		override protected function enterFrame(event : Event) : void
		{
			super.enterFrame(event);
			
			for each(var circle : Circle in circles)
			{
				circle.x += (circle.xTo - circle.x) / 3;				circle.y += (circle.yTo - circle.y) / 3;

				if(Math.abs(circle.x - circle.xTo) < 1)
				{
					circle.x = circle.xTo;
					circle.xTo = Math.ceil(Math.random() * stage.stageWidth);
				}

				if(Math.abs(circle.y - circle.yTo) < 1)
				{
					circle.y = circle.yTo;
					circle.yTo = Math.ceil(Math.random() * stage.stageHeight);
				}
			}
		}

		override protected function stop() : void
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, addCircles);
			timer = null;
			
			result += "Total circles: " + circles.length;
			
			circles = null;
			
			super.stop();
		}

		private function addCircles(event : TimerEvent) : void
		{
			for(var i : int = 0; i < 10; i++)
			{
				var circle : Circle = new Circle();
				addChild(circle);
				
				circles.push(circle);
			}			
		}
	}
}

import flash.display.Sprite;

internal class Circle extends Sprite
{
	public var xTo : int = 0;
	
	public var yTo : int = 0;
	
	public function Circle()
	{
		graphics.beginFill(Math.random() * 0xFFFFFF);
		graphics.drawCircle(0, 0, 5);
		graphics.endFill();
	}
}