FROM arm32v7/debian:buster
COPY qemu-arm-static /usr/bin

ENV LANG C.UTF-8

#Install mopidy

RUN set -ex \
    # Official Mopidy install for Debian/Ubuntu along with some extensions
    # (see https://docs.mopidy.com/en/latest/installation/debian/ )
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        curl \
        gnupg \
        jq \
        libxml2-dev \
        libxslt-dev \
        libz-dev \
        python-crypto \
    && apt-get clean \
    && curl -L https://apt.mopidy.com/mopidy.gpg -o /tmp/mopidy.gpg \
    && curl -L https://apt.mopidy.com/mopidy.list -o /etc/apt/sources.list.d/mopidy.list \
    && apt-key add /tmp/mopidy.gpg \
    && apt-get update \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache

RUN set -ex \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        gstreamer1.0-alsa \
        gstreamer1.0-libav \
        gstreamer1.0-plugins-bad \
        gstreamer1.0-plugins-ugly \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache

RUN set -ex \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        build-essential \
        gcc \
        mopidy \
        mopidy-local-sqlite \
        mopidy-spotify \
        python-dev \
    && curl -L https://bootstrap.pypa.io/get-pip.py | python - \
    && pip install -U six oauth2client pyasn1 \
    && pip install \
        Mopidy-Moped \
        Mopidy-GMusic \
        Mopidy-Iris \
        Mopidy-TuneIn \
        Mopidy-Podcast \
        Mopidy-Podcast-iTunes \
        Mopidy-MPD \
    && apt-get purge --auto-remove -y \
        curl \
        gcc \
        build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache


COPY mopidy.conf /var/lib/mopidy/.config/mopidy/mopidy.conf

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

EXPOSE 6600 6680
CMD [ "/run.sh" ]
