FROM jprjr/multigcc:base

RUN mkdir -p /src /opt/root && \
    git clone https://github.com/jprjr/multigcc-ports.git /src/ports && \
    cd /src/ports && \
    rm -rf gcc-5.5 gcc-6.4 gcc-7.2 && \
    rm -rf x86_64-w64-mingw32-gcc-5.5 x86_64-w64-mingw32-gcc-6.4 x86_64-w64-mingw32-gcc-7.2 && \
    rm -rf i686-w64-mingw32-gcc-5.5 i686-w64-mingw32-gcc-6.4 i686-w64-mingw32-gcc-7.2 && \
    rm -f  gcc x86_64-w64-mingw32-gcc i686-w64-mingw32-gcc && \
    mv gcc-4.9 gcc && \
    mv x86_64-w64-mingw32-gcc-4.9 x86_64-w64-mingw32-gcc && \
    mv i686-w64-mingw32-gcc-4.9 i686-w64-mingw32-gcc && \
    mk all

RUN ROOT=/opt/root DATA=/opt/root/var/db/pm pm -fva /var/cache/repo/basefs@*.tgz && \
    rm /var/cache/repo/basefs@*.tgz

RUN for file in /var/cache/repo/*.tgz; do \
        ROOT=/opt/root DATA=/opt/root/var/db/pm pm -fva "${file}" ; \
    done

FROM scratch
COPY --from=0 /opt/root /
COPY --from=0 /src/ports /src/ports

RUN mkdir -p /opt/root && \
    cd /src/ports && \
    mk all

RUN ROOT=/opt/root DATA=/opt/root/var/db/pm pm -fva /var/cache/repo/basefs@*.tgz && \
    rm /var/cache/repo/basefs@*.tgz

RUN for file in /var/cache/repo/*.tgz; do \
        ROOT=/opt/root DATA=/opt/root/var/db/pm pm -fva "${file}" ; \
    done

FROM scratch
COPY --from=1 /opt/root /
COPY --from=1 /src/ports /src/ports
