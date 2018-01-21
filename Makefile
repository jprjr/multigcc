.PHONY: all gcc-4.9-image gcc-5.5-image gcc-6.4-image gcc-7.2-image clean

BUILDOPTS = --no-cache

all: gcc-4.9-image gcc-5.5-image gcc-6.4-image gcc-7.2-image

base-image:
	docker build --pull -t jprjr/multigcc:base base

gcc-4.9-image: base-image
	docker build $(BUILDOPTS) -t jprjr/multigcc:4.9 gcc-4.9

gcc-5.5-image: base-image
	docker build $(BUILDOPTS) -t jprjr/multigcc:5.5 gcc-5.5

gcc-6.4-image: base-image
	docker build $(BUILDOPTS) -t jprjr/multigcc:6.4 gcc-6.4

gcc-7.2-image: base-image
	docker build $(BUILDOPTS) -t jprjr/multigcc:7.2 gcc-7.2

clean:
	docker rmi jprjr/multigcc:7.2 jprjr/multigcc:6.4 jprjr/multigcc:5.5 jprjr/multigcc:4.9 jprjr/multigcc:base
