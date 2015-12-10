package com.digitalstrawberry.nativeExtensions.anesounds.functions;

import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.media.AudioManager;
import android.media.SoundPool;
import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.digitalstrawberry.nativeExtensions.anesounds.ANESoundsContext;

import java.io.*;

public class LoadSound implements FREFunction
{
	@Override
	public FREObject call( FREContext context, FREObject[] args )
	{
		ANESoundsContext soundsContext = (ANESoundsContext) context;
		String path = null;

		AssetManager assetManager = context.getActivity().getAssets();

		try
		{
			path = args[0].getAsString();
			int soundId = soundsContext.soundPool.load(path, 1);

			return FREObject.newObject(soundId);
		}
		catch(Exception e)
		{
			Log.i("ANE Test", "Sound file not found!");
			Log.i("ANE Test", e.getMessage());
		}

		return null;
	}
}
