.PHONY: all gcc-4-image gcc-5-image gcc-6-image gcc-7-image clean gcc-4 gcc-5 gcc-6 gcc-7

BUILDOPTS = --no-cache

all: gcc-4-image gcc-5-image gcc-6-image gcc-7-image

gcc-4: gcc-4-image

gcc-5: gcc-5-image

gcc-6: gcc-6-image

gcc-7: gcc-7-image

base-image:
	docker build --pull -t jprjr/multigcc:base base

gcc-4-image: base-image
	docker build $(BUILDOPTS) --build-arg GCCPKG=gcc4 -t jprjr/multigcc:4 gcc

gcc-5-image: base-image
	docker build $(BUILDOPTS) --build-arg GCCPKG=gcc5 -t jprjr/multigcc:5 gcc

gcc-6-image: base-image
	docker build $(BUILDOPTS) --build-arg GCCPKG=gcc6 -t jprjr/multigcc:6 gcc

gcc-7-image: base-image
	docker build $(BUILDOPTS) --build-arg GCCPKG=gcc7 -t jprjr/multigcc:7 gcc

clean:
	docker rmi jprjr/multigcc:7 jprjr/multigcc:6 jprjr/multigcc:5 jprjr/multigcc:4 jprjr/multigcc:base || true
