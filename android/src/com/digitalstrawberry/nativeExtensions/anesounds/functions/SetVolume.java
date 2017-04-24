package com.digitalstrawberry.nativeExtensions.anesounds.functions;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.digitalstrawberry.nativeExtensions.anesounds.ANESoundsContext;

public class SetVolume implements FREFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        ANESoundsContext soundsContext = (ANESoundsContext) context;

        try
        {
            int soundId = args[0].getAsInt();
            float leftVolume = (float) args[1].getAsDouble();
            float rightVolume = (float) args[2].getAsDouble();

            Integer streamId = soundsContext.soundToStream.get(soundId);
            if(streamId != null)
            {
                soundsContext.soundPool.setVolume(streamId, leftVolume, rightVolume);
            }
        }
        catch(Exception e)
        {
            Log.e("ANESounds", "Failed to set sound volume: " + e.getLocalizedMessage());
        }

        return null;
    }

}

