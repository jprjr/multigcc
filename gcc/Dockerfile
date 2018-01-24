FROM jprjr/multigcc:base

ARG GCCPKG

RUN mkdir -p /src /opt/root && \
    git clone https://github.com/jprjr/multigcc-ports.git /src/ports && \
    cd /src/ports && \
    mk $GCCPKG && \
    mk bootstrap && \
    mk cross-packages

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
    mk $GCCPKG && \
    mk bootstrap && \
    mk cross-packages

RUN ROOT=/opt/root DATA=/opt/root/var/db/pm pm -fva /var/cache/repo/basefs@*.tgz && \
    rm /var/cache/repo/basefs@*.tgz

RUN for file in /var/cache/repo/*.tgz; do \
        ROOT=/opt/root DATA=/opt/root/var/db/pm pm -fva "${file}" ; \
    done

FROM scratch
COPY --from=1 /opt/root /
COPY --from=1 /src/ports /src/ports
