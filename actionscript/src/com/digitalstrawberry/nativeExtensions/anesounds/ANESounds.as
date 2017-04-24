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
		public static const VERSION:String = "1.3";
		private static var _instance:ANESounds;

		private var _extContext:ExtensionContext;

		// Sounds array used for Flash fallback
		private var _soundId:int;
		private var _sounds:Vector.<SoundInfo> = new <SoundInfo>[];

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

				_sounds.push(new SoundInfo(_soundId, sound));
				return _soundId++;
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
				for each(var soundInfo:SoundInfo in _sounds)
				{
					if(soundInfo.id == soundId)
					{
						var sound:Sound = soundInfo.sound;

						var totalVolume:Number = leftVolume + rightVolume;
						var volume:Number = totalVolume / 2;
						var pan:Number = (rightVolume / totalVolume) - (leftVolume / totalVolume);
						var soundTransform:SoundTransform = new SoundTransform(volume, pan);
						if(soundInfo.channel != null)
						{
							soundInfo.channel.stop();
						}
						soundInfo.channel = sound.play(0, loop, soundTransform);
						return;
					}
				}
				trace('[ANESounds] Sound with id', soundId, 'not found.');
			}
			else
			{
				_extContext.call('playSound', soundId, leftVolume, rightVolume, loop, playbackRate);
			}
		}


		public function unloadSound(soundId:int):Boolean
		{
			stopSound(soundId);

			if(_extContext == null)
			{
				var soundInfo:SoundInfo = getSoundInfo(soundId);
				if(soundInfo != null)
				{
					try
					{
						soundInfo.sound.close()
					}
					catch (error:Error) {}
					_sounds.removeAt(_sounds.indexOf(soundInfo));
				}
				return soundInfo != null;
			}
			else
			{
				return _extContext.call('unloadSound', soundId) as Boolean;
			}
		}


		public function stopSound(streamId:int):void
		{
			if(_extContext == null)
			{
				var soundInfo:SoundInfo = getSoundInfo(streamId);
				if(soundInfo != null && soundInfo.channel != null)
				{
					soundInfo.channel.stop();
				}
			}
			else
			{
				_extContext.call('stopSound', streamId);
			}
		}
		
		
		public function setVolume(streamId:int, leftVolume:Number = 1, rightVolume:Number = 1):void
		{
			if(_extContext == null)
			{
				var soundInfo:SoundInfo = getSoundInfo(streamId);
				if(soundInfo != null && soundInfo.channel != null)
				{
					var totalVolume:Number = leftVolume + rightVolume;
					var volume:Number = totalVolume / 2;
					var pan:Number = (rightVolume / totalVolume) - (leftVolume / totalVolume);
					soundInfo.channel.soundTransform = new SoundTransform(volume, pan);
				}
			}
			else
			{
				_extContext.call('setVolume', streamId, clampVolume(leftVolume), clampVolume(rightVolume));
			}
		}
		
		
		private function clampVolume(volume:Number):Number
		{
			if(volume > 1)
			{
				return 1;
			}
			if(volume < 0)
			{
				return 0;
			}
			return volume;
		}


		private function getSoundInfo(soundId:int):SoundInfo
		{
			for each(var soundInfo:SoundInfo in _sounds)
			{
			    if(soundInfo.id == soundId)
			    {
				    return soundInfo;
			    }
			}
			return null;
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
