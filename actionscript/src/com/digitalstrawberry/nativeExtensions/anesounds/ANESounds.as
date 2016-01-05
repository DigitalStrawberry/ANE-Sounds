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


		public function loadSound(file:File):int
		{
			if(_extContext == null)
			{
				return -1;
			}

			if(!file.exists)
			{
				throw new Error('Sound file ' + file.url + ' does not exist');
			}

			var returnObject:Object = _extContext.call('loadSound', getNativePath(file));
			if(returnObject == null)
			{
				return -1;
			}

			return int(returnObject);
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
