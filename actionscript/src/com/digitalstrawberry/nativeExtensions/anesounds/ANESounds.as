package com.digitalstrawberry.nativeExtensions.anesounds
{
	import flash.external.ExtensionContext;
	import flash.filesystem.File;
	import flash.system.Capabilities;

	public class ANESounds
	{
		private static var _instance:ANESounds;

		private var _extContext:ExtensionContext;

		public function ANESounds()
		{
			if(!_instance)
			{
				_instance = this;
			}
			else
			{
				throw new Error('Class is a singleton');
			}

			if(_android)
			{
				_extContext = ExtensionContext.createExtensionContext('com.digitalstrawberry.nativeExtensions.ANESounds', null);
				if(_extContext == null)
				{
					throw new Error('Extension context could not be created!');
				}

				_extContext.call('initialize');
			}
		}


		public function loadSound(path:String):int
		{
			if(_extContext == null)
			{
				return -1;
			}

			var file:File = File.applicationDirectory.resolvePath(path);
			if(!file.exists)
			{
				throw new Error('Sound file ' + file.url + ' does not exist');
			}

			var newFilename:String = path.replace('/', '_');
			file.copyTo(File.applicationStorageDirectory.resolvePath(newFilename), true);
			var filePath:String = File.applicationStorageDirectory.nativePath + "/" + newFilename;

			var returnObject:Object = _extContext.call('loadSound', filePath);
			if(returnObject == null)
			{
				return -1;
			}

			return int(returnObject);
		}


		public function playSound(soundId:int, leftVolume:Number = 1.0, rightVolume:Number = 1.0, loop:int = 0, playbackRate:Number = 1.0):void
		{
			if(_extContext == null)
			{
				return;
			}

			_extContext.call('playSound', soundId, leftVolume, rightVolume, loop, playbackRate);
		}


		private static function get _android():Boolean
		{
			return Capabilities.manufacturer.indexOf("Android") > -1;
		}


		public static function isSupported():Boolean
		{
			return _android;
		}


		public static function get instance():ANESounds
		{
			return _instance ? _instance : new ANESounds();
		}

	}
}
