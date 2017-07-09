package com.digitalstrawberry.nativeExtensions.anesounds
{
	import flash.media.Sound;

	internal class SoundInfo
	{
		private var _id:int;
		private var _sound:Sound;
		private var _streams:Vector.<int>;
		
		public function SoundInfo(id:int, sound:Sound)
		{
			_id = id;
			_sound = sound;
			_streams = new <int>[];
		}


		internal function addStream(streamId:int):void
		{
			_streams[_streams.length] = streamId;
		}


		internal function get streams():Vector.<int>
		{
			return _streams;
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
