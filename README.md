# multigcc

This is a repo for building a few docker images with different
versions of gcc installed.

The `base` image is a cross-compiled musl environment, all
the remaining images are bootstrapped from that.

Images:

* `gcc-4.9`
* `gcc-5.5`
* `gcc-6.4`
* `gcc-7.2`
