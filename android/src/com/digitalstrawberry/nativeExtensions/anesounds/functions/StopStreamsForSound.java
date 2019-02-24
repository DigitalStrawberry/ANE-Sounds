package com.digitalstrawberry.nativeExtensions.anesounds.functions;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.digitalstrawberry.nativeExtensions.anesounds.ANESoundsContext;

import java.util.List;

public class StopStreamsForSound implements FREFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        ANESoundsContext soundsContext = (ANESoundsContext) context;
        int soundId;

        try
        {
            soundId = args[0].getAsInt();
            if(soundsContext.soundStreams.containsKey(soundId))
            {
                List<Integer> streams = soundsContext.soundStreams.get(soundId);
                for(Integer streamId : streams)
                {
                    soundsContext.soundPool.stop(streamId);
                }
            }
            return null;
        }
        catch(Exception e)
        {
            Log.e("ANESounds", "Failed to stop stream: " + e.getLocalizedMessage());
        }

        return null;
    }

}

