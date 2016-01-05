# ANE-Sounds

A simple ANE (Air Native Extension) to play sounds on Android.

### Overview

Adobe's Air platform has difficulty playing sounds correctly on Android devices. The sounds are often delayed or do not play at all. This extension is designed to fix these issues and play short sound effects.

### Future Plans

Right now this extension is very basic and only works on Android. The goal is to eventually re-write the extension to extend Air's ```Sound``` class and provide the same functionality. We would also like to support iOS devices in the future as well, since we have experienced some sound issues on iOS as well.

### Usage

You can grab the ANE from the ```/bin``` folder of the repo or on the [releases](https://github.com/DigitalStrawberry/ANE-Sounds/releases) page of the repo.

After including the ANE in your project you'll need to reference a sound with a ```File``` object. The sound file can be embedded into your application or downloaded to an external directory. The extension can play mp3, wav or ogg files.


Load the sound using the ANE:

```
var soundFile:File = File.applicationDirectory.resolvePath("click-sound.ogg");
var soundId:int = ANESounds.instance.loadSound(soundFile);
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

### Changelog

#### v1.0 (01/04/2015)
- Added the ability to play sounds stored in any location using a ```File``` object

