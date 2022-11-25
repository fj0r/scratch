FROM fj0rd/scratch:py-test as bootstrap
FROM fj0rd/scratch:musl as musl

# https://raw.githubusercontent.com/docker-library/python/master/3.11/slim-bullseye/Dockerfile
FROM debian:bullseye-slim as build

# ensure local python is preferred over distribution python
ENV PATH /opt/python/bin:$PATH
ENV LD_LIBRARY_PATH /opt/python/lib:$LD_LIBRARY_PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# runtime dependencies
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		netbase \
		tzdata \
		zstd \
		ripgrep \
		curl \
		jq \
	; \
	rm -rf /var/lib/apt/lists/*

COPY --from=bootstrap /opt/python /python
COPY --from=musl /opt/musl /opt/musl
ENV PATH /opt/musl/bin:$PATH
RUN set -eux; \
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		dpkg-dev \
		gcc \
		gnupg dirmngr \
		libbluetooth-dev \
		libbz2-dev \
		libc6-dev \
		libexpat1-dev \
		libffi-dev \
		libgdbm-dev \
		liblzma-dev \
		libncursesw5-dev \
		libreadline-dev \
		libsqlite3-dev \
		libssl-dev \
		libssl3-dev \
		make \
		tk-dev \
		uuid-dev \
		wget \
		xz-utils \
		zlib1g-dev \
	; \
	\
	mkdir -p /usr/src/python; \
	python_url=$(curl -sSL https://www.python.org/downloads/ | rg '<a.+href="(.+xz)">Download Python' -or '$1'); \
	curl -sSL $python_url | tar -Jxf - -C /usr/src/python --strip-components=1; \
	CC="/opt/musl/bin/x86_64-linux-musl-gcc -fPIE -pie"; \
	\
	cd /usr/src/python; \
	gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
	echo 'ac_cv_file__dev_ptmx=no' >> config.site; \
	echo 'ac_cv_file__dev_ptc=no' >> config.site; \
	CONFIG_SITE=config.site \
	./configure \
	    --prefix=/opt/python \
		--build="$gnuArch" \
        --host=x86_64-linux-musl \
        --with-build-python=/python/bin/python3 \
		--enable-loadable-sqlite-extensions \
		--enable-optimizations \
		--enable-option-checking=fatal \
		--with-lto \
		--with-system-expat \
		--with-system-ffi \
		--without-ensurepip \
		--disable-shared \
		--disable-ipv6 \
		LDFLAGS="-static" \
		CFLAGS="-static" \
		CPPFLAGS="-static" \
	; \
	rm -rf /var/lib/apt/lists/*
