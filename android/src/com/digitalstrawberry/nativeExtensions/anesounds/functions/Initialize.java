package com.digitalstrawberry.nativeExtensions.anesounds.functions;

import android.media.AudioAttributes;
import android.media.AudioManager;
import android.media.SoundPool;
import android.os.Build;
import android.util.Log;
import com.adobe.fre.*;
import com.digitalstrawberry.nativeExtensions.anesounds.ANESoundsContext;

import java.util.HashMap;
import java.util.List;

public class Initialize implements FREFunction
{
	@Override
	public FREObject call( FREContext context, FREObject[] args )
	{
		ANESoundsContext soundsContext = (ANESoundsContext) context;

        soundsContext.soundStreams = new HashMap<Integer, List<Integer>>();

        int maxStreams = 1;
        try
        {
            maxStreams = args[0].getAsInt();
        } catch (Exception e)
        {
            e.printStackTrace();
        }

        // SoundPool constructor is deprecated since API 21
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP)
        {
            AudioAttributes attributes = new AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_GAME)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build();

            soundsContext.soundPool = new SoundPool.Builder()
                    .setAudioAttributes(attributes)
                    .setMaxStreams(maxStreams)
                    .build();
        }
        else
        {
            soundsContext.soundPool = new SoundPool(maxStreams, AudioManager.STREAM_MUSIC, 0);
        }
        context.getActivity().setVolumeControlStream(AudioManager.STREAM_MUSIC);

        return null;
    }
}
