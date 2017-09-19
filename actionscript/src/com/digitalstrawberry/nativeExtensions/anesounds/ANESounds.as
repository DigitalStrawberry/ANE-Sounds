package com.digitalstrawberry.nativeExtensions.anesounds
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;

	public class ANESounds extends EventDispatcher
	{
		public static const VERSION:String = "1.5";
		private static var _instance:ANESounds;
		private static var sMaxStreams:int = 10;
		private static var sStreamId:int = 0;

		private var _extContext:ExtensionContext;

		// Sounds array used for Flash fallback
		private var _soundId:int;
		private var _sounds:Vector.<SoundInfo> = new <SoundInfo>[];
		private var _streams:Dictionary = new Dictionary();

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

				_extContext.addEventListener(StatusEvent.STATUS, onStatus);
				_extContext.call('initialize', sMaxStreams);
			}
		}


		public static function setMaxStreams(value:int):void
		{
			if(value <= 0)
			{
				throw new ArgumentError("The number of streams must be greater than zero.")
			}
			if(_instance != null)
			{
				throw new IllegalOperationError("Maximum streams must be set before calling any other API.");
			}
			sMaxStreams = value;
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
				sound.addEventListener(ProgressEvent.PROGRESS, onSoundLoadProgress, false, 0, true);
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


		private function onSoundLoadProgress(event:ProgressEvent):void
		{
			var perc:Number = event.bytesLoaded / event.bytesTotal;
			if(perc >= 1.0)
			{
				var sound:Sound = event.currentTarget as Sound;
				sound.removeEventListener(ProgressEvent.PROGRESS, onSoundLoadProgress);

				var soundId:int = -1;
				for each(var soundInfo:SoundInfo in _sounds)
				{
					if(soundInfo.sound == sound)
					{
						soundId = soundInfo.id;
						break;
					}
				}

				if(soundId >= 0)
				{
					dispatchEvent(new SoundEvent(SoundEvent.LOAD, soundId));
				}
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


		public function playSound(soundId:int, leftVolume:Number = 1.0, rightVolume:Number = 1.0, loop:int = 0, playbackRate:Number = 1.0):int
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

						sStreamId++;
						var channel:SoundChannel = sound.play(0, loop, soundTransform);
						channel.addEventListener(Event.SOUND_COMPLETE, onSoundChannelCompleted);
						_streams[sStreamId] = channel;
						soundInfo.addStream(sStreamId);
						return sStreamId;
					}
				}
				trace('[ANESounds] Sound with id', soundId, 'not found.');
				return 0;
			}

			return _extContext.call('playSound', soundId, leftVolume, rightVolume, loop, playbackRate) as int;
		}


		public function unloadSound(soundId:int):Boolean
		{
			if(_extContext == null)
			{
				var soundInfo:SoundInfo = getSoundInfo(soundId);
				if(soundInfo != null)
				{
					// Stop all streams for this sound
					for each(var streamId:int in soundInfo.streams)
					{
						if(streamId in _streams)
						{
							trace("[ANESounds] Stopping", streamId, "for sound", soundId);
							stopStream(streamId);
						}
					}

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
				// todo: likely need to stop the native sound first?
				return _extContext.call('unloadSound', soundId) as Boolean;
			}
		}


		public function stopStream(streamId:int):void
		{
			if(_extContext == null)
			{
				if(streamId in _streams)
				{
					SoundChannel(_streams[streamId]).stop();
					deleteStream(streamId);
				}
			}
			else
			{
				_extContext.call('stopStream', streamId);
			}
		}
		
		
		public function setVolume(streamId:int, leftVolume:Number = 1, rightVolume:Number = 1):void
		{
			if(_extContext == null)
			{
				if(streamId in _streams)
				{
					var totalVolume:Number = leftVolume + rightVolume;
					var volume:Number = totalVolume / 2;
					var pan:Number = (rightVolume / totalVolume) - (leftVolume / totalVolume);
					SoundChannel(_streams[streamId]).soundTransform = new SoundTransform(volume, pan);
				}
			}
			else
			{
				_extContext.call('setVolume', streamId, clampVolume(leftVolume), clampVolume(rightVolume));
			}
		}


		private function onStatus(event:StatusEvent):void
		{
			if(event.code == SoundEvent.LOAD)
			{
				var soundId:int = int(event.level);
				if(soundId >= 0)
				{
					dispatchEvent(new SoundEvent(SoundEvent.LOAD, soundId));
				}
			}
		}


		private function onSoundChannelCompleted(event:Event):void
		{
			var channel:SoundChannel = SoundChannel(event.currentTarget);
			for(var streamId:int in _streams)
			{
				if(channel == _streams[streamId])
				{
					deleteStream(streamId);
					return;
				}
			}
		}


		private function deleteStream(streamId:int):void
		{
			var channel:SoundChannel = _streams[streamId];
			channel.removeEventListener(Event.SOUND_COMPLETE, onSoundChannelCompleted);
			delete _streams[streamId];
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
