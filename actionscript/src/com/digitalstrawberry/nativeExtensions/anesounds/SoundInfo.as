package com.digitalstrawberry.nativeExtensions.anesounds
{
	import flash.media.Sound;
	
	internal class SoundInfo
	{
		private var _id:int;
		private var _sound:Sound;
		
		public function SoundInfo(id:int, sound:Sound)
		{
			_id = id;
			_sound = sound;
		}


		internal function get id():int
		{
			return _id;
		}


		internal function get sound():Sound
		{
			return _sound;
		}
		
	}
	
}
