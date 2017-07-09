package com.digitalstrawberry.nativeExtensions.anesounds.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.digitalstrawberry.nativeExtensions.anesounds.ANESoundsContext;

import java.util.ArrayList;
import java.util.List;

public class PlaySound implements FREFunction
{
	@Override
	public FREObject call( FREContext context, FREObject[] args )
	{
		ANESoundsContext soundsContext = (ANESoundsContext) context;
		int soundId;
		float leftVolume, rightVolume;
		int loop;
		float playbackRate;

		try
		{
			soundId = args[0].getAsInt();
			leftVolume = (float) args[1].getAsDouble();
			rightVolume = (float) args[2].getAsDouble();
			loop = args[3].getAsInt();
			playbackRate = (float) args[4].getAsDouble();

			int streamId = soundsContext.soundPool.play(soundId, leftVolume, rightVolume, 1, loop, playbackRate);
            if(streamId != 0)
            {
                List<Integer> soundStreams = soundsContext.soundStreams.get(soundId);
                if(soundStreams == null)
                {
                    soundStreams = new ArrayList<Integer>();
                }
                soundStreams.add(streamId);
                soundsContext.soundStreams.put(soundId, soundStreams);
            }
            return FREObject.newObject(streamId);
		}
		catch(Exception e)
		{
            e.printStackTrace();
		}

		return null;
	}
}
