# multigcc

This is a repo for building a few docker images with different
versions of gcc installed, along with matching cross-compilers
for Windows and OSX.

Note: I distribute what I can for OSX compilation, however,
I can't distribute the OSX SDKs.

In order for OSX to work, you'll need to mount the SDK in
as a volume, at /usr/apple/SDK/, ie:

`-v /opt/sdks/MacOSX10.10.sdk:/usr/apple/SDK/MacOSX10.10.sdk`

To bring in the OSX 10.10 SDK to the right folder.

The osxcross project has tools for extracting the required SDK
from XCode: https://github.com/tpoechtrager/osxcross

I've only tested against the 10.10 SDK so far.

The `base` image is a cross-compiled musl environment, all
the remaining images are bootstrapped from that.

Building all the images can be accomplished by running "make",
it will take a few hours - each image bootstraps itself to verify
everything worked correctly.

Images:

* `gcc-4.9`
* `gcc-5.5`
* `gcc-6.4`
* `gcc-7.2`
