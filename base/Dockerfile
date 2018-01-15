FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y \
      help2man \
      gcc \
      g++ \
      git \
      make \
      wget \
      curl \
      cmake \
      python \
      patch \
      xz-utils \
      bzip2 \
      zlib1g-dev \
      automake \
      autoconf \
      autogen \
      autopoint \
      libtool \
      pkg-config \
      bison \
      flex \
      texinfo \
      libncurses5-dev \
      libreadline6-dev \
      libltdl-dev \
      libgmp-dev \
      libunistring-dev \
      libgc-dev \
      gettext \
      libffi-dev && \
    mkdir -p /opt/root/var/db/pm && \
    mkdir -p /opt/root/var/cache/pm/ && \
    git clone https://github.com/jprjr/multigcc-ports /src/ports

# first build a cross-compiler
RUN git clone https://github.com/just-containers/musl-cross-make.git /src/musl-cross-make && \
    cd /src/musl-cross-make && \
    echo "TARGET = x86_64-pc-linux-musl" > config.mak && \
    echo "COMMON_CONFIG += --disable-nls" >> config.mak && \
    echo "COMMON_CONFIG += CFLAGS=\"-g0 -Os\" CXXFLAGS=\"-g0 -Os\" LDFLAGS=\"-s\"" >> config.mak && \
    echo "GCC_CONFIG += --enable-languages=c,c++" >> config.mak && \
    echo "GCC_CONFIG += --disable-libquadmath --disable-decimal-float" >> config.mak && \
    echo "GCC_CONFIG += --disable-multilib --with-system-zlib" >> config.mak && \
    echo "ZLIB_VER = 1.2.11" >> config.mak && \
    echo "BINUTILS_VER = 2.28.1" >> config.mak && \
    echo "GCC_VER = 4.9.4" >> config.mak && \
    echo "MUSL_VER = 1.1.18" >> config.mak && \
    echo "GMP_VER = 6.1.2" >> config.mak && \
    echo "MPC_VER = 1.0.3" >> config.mak && \
    echo "MPFR_VER = 3.1.6" >> config.mak && \
    echo "ISL_VER = 0.18" >> config.mak && \
    echo "LINUX_VER = 4.4.10" >> config.mak && \
    make \
      OUTPUT=/opt/gcc-cross install && \
    make clean && \
    cd /

RUN curl -R -L -o /src/musl-1.1.18.tar.gz https://www.musl-libc.org/releases/musl-1.1.18.tar.gz && \
    echo "d017ee5d01aec0c522a1330fdff06b1e428cb409e1db819cc4935d5da4a5a118  /src/musl-1.1.18.tar.gz" | sha256sum -c && \
    tar xf /src/musl-1.1.18.tar.gz -C /src && \
    cd /src/musl-1.1.18 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CROSS_COMPOILE="x86_64-pc-linux-musl-" \
    ./configure \
      --target=x86_64-pc-linux-musl \
      --host=x86_64-pc-linux-musl \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/musl-1.1.18.pkg" install && \
    cd /tmp/musl-1.1.18.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"musl@1.1.18.txz" && \
    cd / && \
    rm -rf /src/musl-1.1.18

RUN curl -R -L -o /src/zlib-1.2.11.tar.gz https://zlib.net/zlib-1.2.11.tar.gz && \
    echo "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1  /src/zlib-1.2.11.tar.gz" | sha256sum -c && \
    tar xf /src/zlib-1.2.11.tar.gz -C /src && \
    mv /src/zlib-1.2.11 /src/zlib-cross && \
    cd /src/zlib-cross && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CC="/opt/gcc-cross/bin/x86_64-pc-linux-musl-gcc" \
    AR="/opt/gcc-cross/bin/x86_64-pc-linux-musl-ar" \
    RANLIB="/opt/gcc-cross/bin/x86_64-pc-linux-musl-ranlib" \
    CFLAGS="-g0 -Os -fPIC" \
    ./configure --static --prefix=/x86_64-pc-linux-musl && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR=/opt/gcc-cross install && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CC="/opt/gcc-cross/bin/x86_64-pc-linux-musl-gcc" \
    AR="/opt/gcc-cross/bin/x86_64-pc-linux-musl-ar" \
    RANLIB="/opt/gcc-cross/bin/x86_64-pc-linux-musl-ranlib" \
    CFLAGS="-g0 -Os -fPIC" \
    ./configure --prefix=/x86_64-pc-linux-musl && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR=/opt/gcc-cross install && \
    make clean && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CC="/opt/gcc-cross/bin/x86_64-pc-linux-musl-gcc" \
    AR="/opt/gcc-cross/bin/x86_64-pc-linux-musl-ar" \
    RANLIB="/opt/gcc-cross/bin/x86_64-pc-linux-musl-ranlib" \
    CFLAGS="-g0 -Os -fPIC" \
    ./configure --static --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR=/tmp/zlib-1.2.11.pkg install && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CC="/opt/gcc-cross/bin/x86_64-pc-linux-musl-gcc" \
    AR="/opt/gcc-cross/bin/x86_64-pc-linux-musl-ar" \
    RANLIB="/opt/gcc-cross/bin/x86_64-pc-linux-musl-ranlib" \
    CFLAGS="-g0 -Os -fPIC" \
    ./configure --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR=/tmp/zlib-1.2.11.pkg install && \
    cd /tmp/zlib-1.2.11.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"zlib@1.2.11.txz" && \
    cd / && \
    rm -rf /src/zlib-cross /tmp/zlib-1.2.11.pkg

RUN curl -R -L -o /src/gcc-4.9.4.tar.bz2 https://ftp.gnu.org/gnu/gcc/gcc-4.9.4/gcc-4.9.4.tar.bz2 && \
    curl -R -L -o /src/mpfr-3.1.6.tar.xz http://www.mpfr.org/mpfr-3.1.6/mpfr-3.1.6.tar.xz && \
    curl -R -L -o /src/mpc-1.0.3.tar.gz ftp://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz && \
    curl -R -L -o /src/gmp-6.1.2.tar.xz https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz && \
    curl -R -L -o /src/isl-0.18.tar.xz http://isl.gforge.inria.fr/isl-0.18.tar.xz && \
    exit 0

