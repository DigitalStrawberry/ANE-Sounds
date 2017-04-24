package
{
	import com.digitalstrawberry.nativeExtensions.anesounds.ANESounds;

	import flash.display.MovieClip;

	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class Main extends MovieClip
	{
		private var buttonFormat:TextFormat;
		private var _soundId1:int = -1;
		private var _soundId2:int = -1;

		public function Main()
		{
			super();

			trace("Version", ANESounds.VERSION);

			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.SHOW_ALL;

			// Create the ANE
			ANESounds.instance;

			createButtons();

			// Preload sounds

			if(ANESounds.isSupportedNatively())
			{
				_soundId1 = ANESounds.instance.loadSound(File.applicationDirectory.resolvePath('include/click.ogg'));
				_soundId2 = ANESounds.instance.loadSound(File.applicationDirectory.resolvePath('include/melody-100-bpm.ogg'));
			}
			else
			{
				_soundId1 = ANESounds.instance.loadSound(File.applicationDirectory.resolvePath('include/click.mp3'));
				_soundId2 = ANESounds.instance.loadSound(File.applicationDirectory.resolvePath('include/melody-100-bpm.mp3'));
			}

		}


		private function createButtons():void
		{
			// Row
			var tf:TextField = createButton("Play Native Sound 1");
			tf.x = 170;
			tf.y = 10;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, playNativeSound1);
			addChild(tf);

			tf = createButton("Play Native Sound 2");
			tf.x = 170;
			tf.y = 60;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, playNativeSound2);
			addChild(tf);

			tf = createButton("Unload Native Sound 1");
			tf.x = 170;
			tf.y = 110;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, unloadNativeSound1);
			addChild(tf);

			tf = createButton("Unload Native Sound 2");
			tf.x = 170;
			tf.y = 160;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, unloadNativeSound2);
			addChild(tf);

			tf = createButton("Stop Native Sound 1");
			tf.x = 170;
			tf.y = 210;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, stopNativeSound1);
			addChild(tf);

			tf = createButton("Stop Native Sound 2");
			tf.x = 170;
			tf.y = 260;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, stopNativeSound2);
			addChild(tf);

			tf = createButton("Set Volume Sound 1");
			tf.x = 170;
			tf.y = 310;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, setVolumeNativeSound1);
			addChild(tf);

			tf = createButton("Set Volume Sound 2");
			tf.x = 170;
			tf.y = 360;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, setVolumeNativeSound2);
			addChild(tf);
		}


		private function playNativeSound1(event:MouseEvent):void
		{
			trace("Sound", _soundId1);
			ANESounds.instance.playSound(_soundId1, 0.4, 0.4);
		}


		private function playNativeSound2(event:MouseEvent):void
		{
			trace("Sound", _soundId2);
			ANESounds.instance.playSound(_soundId2, 0.4, 0.4);
		}


		private function unloadNativeSound1(event:MouseEvent):void
		{
			trace("Unload:", ANESounds.instance.unloadSound(_soundId1));
		}


		private function unloadNativeSound2(event:MouseEvent):void
		{
			trace("Unload:", ANESounds.instance.unloadSound(_soundId2));
		}


		private function stopNativeSound1(event:MouseEvent):void
		{
			trace("Stop sound", _soundId1);

			ANESounds.instance.stopSound(_soundId1);
		}


		private function stopNativeSound2(event:MouseEvent):void
		{
			trace("Stop sound", _soundId2);

			ANESounds.instance.stopSound(_soundId2);
		}


		private function setVolumeNativeSound1(event:MouseEvent):void
		{
			var leftVolume:Number = Math.random();
			var rightVolume:Number = Math.random();
			trace("Set volume for sound", _soundId1, "left volume:", leftVolume, "right volume:", rightVolume);

			ANESounds.instance.setVolume(_soundId1, leftVolume, rightVolume);
		}


		private function setVolumeNativeSound2(event:MouseEvent):void
		{
			var leftVolume:Number = Math.random();
			var rightVolume:Number = Math.random();
			trace("Set volume for sound", _soundId2, "left volume:", leftVolume, "right volume:", rightVolume);

			ANESounds.instance.setVolume(_soundId2, leftVolume, rightVolume);
		}


		private function createButton(label:String):TextField
		{
			if(!buttonFormat)
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