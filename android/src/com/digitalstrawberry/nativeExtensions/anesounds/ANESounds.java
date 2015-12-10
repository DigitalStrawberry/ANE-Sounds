package com.digitalstrawberry.nativeExtensions.anesounds;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class ANESounds implements FREExtension
{
	@Override
	public FREContext createContext( String arg0 )
	{
		return new ANESoundsContext();
	}

	@Override
	public void dispose()
	{
	}

	@Override
	public void initialize()
	{
	}
}
