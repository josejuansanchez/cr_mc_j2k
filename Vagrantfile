# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  #config.vm.box = "ubuntu/bionic64"
  config.vm.box = "ubuntu/xenial64"

  config.vm.provision "shell", inline: <<-SHELL
     apt-get update
     apt-get install -y unzip
     apt-get install -y g++
     apt-get install -y pkg-config
     apt-get install libpng16-16
     apt-get install libpng-dev
     apt-get install libpng16-dev
     apt-get install zlib1g-dev
     apt-get install imagemagick
     apt-get install bc
     apt-get install octave
     apt-get install octave-image
     apt-get install ffmpeg

     mkdir -p /vagrant/src/Kakadu
     cp /vagrant/kakadu/v6_4_1-00305L.zip /vagrant/src/Kakadu
     cd /vagrant/src/Kakadu
     unzip -o v6_4_1-00305L.zip
  SHELL
end
