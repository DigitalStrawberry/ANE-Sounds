package
{
	import com.digitalstrawberry.nativeExtensions.anesounds.ANESounds;
	import flash.display.MovieClip;

	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;


	public class Main extends MovieClip
	{
		private var buttonFormat:TextFormat;
		private var _clickSoundId:int = -1;

		public function Main()
		{
			super();

			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.SHOW_ALL;

			// Create the ANE
			ANESounds.instance;

			createButtons();
		}


		private function createButtons():void
		{
			// Row
			var tf:TextField = createButton("Play Native Sound");
			tf.x = 170;
			tf.y = 10;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, playNativeSound);
			addChild(tf);
		}


		private function playNativeSound(event:MouseEvent):void
		{
			if(_clickSoundId == -1)
			{
				var soundFile:File = File.applicationDirectory.resolvePath('include/click-sound.ogg');
				_clickSoundId = ANESounds.instance.loadSound(soundFile);
			}

			ANESounds.instance.playSound(_clickSoundId);
		}


		private function createButton(label:String):TextField
		{
			if (!buttonFormat)
			{
				buttonFormat = new TextFormat();
				buttonFormat.font = "_sans";
				buttonFormat.size = 14;
				buttonFormat.bold = true;
				buttonFormat.color = 0xFFFFFF;
				buttonFormat.align = TextFormatAlign.CENTER;
			}

			var textField:TextField = new TextField();
			textField.defaultTextFormat = buttonFormat;
			textField.width = 140;
			textField.height = 30;
			textField.text = label;
			textField.backgroundColor = 0xCC0000;
			textField.background = true;
			textField.selectable = false;
			textField.multiline = false;
			textField.wordWrap = false;
			return textField;
		}

	}
}