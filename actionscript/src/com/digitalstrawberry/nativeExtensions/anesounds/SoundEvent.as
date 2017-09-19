package com.digitalstrawberry.nativeExtensions.anesounds
{
	import flash.events.Event;
	
	public class SoundEvent extends Event
	{
		public static const LOAD:String = "SoundEvent::load";

		private var mSoundId:int;
		
		public function SoundEvent(type:String, soundId:int)
		{
			super(type, false, false);

			mSoundId = soundId;
		}


		public function get soundId():int
		{
			return mSoundId;
		}
		
	}
	
}
