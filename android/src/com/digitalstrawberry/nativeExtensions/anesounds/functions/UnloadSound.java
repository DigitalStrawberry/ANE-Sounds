package com.digitalstrawberry.nativeExtensions.anesounds.functions;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.digitalstrawberry.nativeExtensions.anesounds.ANESoundsContext;

import java.util.List;

public class UnloadSound implements FREFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        ANESoundsContext soundsContext = (ANESoundsContext) context;
        int soundId;

        try
        {
            soundId = args[0].getAsInt();

            // Stop all streams for this sound
            List<Integer> streams = soundsContext.soundStreams.get(soundId);
            if(streams != null)
            {
                for (Integer streamId : streams)
                {
                    soundsContext.soundPool.stop(streamId);
                }
                soundsContext.soundStreams.remove(soundId);
            }

            return FREObject.newObject(soundsContext.soundPool.unload(soundId));
        }
        catch(Exception e)
        {
            Log.e("ANESounds", "Failed to unload sound: " + e.getLocalizedMessage());
        }

        return null;
    }

}

