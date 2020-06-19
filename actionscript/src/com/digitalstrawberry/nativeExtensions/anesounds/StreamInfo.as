package com.digitalstrawberry.nativeExtensions.anesounds
{
	import flash.media.Sound;
	import flash.media.SoundTransform;
	
	internal class StreamInfo
	{

		private var _id:int;
		private var _sound:Sound;
		private var _transform:SoundTransform;
		private var _loop:int;
		
		public function StreamInfo(id:int, sound:Sound, transform:SoundTransform, loop:int)
		{
			_id = id;
			_sound = sound;
			_transform = transform;
			_loop = loop;
		}
		

		public function get id():int
		{
			return _id;
		}


		public function get transform():SoundTransform
		{
			return _transform;
		}


		public function get loop():int
		{
			return _loop;
		}


		public function get sound():Sound
		{
			return _sound;
		}
	}
	
}
