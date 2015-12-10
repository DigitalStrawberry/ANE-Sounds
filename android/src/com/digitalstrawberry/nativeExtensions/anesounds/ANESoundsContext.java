package com.digitalstrawberry.nativeExtensions.anesounds;

import android.media.AudioManager;
import android.media.SoundPool;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.digitalstrawberry.nativeExtensions.anesounds.functions.Initialize;
import com.digitalstrawberry.nativeExtensions.anesounds.functions.LoadSound;
import com.digitalstrawberry.nativeExtensions.anesounds.functions.PlaySound;

import java.util.HashMap;
import java.util.Map;

public class ANESoundsContext extends FREContext
{
	public SoundPool soundPool;

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

		return functionMap;
	}
}
