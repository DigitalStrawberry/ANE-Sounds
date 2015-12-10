package com.digitalstrawberry.nativeExtensions.anesounds.functions;

import android.media.AudioManager;
import android.media.SoundPool;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.digitalstrawberry.nativeExtensions.anesounds.ANESoundsContext;

public class Initialize implements FREFunction
{
	@Override
	public FREObject call( FREContext context, FREObject[] args )
	{
		ANESoundsContext soundsContext = (ANESoundsContext) context;

		soundsContext.soundPool = new SoundPool(10, AudioManager.STREAM_MUSIC, 0);
		context.getActivity().setVolumeControlStream(AudioManager.STREAM_MUSIC);

		return null;
	}
}
