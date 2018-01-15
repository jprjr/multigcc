FROM jprjr/multigcc:base

RUN mkdir -p /src /opt/root && \
    git clone https://github.com/jprjr/multigcc-ports.git /src/ports && \
    cd /src/ports && \
    rm -rf gcc-4.9 gcc-6.4 gcc-7.2 && \
    mk all

RUN for file in /var/cache/repo/*.tgz; do \
        ROOT=/opt/root DATA=/opt/root/var/db/pm pm -fva "${file}" ; \
    done

FROM scratch
COPY --from=0 /opt/root /

RUN mkdir -p /src /opt/root && \
    git clone https://github.com/jprjr/multigcc-ports.git /src/ports && \
    cd /src/ports && \
    rm -rf gcc-4.9 gcc-6.4 gcc-7.2 && \
    mk all

RUN for file in /var/cache/repo/*.tgz; do \
        ROOT=/opt/root DATA=/opt/root/var/db/pm pm -fva "${file}" ; \
    done
FROM scratch
COPY --from=1 /opt/root /
