package com.digitalstrawberry.nativeExtensions.anesounds.functions;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.digitalstrawberry.nativeExtensions.anesounds.ANESoundsContext;

public class StopStream implements FREFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        ANESoundsContext soundsContext = (ANESoundsContext) context;
        int streamId;

        try
        {
            streamId = args[0].getAsInt();
            soundsContext.soundPool.stop(streamId);
            return null;
        }
        catch(Exception e)
        {
            Log.e("ANESounds", "Failed to stop stream: " + e.getLocalizedMessage());
        }

        return null;
    }

}

