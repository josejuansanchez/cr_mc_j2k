FROM ubuntu

RUN apt-get update \
    && apt-get install -y unzip \
    && apt-get install -y g++ \
    && apt-get install -y pkg-config \
    && apt-get install -y libpng16-16 \
    && apt-get install -y libpng-dev \
    && apt-get install -y libpng16-dev \
    && apt-get install -y zlib1g-dev \
    && apt-get install -y imagemagick \
    && apt-get install -y bc \
    && apt-get install -y octave \
    && apt-get install -y octave-image \
    && apt-get install -y ffmpeg \
    && apt-get install -y unzip \
    && mkdir -p /vagrant/src/Kakadu

ADD src/Kakadu/v6_4_1-00305L.zip /vagrant/src/Kakadu

VOLUME /vagrant