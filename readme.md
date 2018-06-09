# ANE-Sounds

A simple ANE (Air Native Extension) to play sounds on Android.

### Overview

Adobe's Air platform has difficulty playing sounds correctly on Android devices. The sounds are often delayed or do not play at all. This extension is designed to fix these issues and play short sound effects.

### Usage

You can grab the ANE from the ```/bin``` folder of the repo or on the [releases](https://github.com/DigitalStrawberry/ANE-Sounds/releases) page of the repo.

After including the ANE in your project you'll need to reference a sound with a ```File``` object. The sound file can be embedded into your application or downloaded to an external directory. The extension can play mp3, wav or ogg files on Android, however it can only play mp3 files on non-Android platforms.

On Android it is allowed to run 10 sound streams simultaneously by default. If you play more streams than that, the oldest streams will be stopped. You can increase this limit by calling the `setMaxStreams` method. Note you must call it before using any other API:

```as3
ANESounds.setMaxStreams(30);
```

Load the sound using the ANE:

```as3
var soundFile:File = File.applicationDirectory.resolvePath("click-sound.mp3");
var soundId:int = ANESounds.instance.loadSound(soundFile);
```

Note the sound may not be available to be played immediately after the `loadSound` method is called. You can add an event listener to find out when a sound is loaded:

```as3
ANESounds.instance.addEventListener(SoundEvent.LOAD, onSoundLoaded);
var soundId:int = ANESounds.instance.loadSound(...);

private function onSoundLoaded(event:SoundEvent):void
{
    trace("Sound", event.soundId, "loaded");
}
```

Once the sound is loaded, you can play it by providing the ```soundId``` that was returned by the `loadSound` method or the `SoundEvent` object:

```as3
ANESounds.instance.playSound(soundId);
```

The extension also supports more advanced playback options:

```as3
ANESounds.instance.playSound(soundId:int, leftVolume:Number = 1.0, rightVolume:Number = 1.0, loop:int = 0, playbackRate:int = 1.0);
```

**Note:** The ```playbackRate``` parameter is not currently supported on non-Android platforms and will always default to ```1.0```.

The `playSound` method returns a *stream id*. You need to keep a reference to this value to be able to further interact with the stream. To stop a currently playing stream, call the `stopStream` method:

```as3
var streamId:int = ANESounds.instance.playSound(soundId);

if(streamId != 0)
{
	ANESounds.instance.stopStream(streamId);
}
```

You can also change the volume of a stream by calling the `setVolume` method. The volume values should be in range from 0 to 1.

```as3
ANESounds.instance.setVolume(streamId, leftVolume, rightVolume);
```

You can unload a sound by passing its id to the `unloadSound` method. All active streams for the given sound will be stopped as well. The method returns `true` if the sound for the given id was found. Note the sound is not immediately removed from the memory on non-Android platforms; it will be removed during the next garbage collection.

```as3
var unloaded:Boolean = ANESounds.instance.unloadSound(soundId);
trace(unloaded);
```

### Multiple Platforms

While the extension is designed for native Android use, it will fall back to using the as3 ```Sound``` object on non-supported platforms. Note that you can only use mp3 sounds if you wish to use the native as3 fallback functionality.

If you'd like to only use mp3 sounds on fallback, you can use the ```isSupportedNatively``` method:

```as3
// Android devices
if(ANESounds.isSupportedNatively())
{
	ANESounds.instance.loadSound(File.applicationDirectory.resolvePath("click.ogg"));	
}
// All other platforms
else
{
	ANESounds.instance.loadSound(File.applicationDirectory.resolvePath("click.mp3"));
}
```

### Changelog

#### v1.7 (06/09/2018)

* Fixed issue with identical sound file names (Android)

#### v1.6 (03/27/2018)

* Fixed `stopStream` method on Android

#### v1.5 (09/19/2017)

* Updated Android implementation with queued sound loading

#### v1.4 (07/09/2017)

Added support for multiple streams

* Added static method `setMaxStreams`
* Renamed `stopSound` method to `stopStream`

#### v1.3 (04/24/2017)

* Added `stopSound` and `setVolume` APIs

#### v1.2 (02/09/2017)

* Added `unloadSound` API

#### v1.1 (07/11/2016)

* Added native as3 fallback support for non-supported platforms
* The ```isSupported``` method now returns true for all platforms. Note that this may break existing code if you are not using mp3 sounds, as the native as3 code can only play mp3. Use the method ```isSupportedNatively``` to determine if the native Android code will be used to play a sound.
* Added ```isSupportedNatively``` method to determine if the native Android code will be used to play the sound.

#### v1.0 (01/04/2016)

* Added the ability to play sounds stored in any location using a ```File``` object

