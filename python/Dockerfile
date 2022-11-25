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
ENV PKG_CONFIG_ALLOW_CROSS=1
ENV OPENSSL_STATIC=true OPENSSL_DIR=/opt/musl
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
    ln -s /usr/include/x86_64-linux-gnu/asm /opt/musl/include/x86_64-linux-musl/asm; \
    ln -s /usr/include/asm-generic /opt/musl/include/x86_64-linux-musl/asm-generic; \
    ln -s /usr/include/linux /opt/musl/include/x86_64-linux-musl/linux; \
    ln -s /usr/include/x86_64-linux-gnu/ffi.h /opt/musl/x86_64-linux-musl/ffi.h; \
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
		--enable-optimizations \
		--enable-option-checking=fatal \
		--with-lto \
		--with-system-expat \
		--with-system-ffi \
		--without-ensurepip \
		--disable-shared \
		--disable-ipv6 \
	; \
	nproc="$(nproc)"; \
	make -j "$nproc" \
		LDFLAGS="-Wl,--strip-all,-static" \
		CFLAGS="-static" \
		CPPFLAGS="-static" \
	; \
	make install; \
	\
	cd /; \
	rm -rf /usr/src/python; \
	\
	find /opt/python -depth \
		\( \
			\( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
			-o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name 'libpython*.a' \) \) \
		\) -exec rm -rf '{}' + \
	; \
	\
	ldconfig; \
	\
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	find /opt/python -type f -executable -not \( -name '*tkinter*' \) -exec ldd '{}' ';' \
		| awk '/=>/ { print $(NF-1) }' \
		| sort -u \
		| xargs -r dpkg-query --search \
		| cut -d: -f1 \
		| sort -u \
		| xargs -r apt-mark manual \
	; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*; \
	\
	python3 --version

# make some useful symlinks that are expected to exist ("/opt/python/bin/python" and friends)
RUN set -eux; \
	for src in idle3 pydoc3 python3 python3-config; do \
		dst="$(echo "$src" | tr -d 3)"; \
		[ -s "/opt/python/bin/$src" ]; \
		[ ! -e "/opt/python/bin/$dst" ]; \
		ln -svT "$src" "/opt/python/bin/$dst"; \
	done

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 22.3
# https://github.com/docker-library/python/issues/365
ENV PYTHON_SETUPTOOLS_VERSION 65.5.0
# https://github.com/pypa/get-pip
ENV PYTHON_GET_PIP_URL https://github.com/pypa/get-pip/raw/66030fa03382b4914d4c4d0896961a0bdeeeb274/public/get-pip.py
ENV PYTHON_GET_PIP_SHA256 1e501cf004eac1b7eb1f97266d28f995ae835d30250bec7f8850562703067dc6

RUN set -eux; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends wget; \
	\
	wget -O get-pip.py "$PYTHON_GET_PIP_URL"; \
	echo "$PYTHON_GET_PIP_SHA256 *get-pip.py" | sha256sum -c -; \
	\
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark > /dev/null; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*; \
	\
	export PYTHONDONTWRITEBYTECODE=1; \
	\
	python get-pip.py \
		--disable-pip-version-check \
		--no-cache-dir \
		--no-compile \
		"pip==$PYTHON_PIP_VERSION" \
		"setuptools==$PYTHON_SETUPTOOLS_VERSION" \
	; \
	rm -f get-pip.py; \
	\
	pip --version

RUN set -eux \
  ; mkdir -p /target \
  ; tar -C /opt -cf - python | zstd -T0 -19 > /target/python.tar.zst

FROM scratch
COPY --from=build /target /
