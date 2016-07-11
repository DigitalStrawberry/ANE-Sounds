package com.digitalstrawberry.nativeExtensions.anesounds
{
	import flash.external.ExtensionContext;
	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.Capabilities;

	public class ANESounds
	{
		private static var _instance:ANESounds;

		private var _extContext:ExtensionContext;

		// Sounds array used for Flash fallback
		private var _sounds:Array = [];

		public function ANESounds()
		{
			if(!_instance)
			{
				_instance = this;
			}
			else
			{
				throw new Error('Class is a singleton, use ANESounds.instance instead');
			}

			if(isSupportedNatively())
			{
				_extContext = ExtensionContext.createExtensionContext('com.digitalstrawberry.nativeExtensions.ANESounds', null);
				if(_extContext == null)
				{
					throw new Error('Extension context could not be created!');
				}

				_extContext.call('initialize');
			}
		}


		public function loadSound(file:File):int
		{
			if(!file.exists)
			{
				throw new Error('Sound file ' + file.url + ' does not exist');
			}

			// Fallback to Flash
			if(_extContext == null)
			{
				var sound:Sound = new Sound();
				sound.load(new URLRequest(file.url));

				_sounds.push(sound);
				return _sounds.length - 1;
			}
			// Load the file natively
			else
			{
				var returnObject:Object = _extContext.call('loadSound', getNativePath(file));
				if(returnObject == null)
				{
					return -1;
				}

				return int(returnObject);
			}
		}


		private function getNativePath(file:File):String
		{
			// Files located in the Application directory need to be moved so they can be properly read by the ANE.
			// This is due to a bug in AIR that compresses embedded media assets in the Android package, even though
			// the Android documentation states that these assets should not be compressed.
			if(file.nativePath == "")
			{
				var tmpArray:Array = file.url.split('/');
				var filename:String = tmpArray.pop();

				var newFilename:String = filename.replace('/', '_');
				var newFile:File = File.applicationStorageDirectory.resolvePath(newFilename);

				file.copyTo(newFile, true);
				return newFile.nativePath;
			}

			return file.nativePath;
		}


		public function playSound(soundId:int, leftVolume:Number = 1.0, rightVolume:Number = 1.0, loop:int = 0, playbackRate:Number = 1.0):void
		{
			if(_extContext == null)
			{
				if(_sounds.length > soundId)
				{
					var sound:Sound = _sounds[soundId];

					var totalVolume:Number = leftVolume + rightVolume;
					var volume:Number = totalVolume / 2;
					var pan:Number = (rightVolume / totalVolume) - (leftVolume / totalVolume);
					var soundTransform:SoundTransform = new SoundTransform(volume, pan);

					sound.play(0, loop, soundTransform);
				}
			}
			else
			{
				_extContext.call('playSound', soundId, leftVolume, rightVolume, loop, playbackRate);
			}
		}


		private static function get _android():Boolean
		{
			return Capabilities.manufacturer.indexOf("Android") > -1;
		}


		public static function isSupported():Boolean
		{
			return true;
		}


		public static function isSupportedNatively():Boolean
		{
			return _android;
		}


		public static function get instance():ANESounds
		{
			return _instance ? _instance : new ANESounds();
		}

	}
}
