package ui
{

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author Juan Delgado
	 */
	public class LogField extends Sprite
	{
		private const field : TextField = new TextField();
		
		public function LogField()
		{
			field.border = true;
			field.multiline = field.wordWrap = true;
			field.embedFonts = true;
			field.selectable = false;
			field.defaultTextFormat = new TextFormat("GentiumBasic", 18, 0xFFFFFF);
			
			addChild(field);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}

		public function log(text : String) : void
		{
			field.appendText(text + "\n");
			field.scrollV = field.maxScrollV;
		}
		
		private function removedFromStage(event : Event) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}

		private function addedToStage(event : Event) : void
		{
			const totalWidth : int = stage.stageWidth * .9;
			const totalHeight : int = stage.stageHeight * .9;
			
			field.width = totalWidth;
			field.height = totalHeight;
			
			const bg : Sprite = new Sprite();
			bg.graphics.beginFill(0x000000, .7);
			bg.graphics.drawRect(0, 0, totalWidth, totalHeight);
			bg.graphics.endFill();
			
			addChild(bg);
			swapChildren(bg, field);

			const margin : int = 10;
			
			const scrollDownButton : Button = new Button();
			scrollDownButton.x = totalWidth - scrollDownButton.width - margin;
			scrollDownButton.y = totalHeight - scrollDownButton.height - margin;
			
			scrollDownButton.addEventListener(MouseEvent.CLICK, scrollDown);
			
			const scrollUpButton : Button = new Button();
			scrollUpButton.x = scrollDownButton.x;
			scrollUpButton.y = margin;
			
			scrollUpButton.addEventListener(MouseEvent.CLICK, scrollUp);

			scrollUpButton.buttonMode = scrollDownButton.buttonMode = true;
			
			addChild(scrollUpButton);			addChild(scrollDownButton);
		}

		private function scrollUp(event : MouseEvent) : void
		{
			field.scrollV -= 2;
		}

		private function scrollDown(event : MouseEvent) : void
		{
			field.scrollV += 2;
		}
		
		[Embed(source="../assets/fonts/GenBasR.ttf", fontFamily="GentiumBasic", embedAsCFF="false", mimeType="application/x-font")]
		private var c4Regular : Class;
	}
}

import flash.display.Sprite;
import flash.system.Capabilities;
import flash.system.TouchscreenType;

internal class Button extends Sprite
{
	public function Button()
	{
		// Lets use bigger buttons on touch devices
		const size : int = (Capabilities.touchscreenType == TouchscreenType.FINGER || Capabilities.touchscreenType == TouchscreenType.STYLUS)? 50 : 20;
		graphics.beginFill(0x000000);
		graphics.drawRect(0, 0, size, size);
		graphics.endFill();
	}
}