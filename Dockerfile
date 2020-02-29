FROM ubuntu:xenial

RUN apt-get update \
    && apt-get install -y git \
    && apt-get install -y unzip \
    && apt-get install -y g++ \
    && apt-get install -y pkg-config \
    && apt-get install -y libpng16-16 \
    && apt-get install -y libpng-dev \
    && apt-get install -y zlib1g-dev \
    && apt-get install -y imagemagick \
    && apt-get install -y bc \
    && apt-get install -y octave \
    && apt-get install -y octave-image \
    && apt-get install -y ffmpeg \
    && apt-get install -y gnuplot5 \
    && mkdir -p /vagrant/src/Kakadu

WORKDIR /vagrant

#RUN git clone https://github.com/josejuansanchez/cr_mc_j2k.git --depth 1

#ADD src/Kakadu/v6_4_1-00305L.zip /vagrant/src/Kakadu

#RUN cd /vagrant/src/Kakadu \
#    && unzip v6_4_1-00305L.zip \
#    && cd v6_4_1-00305L/make \
#    && make -f Makefile-Linux-x86-64-gcc 

#ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/vagrant/src/Kakadu/v6_4_1-00305L/lib/Linux-x86-64-gcc
#ENV PATH=$PATH:/vagrant/src/Kakadu/v6_4_1-00305L/bin/Linux-x86-64-gcc
#ENV CR_MC_J2K_HOME=/vagrant