FROM hassioaddons/debian-base-armv7:3.2.1

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
        python3-crypto \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache

RUN set -ex \
    # Official Mopidy install for Debian/Ubuntu along with some extensions
    # (see https://docs.mopidy.com/en/latest/installation/debian/ )
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      ca-certificates \
    && curl -v -L https://apt.mopidy.com/mopidy.gpg -o /tmp/mopidy.gpg \
    && curl -v -L https://apt.mopidy.com/mopidy.list -o /etc/apt/sources.list.d/mopidy.list \
    && apt-key add /tmp/mopidy.gpg \
    && apt-get update \
    && apt-get clean \
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
        python3-dev \
        python3-pip \
    && curl -L https://bootstrap.pypa.io/get-pip.py | python - \
    && pip3 install -U six oauth2client pyasn1 \
    && pip3 install \
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
