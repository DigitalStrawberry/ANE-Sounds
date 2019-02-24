package com.digitalstrawberry.nativeExtensions.anesounds.functions;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.digitalstrawberry.nativeExtensions.anesounds.ANESoundsContext;

import java.util.List;
import java.util.Map;

public class StopAllStreams implements FREFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        ANESoundsContext soundsContext = (ANESoundsContext) context;

        try
        {
            for(Map.Entry<Integer, List<Integer>> entry : soundsContext.soundStreams.entrySet())
            {
                List<Integer> streams = entry.getValue();
                for(Integer streamId : streams)
                {
                    soundsContext.soundPool.stop(streamId);
                }
                streams.clear();
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

