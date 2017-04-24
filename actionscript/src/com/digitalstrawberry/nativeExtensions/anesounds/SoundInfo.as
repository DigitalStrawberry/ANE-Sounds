package com.digitalstrawberry.nativeExtensions.anesounds
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	internal class SoundInfo
	{
		private var _id:int;
		private var _sound:Sound;
		private var _channel:SoundChannel;
		
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
		

		public function get channel():SoundChannel
		{
			return _channel;
		}


		public function set channel(value:SoundChannel):void
		{
			_channel = value;
		}
	}
	
}
