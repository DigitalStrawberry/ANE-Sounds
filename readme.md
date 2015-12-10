# ANE-Sounds

A simple ANE (Air Native Extension) to play sounds on Android.

### Overview

Adobe's Air platform has difficulty playing sounds correctly on Android devices. The sounds are often delayed or do not play at all. This extension is designed to fix these issues and play short sound effects.

### Future Plans

Right now this extension is very basic and only works on Android. The goal is to eventually re-write the extension to extend Air's ```Sound``` class and provide the same functionality. We would also like to support iOS devices in the future as well, since we have experienced some sound issues on iOS as well.

### Usage

You can grab the ANE from the ```/bin``` folder of the repo.

After including the ANE in your project, you'll need to package a sound file in your application's package. You can embed mp3, wav or ogg files. Note that this extension only works for sound files that have been embedded into the application package.

Load the sound using the ANE:

```
var soundId:int = ANESounds.instance.loadSound("click-sound.ogg");
```

Now you can play the sound using the ```soundId``` that was returned:

```
ANESounds.instance.playSound(soundId);
```
The extension also supports more advanced playback options:

```
ANESounds.instance.playSound(soundId:int, leftVolume:Number = 1.0, rightVolume:Number = 1.0, loop:int = 0, playbackRate:int = 1.0);
```

### Multiple Platforms

Since the extension only works for Android right now, you'll want to use the native AIR ```Sound``` class for playing sounds on other platforms.

```
if(ANESounds.isSupported())
{
	ANESounds.instance.playSound(1);
}
else
{
	// Use another method to play sounds
}
```

