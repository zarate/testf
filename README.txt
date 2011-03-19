Welcome to TestF!

TestF is a benchmark for Flash devices running FlashPlayer >= 10.1.

** Running the benchmark

Depending on the device your want to test, you have several options:

a) Run a simple swf.
b) Run an AIR file.
c) Run an APK file (Android devices)

** Compiling the benchmark

If you want to add more tests or make some modifications, you are going to need to recompile. 

You need Java, Ant and the FlexSDK to compile, so install / download them on your machine.

Then:

1) Make a copy of developer.properties.sample in the properties folder and rename it to developer.properties
2) Edit the paths and variables defined in developer.properties to point to the real localtions/values in your machine.
3) Call Ant either:
	a) From Eclipse: drag build.xml to the Ant tab and double click on it.
	b) From the console: browse to TestF's root folder and simply type "ant" (no quotes)
	c) By default only the SWF is recompiled, so if you want to compile AIR or Android files call Ant specifiying the target. For example: ant compile-android. Values are compile-android, compile-air, compile-swf, compile-all
