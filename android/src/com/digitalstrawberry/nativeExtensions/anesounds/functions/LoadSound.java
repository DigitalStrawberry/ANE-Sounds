package com.digitalstrawberry.nativeExtensions.anesounds.functions;

import android.media.SoundPool;
import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.digitalstrawberry.nativeExtensions.anesounds.ANESoundsContext;
import com.digitalstrawberry.nativeExtensions.anesounds.SoundEvent;

import java.util.LinkedList;
import java.util.Queue;

public class LoadSound implements FREFunction, SoundPool.OnLoadCompleteListener
{
    private static int sSoundId = 1;

    private ANESoundsContext mContext;
    private Queue<String> mLoadQueue = new LinkedList<String>();
    private boolean mIsLoading = false;

	@Override
	public FREObject call( FREContext context, FREObject[] args )
	{
        mContext = (ANESoundsContext) context;
        mContext.soundPool.setOnLoadCompleteListener(this);

		try
		{
            String path = args[0].getAsString();

            if(mIsLoading)
            {
                mLoadQueue.add(path);
                return FREObject.newObject(sSoundId++);
            }

            mIsLoading = true;
            mLoadQueue.add(path);
            loadNextSound();

			return FREObject.newObject(sSoundId++);
		}
		catch(Exception e)
		{
			Log.i("SoundsANE", "Sound file not found!");
			Log.i("SoundsANE", e.getMessage());
		}

		return null;
	}

    private void loadNextSound()
    {
        if(mLoadQueue.size() == 0)
        {
            mIsLoading = false;
            return;
        }

        String path = mLoadQueue.remove();
        mContext.soundPool.load(path, 1);
    }

    @Override
    public void onLoadComplete(SoundPool soundPool, int sampleId, int status)
    {
        mContext.dispatchStatusEventAsync(SoundEvent.LOAD, String.valueOf(sampleId));
        loadNextSound();
    }
}
