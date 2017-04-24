package com.digitalstrawberry.nativeExtensions.anesounds.functions;

import android.media.AudioAttributes;
import android.media.AudioManager;
import android.media.SoundPool;
import android.os.Build;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.digitalstrawberry.nativeExtensions.anesounds.ANESoundsContext;

import java.util.HashMap;

public class Initialize implements FREFunction
{
	@Override
	public FREObject call( FREContext context, FREObject[] args )
	{
		ANESoundsContext soundsContext = (ANESoundsContext) context;

        soundsContext.soundToStream = new HashMap<Integer, Integer>();

        // SoundPool constructor is deprecated since API 21
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP)
        {
            AudioAttributes attributes = new AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_GAME)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build();

            soundsContext.soundPool = new SoundPool.Builder()
                    .setAudioAttributes(attributes)
                    .build();
        }
        else
        {
            soundsContext.soundPool = new SoundPool(10, AudioManager.STREAM_MUSIC, 0);
        }
        context.getActivity().setVolumeControlStream(AudioManager.STREAM_MUSIC);

        return null;
    }
}