RUN tar xf /src/gcc-4.9.4.tar.bz2 -C /src && \
    tar xf /src/mpfr-3.1.6.tar.xz -C /src && \
    tar xf /src/mpc-1.0.3.tar.gz -C /src && \
    tar xf /src/gmp-6.1.2.tar.xz -C /src && \
    tar xf /src/isl-0.18.tar.xz -C /src && \
    mv /src/mpfr-3.1.6 /src/gcc-4.9.4/mpfr && \
    mv /src/mpc-1.0.3 /src/gcc-4.9.4/mpc && \
    mv /src/gmp-6.1.2 /src/gcc-4.9.4/gmp && \
    mv /src/isl-0.18 /src/gcc-4.9.4/isl && \
    cd /src/gcc-4.9.4 && \
    for p in /src/musl-cross-make/patches/gcc-4.9.4/*.diff ; do \
        patch -p1 -i "${p}" ; \
    done

RUN mkdir /src/gcc-build && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    /src/gcc-4.9.4/configure \
      --with-system-zlib \
      --target=x86_64-pc-linux-musl \
      --host=x86_64-pc-linux-musl \
      --with-system-zlib \
      --disable-nls \
      --disable-multilib \
      --disable-libquadmath \
      --disable-werror \
      --enable-tls \
      --enable-deterministic-archives \
      --disable-libmudflap \
      --disable-libsanitizer \
      --disable-gnu-indirect-function \
      --disable-libmpx \
      --enable-libstdcxx-time \
      --enable-languages=c,c++ \
      --enable-__cxa_atexit \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/gcc-4.9.4.pkg" install && \
    find /tmp/gcc-4.9.4.pkg -name '*.la' -delete && \
    cd /tmp/gcc-4.9.4.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"gcc-bundle@4.9.4.txz" && \
    cd /

RUN curl -R -L -o /src/binutils-2.28.1.tar.xz https://ftp.gnu.org/gnu/binutils/binutils-2.28.1.tar.xz && \
    echo "16328a906e55a3c633854beec8e9e255a639b366436470b4f6245eb0d2fde942  /src/binutils-2.28.1.tar.xz" | sha256sum -c && \
    tar xf /src/binutils-2.28.1.tar.xz -C /src && \
    mkdir /src/binutils-cross && \
    cd /src/binutils-cross && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    /src/binutils-2.28.1/configure \
      --with-system-zlib \
      --target=x86_64-pc-linux-musl \
      --host=x86_64-pc-linux-musl \
      --enable-deterministic-archives \
      --prefix=/usr \
      --disable-nls \
      --disable-multilib && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/binutils-2.28.1.pkg" install && \
    find /tmp/binutils-2.28.1.pkg -name '*.la' -delete && \
    cd /tmp/binutils-2.28.1.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"binutils@2.28.1.txz" && \
    cd / && \
    rm -rf /src/binutils-2.28.1 /src/binutils-cross

RUN curl -R -L -o /src/xz-5.2.3.tar.gz https://tukaani.org/xz/xz-5.2.3.tar.gz && \
    echo "71928b357d0a09a12a4b4c5fafca8c31c19b0e7d3b8ebb19622e96f26dbf28cb  /src/xz-5.2.3.tar.gz" | sha256sum -c && \
    tar xf /src/xz-5.2.3.tar.gz -C /src && \
    mkdir /src/xz-cross && \
    cd /src/xz-cross && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    /src/xz-5.2.3/configure \
      --disable-nls \
      --disable-rpath \
      --disable-scripts \
      --prefix=/x86_64-pc-linux-musl \
      --target=x86_64-pc-linux-musl \
      --host=x86_64-pc-linux-musl && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR=/opt/gcc-cross install && \
    make clean && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    /src/xz-5.2.3/configure \
      --disable-nls \
      --disable-rpath \
      --disable-scripts \
      --prefix=/usr \
      --target=x86_64-pc-linux-musl \
      --host=x86_64-pc-linux-musl && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR=/tmp/xz-5.2.3.pkg install && \
    cd /tmp/xz-5.2.3.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"xz@5.2.3.txz" && \
    cd / && \
    rm -rf /src/xz-cross /src/xz-5.2.3 /tmp/xz-5.2.3.pkg

RUN curl -R -L -o /src/bzip2-1.0.6.tar.gz http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz && \
    echo "a2848f34fcd5d6cf47def00461fcb528a0484d8edef8208d6d2e2909dc61d9cd  /src/bzip2-1.0.6.tar.gz" | sha256sum -c && \
    tar xf /src/bzip2-1.0.6.tar.gz -C /src && \
    mv /src/bzip2-1.0.6 /src/bzip2-cross && \
    cd /src/bzip2-cross && \
    mv Makefile Makefile.orig && \
    sed -e "/^all:/s/ test//" Makefile.orig > Makefile && \
    PATH="/opt/gcc-cross/bin:$PATH" make -f Makefile-libbz2_so \
      PREFIX=/opt/gcc-cross/x86_64-pc-linux-musl \
      CFLAGS="-fPIC -g0 -Os" \
      CXXFLAGS="-fPIC -g0 -Os" \
      LDFLAGS="-s" \
      CC="x86_64-pc-linux-musl-gcc" \
      LD="x86_64-pc-linux-musl-gcc" \
      AR="x86_64-pc-linux-musl-ar" \
      RANLIB="x86_64-pc-linux-musl-ranlib" && \
    PATH="/opt/gcc-cross/bin:$PATH" make \
      PREFIX=/opt/gcc-cross/x86_64-pc-linux-musl \
      CFLAGS="-fPIC -g0 -Os" \
      CC="x86_64-pc-linux-musl-gcc" \
      AR="x86_64-pc-linux-musl-ar" \
      RANLIB="x86_64-pc-linux-musl-ranlib" \
      install && \
    PATH="/opt/gcc-cross/bin:$PATH" make \
      PREFIX=/tmp/bzip2-1.0.6.pkg/usr \
      CFLAGS="-fPIC -g0 -Os" \
      CC="x86_64-pc-linux-musl-gcc" \
      AR="x86_64-pc-linux-musl-ar" \
      RANLIB="x86_64-pc-linux-musl-ranlib" \
      install && \
    cp libbz2.so.1.0.6 /opt/gcc-cross/x86_64-pc-linux-musl/lib && \
    cp libbz2.so.1.0.6 /tmp/bzip2-1.0.6.pkg/usr/lib && \
    ln -s libbz2.so.1.0.6 /opt/gcc-cross/x86_64-pc-linux-musl/lib/libz2.so && \
    ln -s libbz2.so.1.0.6 /opt/gcc-cross/x86_64-pc-linux-musl/lib/libz2.so.1 && \
    ln -s libbz2.so.1.0.6 /opt/gcc-cross/x86_64-pc-linux-musl/lib/libz2.so.1.0 && \
    ln -s libbz2.so.1.0.6 /tmp/bzip2-1.0.6.pkg/usr/lib/libz2.so && \
    ln -s libbz2.so.1.0.6 /tmp/bzip2-1.0.6.pkg/usr/lib/libz2.so.1 && \
    ln -s libbz2.so.1.0.6 /tmp/bzip2-1.0.6.pkg/usr/lib/libz2.so.1.0 && \
    rm /tmp/bzip2-1.0.6.pkg/usr/bin/bzcmp && \
    rm /tmp/bzip2-1.0.6.pkg/usr/bin/bzegrep && \
    rm /tmp/bzip2-1.0.6.pkg/usr/bin/bzfgrep && \
    rm /tmp/bzip2-1.0.6.pkg/usr/bin/bzless && \
    ln -s bzdiff /tmp/bzip2-1.0.6.pkg/usr/bin/bzcmp && \
    ln -s bzgrep /tmp/bzip2-1.0.6.pkg/usr/bin/bzegrep && \
    ln -s bzgrep /tmp/bzip2-1.0.6.pkg/usr/bin/bzfgrep && \
    ln -s bzmore /tmp/bzip2-1.0.6.pkg/usr/bin/bzless && \
    mkdir -p /tmp/bzip2-1.0.6.pkg/usr/share && \
    mv /tmp/bzip2-1.0.6.pkg/usr/man /tmp/bzip2-1.0.6.pkg/usr/share/man && \
    cd /tmp/bzip2-1.0.6.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"bzip2@1.0.6.txz" && \
    cd / && \
    rm -rf /src/bzip2-cross /tmp/bzip2-1.0.6.pkg

RUN curl -R -L -o /src/config.sub "http://git.savannah.gnu.org/gitweb/?p=autoconf.git;a=blob_plain;f=build-aux/config.sub;h=95dc3d07248b62f67a4f917722d2d1cc849b8122;hb=HEAD" && \
    echo "140f9efa8b3fbfcdb8e0d9b6c20907bd4a2d3d1b662758da4c5dd435856ced4e  /src/config.sub" | sha256sum -c

RUN curl -R -L -o /src/attr-2.4.47.src.tar.gz https://download.savannah.nongnu.org/releases/attr/attr-2.4.47.src.tar.gz && \
    echo "25772f653ac5b2e3ceeb89df50e4688891e21f723c460636548971652af0a859  /src/attr-2.4.47.src.tar.gz" | sha256sum -c && \
    curl -R -L -o /src/attr-fix-headers.patch "https://git.alpinelinux.org/cgit/aports/plain/main/attr/fix-headers.patch?h=3.4-stable" && \
    echo "53b669f9fb365961aa393a8528c1d671c76a2687c6d7f3b171335bd902feca3e  /src/attr-fix-headers.patch" | sha256sum -c && \
    tar xf /src/attr-2.4.47.src.tar.gz -C /src && \
    mv /src/attr-2.4.47 /src/attr-cross && \
    cd /src/attr-cross && \
    patch -p1 -i /src/attr-fix-headers.patch && \
    cp /src/config.sub ./config.sub && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    INSTALL_USER=root INSTALL_GROUP=root \
    ./configure \
      --prefix=/x86_64-pc-linux-musl \
      --target=x86_64-pc-linux-musl \
      --host=x86_64-pc-linux-musl && \
    INSTALL_USER=root INSTALL_GROUP=root PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    INSTALL_USER=root INSTALL_GROUP=root PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/opt/gcc-cross" install && \
    INSTALL_USER=root INSTALL_GROUP=root PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/opt/gcc-cross" install-dev && \
    INSTALL_USER=root INSTALL_GROUP=root PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/opt/gcc-cross" install-lib && \
    make clean && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    INSTALL_USER=root INSTALL_GROUP=root \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --prefix=/usr \
      --target=x86_64-pc-linux-musl \
      --host=x86_64-pc-linux-musl && \
    INSTALL_USER=root INSTALL_GROUP=root PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    INSTALL_USER=root INSTALL_GROUP=root PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/attr-2.4.47.pkg" install && \
    INSTALL_USER=root INSTALL_GROUP=root PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/attr-2.4.47.pkg" install-dev && \
    INSTALL_USER=root INSTALL_GROUP=root PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/attr-2.4.47.pkg" install-lib && \
    find /opt/gcc-cross -name '*.la' -delete && \
    find /tmp/attr-2.4.47.pkg -name '*.la' -delete && \
    cd /tmp/attr-2.4.47.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"attr@2.4.47.txz" && \
    cd / && \
    rm -rf /src/attr-cross

RUN curl -R -L -o /src/acl-2.2.52.src.tar.gz https://download.savannah.nongnu.org/releases/acl/acl-2.2.52.src.tar.gz && \
    echo "179074bb0580c06c4b4137be4c5a92a701583277967acdb5546043c7874e0d23  /src/acl-2.2.52.src.tar.gz" | sha256sum -c && \
    tar xf /src/acl-2.2.52.src.tar.gz -C /src && \
    mv /src/acl-2.2.52 /src/acl-cross && \
    cd /src/acl-cross && \
    cp /src/config.sub ./config.sub && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    ./configure \
      --prefix=/x86_64-pc-linux-musl \
      --target=x86_64-pc-linux-musl \
      --host=x86_64-pc-linux-musl && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/opt/gcc-cross" install && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/opt/gcc-cross" install-dev && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/opt/gcc-cross" install-lib && \
    make clean && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --prefix=/usr \
      --target=x86_64-pc-linux-musl \
      --host=x86_64-pc-linux-musl && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/acl-2.2.52.pkg" install && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/acl-2.2.52.pkg" install-dev && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/acl-2.2.52.pkg" install-lib && \
    mv /opt/gcc-cross/x86_64-pc-linux-musl/libexec/libacl.a /opt/gcc-cross/x86_64-pc-linux-musl/lib/libacl.a && \
    rm /opt/gcc-cross/x86_64-pc-linux-musl/libexec/libacl.so && \
    find /opt/gcc-cross -name '*.la' -delete && \
    find /tmp/acl-2.2.52.pkg -name '*.la' -delete && \
    cd /tmp/acl-2.2.52.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"acl@2.2.52.txz" && \
    cd / && \
    rm -rf /src/acl-cross


RUN curl -R -L -o /src/libarchive-3.3.2.tar.gz "https://www.libarchive.org/downloads/libarchive-3.3.2.tar.gz" && \
    echo "ed2dbd6954792b2c054ccf8ec4b330a54b85904a80cef477a1c74643ddafa0ce  /src/libarchive-3.3.2.tar.gz" | sha256sum -c && \
    tar xf /src/libarchive-3.3.2.tar.gz -C /src && \
    mkdir /src/libarchive-cross && \
    mkdir /src/libarchive-pkg && \
    cd /src/libarchive-cross && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    /src/libarchive-3.3.2/configure \
      --prefix=/x86_64-pc-linux-musl \
      --target=x86_64-pc-linux-musl \
      --host=x86_64-pc-linux-musl && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/opt/gcc-cross" install && \
    cd /src/libarchive-pkg && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    /src/libarchive-3.3.2/configure \
      --prefix=/usr \
      --target=x86_64-pc-linux-musl \
      --host=x86_64-pc-linux-musl && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/libarchive-3.3.2.pkg" install && \
    cd /tmp/libarchive-3.3.2.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"libarchive@3.3.2.txz" && \
    cd / && \
    rm -rf /src/libarchive-3.3.2 /src/libarchive-cross

RUN curl -R -L -o /src/dash-0.5.9.1.tar.gz https://git.kernel.org/pub/scm/utils/dash/dash.git/snapshot/dash-0.5.9.1.tar.gz && \
    echo "3f747013a20a3a9d2932be1a6dd1b002ca5649849b649be0af8a8da80bd8a918  /src/dash-0.5.9.1.tar.gz" | sha256sum -c && \
    tar xf /src/dash-0.5.9.1.tar.gz -C /src && \
    cd /src/dash-0.5.9.1 && \
    ./autogen.sh && \
    autoreconf -i -v -f && \
    mkdir /src/dash-cross && \
    cd /src/dash-cross && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    /src/dash-0.5.9.1/configure \
      --host=x86_64-pc-linux-musl \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/dash-0.5.9.1.pkg" install && \
    cd /tmp/dash-0.5.9.1.pkg && \
    ln -s dash usr/bin/sh && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"dash@0.5.9.1.txz" && \
    cd / && \
    rm -rf /src/dash-cross /src/dash-0.5.9.1


RUN curl -R -L -o /src/coreutils-8.29.tar.xz https://ftp.gnu.org/gnu/coreutils/coreutils-8.29.tar.xz && \
    echo "92d0fa1c311cacefa89853bdb53c62f4110cdfda3820346b59cbd098f40f955e  /src/coreutils-8.29.tar.xz" | sha256sum -c && \
    tar xf /src/coreutils-8.29.tar.xz -C /src && \
    cd /src/coreutils-8.29 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --host=x86_64-pc-linux-musl \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/coreutils-8.29.pkg" install && \
    cd /tmp/coreutils-8.29.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"coreutils@8.29.txz" && \
    cd / && \
    rm -rf /src/coreutils-8.29

RUN curl -R -L -o /src/sed-4.4.tar.xz https://ftp.gnu.org/gnu/sed/sed-4.4.tar.xz && \
    echo "cbd6ebc5aaf080ed60d0162d7f6aeae58211a1ee9ba9bb25623daa6cd942683b  /src/sed-4.4.tar.xz" | sha256sum -c && \
    tar xf /src/sed-4.4.tar.xz -C /src && \
    cd /src/sed-4.4 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --host=x86_64-pc-linux-musl \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/sed-4.4.pkg" install && \
    cd /tmp/sed-4.4.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"sed@4.4.txz" && \
    cd / && \
    rm -rf /src/sed-4.4

RUN curl -R -L -o /src/diffutils-3.6.tar.xz https://ftp.gnu.org/gnu/diffutils/diffutils-3.6.tar.xz && \
    echo "d621e8bdd4b573918c8145f7ae61817d1be9deb4c8d2328a65cea8e11d783bd6  /src/diffutils-3.6.tar.xz" | sha256sum -c && \
    tar xf /src/diffutils-3.6.tar.xz -C /src && \
    cd /src/diffutils-3.6 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --host=x86_64-pc-linux-musl \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/diffutils-3.6.pkg" install && \
    cd /tmp/diffutils-3.6.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"diffutils@3.6.txz" && \
    cd / && \
    rm -rf /src/diffutils-3.6

RUN curl -R -L -o /src/perl-5.26.1.tar.gz http://www.cpan.org/src/5.0/perl-5.26.1.tar.gz && \
    echo "e763aa485e8dc1a70483dbe6d615986bbf32b977f38016480d68c99237e701dd  /src/perl-5.26.1.tar.gz" | sha256sum -c && \
    curl -R -L -o /src/perl-cross-1.1.8.tar.gz https://github.com/arsv/perl-cross/releases/download/1.1.8/perl-cross-1.1.8.tar.gz && \
    echo "08e626ed9c419b8a695a8762ff8b41a553023175e4ad67b5e858fc9b4322521c  /src/perl-cross-1.1.8.tar.gz" | sha256sum -c && \
    tar xf /src/perl-5.26.1.tar.gz -C /src && \
    tar xf /src/perl-cross-1.1.8.tar.gz -C /src && \
    rsync -av /src/perl-cross-1.1.8/ /src/perl-5.26.1/ && \
    cp -r /src/perl-5.26.1 /src/perl-build && \
    cd /src/perl-build && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --target=x86_64-pc-linux-musl \
      --host=x86_64-pc-linux-musl \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/perl-5.26.1.pkg" install && \
    find /tmp/perl-5.26.1.pkg -name '*.la' -delete && \
    cd /tmp/perl-5.26.1.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"perl@5.26.1.txz" && \
    cd / && \
    rm -rf /src/perl-build

RUN curl -R -L -o /src/libressl-2.6.4.tar.gz https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.6.4.tar.gz && \
    echo "638a20c2f9e99ee283a841cd787ab4d846d1880e180c4e96904fc327d419d11f  /src/libressl-2.6.4.tar.gz" | sha256sum -c && \
    tar xf /src/libressl-2.6.4.tar.gz -C /src && \
    cd /src/libressl-2.6.4 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --prefix=/x86_64-pc-linux-musl \
      --target=x86_64-pc-linux-musl \
      --host=x86_64-pc-linux-musl && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR=/opt/gcc-cross install && \
    make clean && \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    PATH="/opt/gcc-cross/bin:$PATH" \
    ./configure \
      --target=x86_64-pc-linux-musl \
      --host=x86_64-pc-linux-musl \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/libressl-2.6.4.pkg" install && \
    find /opt/gcc-cross -name '*.la' -delete && \
    find /tmp/libressl-2.6.4.pkg -name '*.la' -delete && \
    cd /tmp/libressl-2.6.4.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"libressl@2.6.4.txz" && \
    cd / && \
    rm -rf /src/libressl-build

RUN curl -R -L -o /src/curl-7.57.0.tar.xz https://curl.haxx.se/download/curl-7.57.0.tar.xz && \
    echo "f5f6fd3c72b7b8389969f4fb671ed8532fa9b5bb7a5cae7ca89bc1cea45c7878  /src/curl-7.57.0.tar.xz" | sha256sum -c && \
    tar xf /src/curl-7.57.0.tar.xz -C /src && \
    cd /src/curl-7.57.0 && \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    PATH="/opt/gcc-cross/bin:$PATH" \
    ./configure \
      --target=x86_64-pc-linux-musl \
      --host=x86_64-pc-linux-musl \
      --with-ca-bundle=/etc/ca-certificates/cacert.pem \
      --prefix=/x86_64-pc-linux-musl && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/opt/gcc-cross" install && \
    make clean && \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    PATH="/opt/gcc-cross/bin:$PATH" \
    ./configure \
      --target=x86_64-pc-linux-musl \
      --host=x86_64-pc-linux-musl \
      --with-ca-bundle=/etc/ca-certificates/cacert.pem \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/curl-7.57.0.pkg" install && \
    find /tmp/curl-7.57.0.pkg -name '*.la' -delete && \
    cd /tmp/curl-7.57.0.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"curl@7.57.0.txz" && \
    cd / && \
    rm -rf /src/curl-7.57.0

RUN curl -R -L -o /src/cacert.pem https://curl.haxx.se/ca/cacert-2017-09-20.pem && \
    echo "435ac8e816f5c10eaaf228d618445811c16a5e842e461cb087642b6265a36856  /src/cacert.pem" | sha256sum -c && \
    mkdir -p /tmp/ca-certificates.pkg/etc/ca-certificates && \
    cp /src/cacert.pem /tmp/ca-certificates.pkg/etc/ca-certificates/cacert.pem && \
    cd /tmp/ca-certificates.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"ca-certificates@20170920.txz" && \
    cd /

RUN curl -R -L -o /src/grep-3.1.tar.xz https://ftp.gnu.org/gnu/grep/grep-3.1.tar.xz && \
    echo "db625c7ab3bb3ee757b3926a5cfa8d9e1c3991ad24707a83dde8a5ef2bf7a07e  /src/grep-3.1.tar.xz" | sha256sum -c && \
    tar xf /src/grep-3.1.tar.xz -C /src && \
    cd /src/grep-3.1 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --host=x86_64-pc-linux-musl \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/grep-3.1.pkg" install && \
    cd /tmp/grep-3.1.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"grep@3.1.txz" && \
    cd / && \
    rm -rf /src/grep-3.1

RUN curl -R -L -o /src/make-4.2.1.tar.bz2 https://ftp.gnu.org/gnu/make/make-4.2.1.tar.bz2 && \
    echo "d6e262bf3601b42d2b1e4ef8310029e1dcf20083c5446b4b7aa67081fdffc589  /src/make-4.2.1.tar.bz2" | sha256sum -c && \
    tar xf /src/make-4.2.1.tar.bz2 -C /src && \
    cd /src/make-4.2.1 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --host=x86_64-pc-linux-musl \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/make-4.2.1.pkg" install && \
    cd /tmp/make-4.2.1.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"make@4.2.1.txz" && \
    cd / && \
    rm -rf /src/make-4.2.1

RUN curl -R -L -o /src/findutils-4.6.0.tar.gz https://ftp.gnu.org/gnu/findutils/findutils-4.6.0.tar.gz && \
    echo "ded4c9f73731cd48fec3b6bdaccce896473b6d8e337e9612e16cf1431bb1169d  /src/findutils-4.6.0.tar.gz" | sha256sum -c && \
    tar xf /src/findutils-4.6.0.tar.gz -C /src && \
    cd /src/findutils-4.6.0 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --host=x86_64-pc-linux-musl \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/findutils-4.6.0.pkg" install && \
    cd /tmp/findutils-4.6.0.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"findutils@4.6.0.txz" && \
    cd / && \
    rm -rf /src/findutils-4.6.0

RUN curl -R -L -o /src/tar-1.30.tar.xz https://ftp.gnu.org/gnu/tar/tar-1.30.tar.xz && \
    echo "f1bf92dbb1e1ab27911a861ea8dde8208ee774866c46c0bb6ead41f4d1f4d2d3  /src/tar-1.30.tar.xz" | sha256sum -c && \
    tar xf /src/tar-1.30.tar.xz -C /src && \
    cd /src/tar-1.30 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --host=x86_64-pc-linux-musl \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/tar-1.30.pkg" install && \
    cd /tmp/tar-1.30.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"tar@1.30.txz" && \
    cd / && \
    rm -rf /src/tar-1.30

RUN curl -R -L -o /src/libutf-20170901.tgz https://9fans.github.io/plan9port/unix/libutf.tgz && \
    echo "262a902f622dcd28e05b8a4be10da0aa3899050d0be8f4a71780eed6b2ea65ca  /src/libutf-20170901.tgz" | sha256sum -c && \
    tar xf /src/libutf-20170901.tgz -C /src && \
    cd /src/libutf && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    make CC=x86_64-pc-linux-musl-gcc AR=x86_64-pc-linux-musl-ar && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    make PREFIX=/opt/gcc-cross/x86_64-pc-linux-musl CC=x86_64-pc-linux-musl-gcc AR=x86_64-pc-linux-musl-ar install && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    make PREFIX=/tmp/libutf-20170901.pkg/usr CC=x86_64-pc-linux-musl-gcc AR=x86_64-pc-linux-musl-ar install && \
    cd /tmp/libutf-20170901.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"libutf@20170901.txz" && \
    cd / && \
    rm -rf /src/libutf

RUN curl -R -L -o /src/libfmt-20170901.tgz https://9fans.github.io/plan9port/unix/libfmt.tgz && \
    echo "4e26c943c7efbce8deebfd750a40ca5cef05a37649d4ed394548dcdc4ee1ce32  /src/libfmt-20170901.tgz" | sha256sum -c && \
    tar xf /src/libfmt-20170901.tgz -C /src && \
    cd /src/libfmt && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    make CC=x86_64-pc-linux-musl-gcc AR=x86_64-pc-linux-musl-ar && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    make PREFIX=/opt/gcc-cross/x86_64-pc-linux-musl CC=x86_64-pc-linux-musl-gcc AR=x86_64-pc-linux-musl-ar install && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    make PREFIX=/tmp/libfmt-20170901.pkg/usr CC=x86_64-pc-linux-musl-gcc AR=x86_64-pc-linux-musl-ar install && \
    cd /tmp/libfmt-20170901.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"libfmt@20170901.txz" && \
    cd / && \
    rm -rf /src/libfmt

RUN curl -R -L -o /src/libbio-20170901.tgz https://9fans.github.io/plan9port/unix/libbio.tgz && \
    echo "22c79ceb92cd3367ef91f5a74491f5bd8412c32cdf8a1a897ca97a199376df06  /src/libbio-20170901.tgz" | sha256sum -c && \
    tar xf /src/libbio-20170901.tgz -C /src && \
    cd /src/libbio && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    make CC=x86_64-pc-linux-musl-gcc AR=x86_64-pc-linux-musl-ar && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    make PREFIX=/opt/gcc-cross/x86_64-pc-linux-musl CC=x86_64-pc-linux-musl-gcc AR=x86_64-pc-linux-musl-ar install && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    make PREFIX=/tmp/libbio-20170901.pkg/usr CC=x86_64-pc-linux-musl-gcc AR=x86_64-pc-linux-musl-ar install && \
    cd /tmp/libbio-20170901.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"libbio@20170901.txz" && \
    cd / && \
    rm -rf /src/libbio

RUN curl -R -L -o /src/libregexp9-20170901.tgz https://9fans.github.io/plan9port/unix/libregexp9.tgz && \
    echo "73cf14c81e0705c65135e57dd29c16b23cfb115f842da4ffe446f22fa4fddde1  /src/libregexp9-20170901.tgz" | sha256sum -c && \
    tar xf /src/libregexp9-20170901.tgz -C /src && \
    cd /src/libregexp && \
    mv regcomp.c regcomp.c.orig && \
    echo "#include <stddef.h>" > regcomp.c && \
    cat regcomp.c.orig >> regcomp.c && \
    rm regcomp.c.orig && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    make CC=x86_64-pc-linux-musl-gcc AR=x86_64-pc-linux-musl-ar && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    make PREFIX=/opt/gcc-cross/x86_64-pc-linux-musl CC=x86_64-pc-linux-musl-gcc AR=x86_64-pc-linux-musl-ar install && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    make PREFIX=/tmp/libregexp9-20170901.pkg/usr CC=x86_64-pc-linux-musl-gcc AR=x86_64-pc-linux-musl-ar install && \
    cd /tmp/libregexp9-20170901.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"libregexp9@20170901.txz" && \
    cd / && \
    rm -rf /src/libregexp

RUN curl -R -L -o /src/mk-20170901.tgz https://9fans.github.io/plan9port/unix/mk.tgz && \
    echo "88b29c3132f5beea15d77b7330d8caa1e2c892c719557570cfe5d2473f460f52  /src/mk-20170901.tgz" | sha256sum -c && \
    tar xf /src/mk-20170901.tgz -C /src && \
    cd /src/mk && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    make CC=x86_64-pc-linux-musl-gcc AR=x86_64-pc-linux-musl-ar && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    make PREFIX=/opt/gcc-cross/x86_64-pc-linux-musl CC=x86_64-pc-linux-musl-gcc AR=x86_64-pc-linux-musl-ar install && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    make PREFIX=/tmp/mk-20170901.pkg/usr CC=x86_64-pc-linux-musl-gcc AR=x86_64-pc-linux-musl-ar install && \
    cd /tmp/mk-20170901.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"mk@20170901.txz" && \
    cd / && \
    rm -rf /src/mk

RUN curl -R -L -o /src/pigz-2.4.tar.gz https://zlib.net/pigz/pigz-2.4.tar.gz && \
    echo "a4f816222a7b4269bd232680590b579ccc72591f1bb5adafcd7208ca77e14f73  /src/pigz-2.4.tar.gz" | sha256sum -c && \
    tar xf /src/pigz-2.4.tar.gz -C /src && \
    cd /src/pigz-2.4 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    make -j$(nproc) \
    CC="x86_64-pc-linux-musl-gcc" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" && \
    mkdir -p /tmp/pigz-2.4.pkg/usr/bin && \
    cp pigz /tmp/pigz-2.4.pkg/usr/bin/pigz && \
    cd /tmp/pigz-2.4.pkg && \
    ln -s pigz usr/bin/unpigz && \
    ln -s pigz usr/bin/gzip && \
    ln -s pigz usr/bin/gunzip && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"pigz@2.4.txz" && \
    cd / && \
    rm -rf /src/pigz-2.4.pkg

RUN curl -R -L -o /src/patch-2.7.5.tar.xz https://ftp.gnu.org/gnu/patch/patch-2.7.5.tar.xz && \
    echo "fd95153655d6b95567e623843a0e77b81612d502ecf78a489a4aed7867caa299  /src/patch-2.7.5.tar.xz" | sha256sum -c && \
    tar xf /src/patch-2.7.5.tar.xz -C /src && \
    cd /src/patch-2.7.5 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --host=x86_64-pc-linux-musl \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/patch-2.7.5.pkg" install && \
    cd /tmp/patch-2.7.5.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"patch@2.7.5.txz" && \
    cd / && \
    rm -rf /src/patch-2.7.5

RUN curl -R -L -o /src/m4-1.4.18.tar.xz https://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.xz && \
    echo "f2c1e86ca0a404ff281631bdc8377638992744b175afb806e25871a24a934e07  /src/m4-1.4.18.tar.xz" | sha256sum -c && \
    tar xf /src/m4-1.4.18.tar.xz -C /src && \
    cd /src/m4-1.4.18 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --host=x86_64-pc-linux-musl \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/m4-1.4.18.pkg" install && \
    cd /tmp/m4-1.4.18.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"m4@1.4.18.txz" && \
    cd / && \
    rm -rf /src/m4-1.4.18

RUN curl -R -L -o /src/bison-3.0.4.tar.xz https://ftp.gnu.org/gnu/bison/bison-3.0.4.tar.xz && \
    echo "a72428c7917bdf9fa93cb8181c971b6e22834125848cf1d03ce10b1bb0716fe1  /src/bison-3.0.4.tar.xz" | sha256sum -c && \
    tar xf /src/bison-3.0.4.tar.xz -C /src && \
    cd /src/bison-3.0.4 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --host=x86_64-pc-linux-musl \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/bison-3.0.4.pkg" install && \
    cd /tmp/bison-3.0.4.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"bison@3.0.4.txz" && \
    cd / && \
    rm -rf /src/bison-3.0.4

RUN curl -R -L -o /src/flex-2.6.4.tar.gz https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz && \
    echo "e87aae032bf07c26f85ac0ed3250998c37621d95f8bd748b31f15b33c45ee995  /src/flex-2.6.4.tar.gz" | sha256sum -c && \
    tar xf /src/flex-2.6.4.tar.gz -C /src && \
    cd /src/flex-2.6.4 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --host=x86_64-pc-linux-musl \
      --prefix=/usr \
      ac_cv_func_malloc_0_nonnull=yes \
      ac_cv_func_realloc_0_nonnull=yes && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/flex-2.6.4.pkg" install && \
    cd /tmp/flex-2.6.4.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"flex@2.6.4.txz" && \
    cd / && \
    rm -rf /src/flex-2.6.4

RUN curl -R -L -o /src/gawk-4.2.0.tar.xz https://ftp.gnu.org/gnu/gawk/gawk-4.2.0.tar.xz && \
    echo "d4f3cd31c001fd0ed52832d4fbfbdfeaa38ad541c182f80ff8fdf87324a6a9f2  /src/gawk-4.2.0.tar.xz" | sha256sum -c && \
    tar xf /src/gawk-4.2.0.tar.xz -C /src && \
    cd /src/gawk-4.2.0 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --host=x86_64-pc-linux-musl \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/gawk-4.2.0.pkg" install && \
    cd /tmp/gawk-4.2.0.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"gawk@4.2.0.txz" && \
    cd / && \
    rm -rf /src/gawk-4.2.0

RUN curl -R -L -o /src/which-2.21.tar.gz https://ftp.gnu.org/gnu/which/which-2.21.tar.gz && \
    echo "f4a245b94124b377d8b49646bf421f9155d36aa7614b6ebf83705d3ffc76eaad  /src/which-2.21.tar.gz" | sha256sum -c && \
    tar xf /src/which-2.21.tar.gz -C /src && \
    cd /src/which-2.21 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --host=x86_64-pc-linux-musl \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/which-2.21.pkg" install && \
    cd /tmp/which-2.21.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"which@2.21.txz" && \
    cd / && \
    rm -rf /src/which-2.21

RUN curl -R -L -o /src/ncurses-6.0.tar.gz https://ftp.gnu.org/gnu/ncurses/ncurses-6.0.tar.gz && \
    echo "f551c24b30ce8bfb6e96d9f59b42fbea30fa3a6123384172f9e7284bcf647260  /src/ncurses-6.0.tar.gz" && \
    tar xf /src/ncurses-6.0.tar.gz -C /src && \
    cd /src/ncurses-6.0 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CPPFLAGS="-P" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --without-ada \
      --disable-rpath-hack \
      --with-pkg-config-libdir=/usr/lib/pkgconfig \
      --with-termlib=tinfo --with-ticlib=tic \
      --without-cxx-binding \
      --with-terminfo-dirs="/etc/terminfo:/usr/share/terminfo" \
      --enable-pc-files \
      --with-shared \
      --enable-widec \
      --host=x86_64-pc-linux-musl \
      --prefix=/x86_64-pc-linux-musl && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/opt/gcc-cross" install && \
    ln -s libncursesw.so /opt/gcc-cross/x86_64-pc-linux-musl/lib/libncurses.so && \
    ln -s libncursesw.a /opt/gcc-cross/x86_64-pc-linux-musl/lib/libncurses.a && \
    make clean && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CPPFLAGS="-P" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --without-ada \
      --disable-rpath-hack \
      --with-pkg-config-libdir=/usr/lib/pkgconfig \
      --without-cxx-binding \
      --with-terminfo-dirs="/etc/terminfo:/usr/share/terminfo" \
      --enable-pc-files \
      --with-shared \
      --with-termlib=tinfo --with-ticlib=tic \
      --enable-widec \
      --host=x86_64-pc-linux-musl \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/ncurses-6.0.pkg" install && \
    ln -s libncursesw.so /tmp/ncurses-6.0.pkg/usr/lib/libncurses.so && \
    ln -s libncursesw.a  /tmp/ncurses-6.0.pkg/usr/lib/libncurses.a && \
    cd /tmp/ncurses-6.0.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"ncurses@6.0.txz" && \
    cd / && \
    rm -rf /src/ncurses-6.0

RUN curl -R -L -o /src/procps-ng-3.3.12.tar.xz https://downloads.sourceforge.net/project/procps-ng/Production/procps-ng-3.3.12.tar.xz && \
    echo "6ed65ab86318f37904e8f9014415a098bec5bc53653e5d9ab404f95ca5e1a7d4  /src/procps-ng-3.3.12.tar.xz" | sha256sum -c && \
    tar xf /src/procps-ng-3.3.12.tar.xz -C /src && \
    cd /src/procps-ng-3.3.12 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os -I/opt/gcc-cross/x86_64-pc-linux-musl/include/ncursesw" \
    CXXFLAGS="-g0 -Os -I/opt/gcc-cross/x86_64-pc-linux-musl/include/ncursesw" \
    LDFLAGS="-s" \
    ./configure \
      --host=x86_64-pc-linux-musl \
      --prefix=/usr \
      ac_cv_func_malloc_0_nonnull=yes \
      ac_cv_func_realloc_0_nonnull=yes && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/procps-ng-3.3.12.pkg" install && \
    cd /tmp/procps-ng-3.3.12.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"procps-ng@3.3.12.txz" && \
    cd / && \
    rm -rf /src/procps-ng-3.3.12

RUN curl -R -L -o /src/bash-4.4.12.tar.gz https://ftp.gnu.org/gnu/bash/bash-4.4.12.tar.gz && \
    echo "57d8432be54541531a496fd4904fdc08c12542f43605a9202594fa5d5f9f2331  /src/bash-4.4.12.tar.gz" | sha256sum -c && \
    tar xf /src/bash-4.4.12.tar.gz -C /src && \
    cd /src/bash-4.4.12 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --host=x86_64-pc-linux-musl \
      --without-bash-malloc \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/bash-4.4.12.pkg" install && \
    cd /tmp/bash-4.4.12.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"bash@4.4.12.txz" && \
    cd / && \
    rm -rf /src/bash-4.4.12

RUN curl -R -L -o /src/libtool-2.4.6.tar.xz https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz && \
    echo "7c87a8c2c8c0fc9cd5019e402bed4292462d00a718a7cd5f11218153bf28b26f  /src/libtool-2.4.6.tar.xz" | sha256sum -c && \
    tar xf /src/libtool-2.4.6.tar.xz -C /src && \
    cd /src/libtool-2.4.6 && \
    curl -R -L -o - https://git.alpinelinux.org/cgit/aports/plain/main/libtool/libtool-fix-cross-compile.patch | patch -p1 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --host=x86_64-pc-linux-musl \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/libtool-2.4.6.pkg" install && \
    cd /tmp/libtool-2.4.6.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"libtool@2.4.6.txz" && \
    cd / && \
    rm -rf /src/libtool-2.4.6

RUN curl -R -L -o /src/autoconf-2.69.tar.xz https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.xz && \
    echo "64ebcec9f8ac5b2487125a86a7760d2591ac9e1d3dbd59489633f9de62a57684  /src/autoconf-2.69.tar.xz" | sha256sum -c && \
    tar xf /src/autoconf-2.69.tar.xz -C /src && \
    cd /src/autoconf-2.69 && \
    cp -v /src/config.sub ./build-aux/config.sub && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --host=x86_64-pc-linux-musl \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/autoconf-2.69.pkg" install && \
    cd /tmp/autoconf-2.69.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"autoconf@2.69.txz" && \
    cd / && \
    rm -rf /src/autoconf-2.69

RUN curl -R -L -o /src/automake-1.15.1.tar.xz https://ftp.gnu.org/gnu/automake/automake-1.15.1.tar.xz && \
    echo "af6ba39142220687c500f79b4aa2f181d9b24e4f8d8ec497cea4ba26c64bedaf  /src/automake-1.15.1.tar.xz" | sha256sum -c && \
    tar xf /src/automake-1.15.1.tar.xz -C /src && \
    cd /src/automake-1.15.1 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --host=x86_64-pc-linux-musl \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/automake-1.15.1.pkg" install && \
    cd /tmp/automake-1.15.1.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"automake@1.15.1.txz" && \
    cd / && \
    rm -rf /src/automake-1.15.1

RUN curl -R -L -o /src/libfaketime-0.9.7.tar.gz https://github.com/wolfcw/libfaketime/archive/v0.9.7.tar.gz && \
    echo "4d65f368b2d53ee2f93a25d5e9541ce27357f2b95e5e5afff210e0805042811e  /src/libfaketime-0.9.7.tar.gz" | sha256sum -c && \
    curl -R -L -o /src/libfaketime-musl.diff https://github.com/jprjr/libfaketime/commit/42b14e0cdc7a9aa88bb1fc9a43bc94558ed33af0.diff && \
    echo "739ca7a6b0fc3510b316763f944d6b2528fcead3f40d424253d230e82b197a60  /src/libfaketime-musl.diff" | sha256sum -c && \
    tar xf /src/libfaketime-0.9.7.tar.gz -C /src && \
    cd /src/libfaketime-0.9.7 && \
    patch -p1 -i /src/libfaketime-musl.diff && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    make \
    PREFIX="/usr" \
    CC="x86_64-pc-linux-musl-gcc" && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    make \
    DESTDIR="/tmp/libfaketime-0.9.7.pkg" \
    PREFIX="/usr" \
    CC="x86_64-pc-linux-musl-gcc" install && \
    cd /tmp/libfaketime-0.9.7.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"libfaketime@0.9.7.txz" && \
    cd / && \
    rm -rf /src/libfaketime-0.9.7

RUN curl -R -L -o /src/pcre2-10.30.tar.bz2 https://ftp.pcre.org/pub/pcre/pcre2-10.30.tar.bz2 && \
    echo "90bd41c605d30e3745771eb81928d779f158081a51b2f314bbcc1f73de5773db  /src/pcre2-10.30.tar.bz2" | sha256sum -c && \
    tar xf /src/pcre2-10.30.tar.bz2 -C /src && \
    cd /src/pcre2-10.30 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --enable-jit \
      --host=x86_64-pc-linux-musl \
      --target=x86_64-pc-linux-musl \
      --prefix=/x86_64-pc-linux-musl && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/opt/gcc-cross" install && \
    make clean && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --enable-jit \
      --host=x86_64-pc-linux-musl \
      --target=x86_64-pc-linux-musl \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) && \
    PATH="/opt/gcc-cross/bin:$PATH" make DESTDIR="/tmp/pcre2-10.30.pkg" install && \
    cd /tmp/pcre2-10.30.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"pcre2@10.30.txz" && \
    cd / && \
    rm -rf /src/pcre2-10.30

RUN curl -R -L -o /src/libexpat-2.2.5.tar.gz https://github.com/libexpat/libexpat/archive/R_2_2_5.tar.gz && \
    echo "b3781742738611eaa737543ee94264dd511c52a3ba7e53111f7d705f6bff65a8  /src/libexpat-2.2.5.tar.gz" | sha256sum -c && \
    tar xf /src/libexpat-2.2.5.tar.gz -C /src && \
    cd /src/libexpat-R_2_2_5/expat && \
    ./buildconf.sh && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --without-docbook \
      --host=x86_64-pc-linux-musl \
      --target=x86_64-pc-linux-musl \
      --prefix=/x86_64-pc-linux-musl && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) DESTDIR=/opt/gcc-cross install-exec && \
    make clean && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    CFLAGS="-g0 -Os" \
    CXXFLAGS="-g0 -Os" \
    LDFLAGS="-s" \
    ./configure \
      --without-docbook \
      --host=x86_64-pc-linux-musl \
      --target=x86_64-pc-linux-musl \
      --prefix=/usr && \
    PATH="/opt/gcc-cross/bin:$PATH" make -j$(nproc) DESTDIR="/tmp/libexpat-2.2.5.pkg" install-exec && \
    cd /tmp/libexpat-2.2.5.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"libexpat@2.2.5.txz" && \
    cd / && \
    rm -rf /src/libexpat-2.2.5

RUN curl -R -L -o /src/git-2.15.1.tar.gz https://github.com/git/git/archive/v2.15.1.tar.gz && \
    echo "3cbc474c7fe9013b1cd4310636f0992d767d435ac9f642744551fd9a2b4b9d15  /src/git-2.15.1.tar.gz" | sha256sum -c && \
    tar xf /src/git-2.15.1.tar.gz -C /src && \
    cd /src/git-2.15.1 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    make -j$(nproc) \
    PREFIX="/usr" \
    prefix="/usr" \
    NO_REGEX=YesPlease \
    USE_LIBPCRE2=YesPlease \
    CC="x86_64-pc-linux-musl-gcc" \
    CFLAGS="-g0 -Os -DNO_SYS_POLL_H" \
    LDFLAGS="-s" \
    all && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    make \
    CFLAGS="-g0 -Os -DNO_SYS_POLL_H" \
    NO_REGEX=YesPlease \
    USE_LIBPCRE2=YesPlease \
    LDFLAGS="-s" \
    DESTDIR="/tmp/git-2.15.1.pkg" \
    PREFIX="/usr" \
    prefix="/usr" \
    CC="x86_64-pc-linux-musl-gcc" install && \
    cd /tmp/git-2.15.1.pkg && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"git@2.15.1.txz" && \
    cd / && \
    rm -rf /src/git-2.15.1

RUN mkdir -p /tmp/basefs-0.0.0.pkg/etc && \
    cd /tmp/basefs-0.0.0.pkg && \
    mkdir -p etc dev sys proc tmp usr libexec src var && \
    mkdir -p usr/bin && \
    mkdir -p usr/include && \
    mkdir -p usr/lib && \
    mkdir -p usr/libexec && \
    mkdir -p usr/share && \
    mkdir -p var/cache/repo && \
    ln -s bin usr/sbin && \
    ln -s usr/bin bin && \
    ln -s usr/bin sbin && \
    ln -s lib usr/lib64 && \
    ln -s usr/lib lib64 && \
    cp /src/ports/basefs/files/etc/* etc/ && \
    tar vc $(ls) | xz > /opt/root/var/cache/pm/"basefs@0.0.0.txz" && \
    cd /

RUN curl -R -L -o /src/pm-1.2.tar.bz2 "http://dl.z3bra.org/releases/pm-1.2.tar.bz2" && \
    echo "71d5cb7c91097c491627f3f512d7ed65e80498a5f9c3232ae7efc8e4a2495fd7  /src/pm-1.2.tar.bz2" | sha256sum -c && \
    tar xf /src/pm-1.2.tar.bz2 -C /src && \
    cd /src/pm-1.2 && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    make CC=x86_64-pc-linux-musl-gcc && \
    PATH="/opt/gcc-cross/bin:$PATH" x86_64-pc-linux-musl-strip pm && \
    PATH="/opt/gcc-cross/bin:$PATH" \
    make PREFIX=/usr DESTDIR=/src/pm-1.2/pkg MANDIR=/usr/share/man install && \
    cd pkg && \
    tar -c usr | xz > /opt/root/var/cache/pm/"pm@1.2.txz" && \
    cd /opt/root/var/cache/pm && \
    ls -lh && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'basefs@0.0.0.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'musl@1.1.18.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'pm@1.2.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'acl@2.2.52.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'attr@2.4.47.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'zlib@1.2.11.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'xz@5.2.3.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'bzip2@1.0.6.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'libarchive@3.3.2.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'dash@0.5.9.1.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'coreutils@8.29.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'sed@4.4.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'diffutils@3.6.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'binutils@2.28.1.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'gcc-bundle@4.9.4.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'perl@5.26.1.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'libressl@2.6.4.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'curl@7.57.0.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'ca-certificates@20170920.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'grep@3.1.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'make@4.2.1.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'findutils@4.6.0.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'tar@1.30.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'mk@20170901.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'pigz@2.4.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'patch@2.7.5.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'm4@1.4.18.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'bison@3.0.4.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'gawk@4.2.0.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'flex@2.6.4.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'which@2.21.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'ncurses@6.0.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'procps-ng@3.3.12.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'bash@4.4.12.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'libtool@2.4.6.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'autoconf@2.69.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'automake@1.15.1.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'libfaketime@0.9.7.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'pcre2@10.30.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'libexpat@2.2.5.txz' && \
    ROOT=/opt/root DATA=/opt/root/var/db/pm /src/pm-1.2/pm -v -f -a 'git@2.15.1.txz' && \
    cd / && \
    rm -rf /src/pm-1.2

FROM scratch
COPY --from=0 /opt/root /

