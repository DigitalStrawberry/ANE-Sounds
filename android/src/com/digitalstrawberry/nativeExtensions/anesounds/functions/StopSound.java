package com.digitalstrawberry.nativeExtensions.anesounds.functions;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.digitalstrawberry.nativeExtensions.anesounds.ANESoundsContext;

public class StopSound implements FREFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        ANESoundsContext soundsContext = (ANESoundsContext) context;
        int soundId;

        try
        {
            soundId = args[0].getAsInt();
            Integer streamId = soundsContext.soundToStream.get(soundId);
            if(streamId != null)
            {
                soundsContext.soundPool.stop(streamId);
            }
            return null;
        }
        catch(Exception e)
        {
            Log.e("ANESounds", "Failed to stop sound: " + e.getLocalizedMessage());
        }

        return null;
    }

}

