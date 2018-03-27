package com.digitalstrawberry.nativeExtensions.anesounds;

import android.media.SoundPool;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.digitalstrawberry.nativeExtensions.anesounds.functions.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ANESoundsContext extends FREContext
{
	public SoundPool soundPool;

    // Sound id mapped to a list of stream ids
    public Map<Integer, List<Integer>> soundStreams;

	ANESoundsContext()
	{

	}

	@Override
	public void dispose()
	{

	}

	@Override
	public Map<String, FREFunction> getFunctions()
	{
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put("initialize", new Initialize());
		functionMap.put("loadSound", new LoadSound());
		functionMap.put("playSound", new PlaySound());
		functionMap.put("unloadSound", new UnloadSound());
		functionMap.put("stopStream", new StopStream());
		functionMap.put("setVolume", new SetVolume());

		return functionMap;
	}
}
