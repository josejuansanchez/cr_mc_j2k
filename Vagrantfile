# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  #config.vm.box = "ubuntu/bionic64"
  config.vm.box = "ubuntu/xenial64"

  config.vm.provider :virtualbox do |v|
    v.memory = "2048"
    v.cpus = "4"
  end

  config.vm.provision "shell", inline: <<-SHELL
     apt-get update
     apt-get install -y unzip
     apt-get install -y g++
     apt-get install -y pkg-config
     apt-get install -y libpng16-16
     apt-get install -y libpng-dev
     apt-get install -y libpng16-dev
     apt-get install -y zlib1g-dev
     apt-get install -y imagemagick
     apt-get install -y bc
     apt-get install -y octave
     apt-get install -y octave-image
     apt-get install -y ffmpeg
     apt-get install -y gnuplot5

     mkdir -p /vagrant/src/Kakadu
     cp /vagrant/kakadu/v6_4_1-00305L.zip /vagrant/src/Kakadu
     cd /vagrant/src/Kakadu
     unzip -o v6_4_1-00305L.zip
  SHELL
end
