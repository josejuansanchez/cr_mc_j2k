# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  #config.vm.box = "ubuntu/bionic64"
  config.vm.box = "ubuntu/xenial64"

  config.vm.provision "shell", inline: <<-SHELL
     apt-get update
     apt-get install -y unzip
     apt-get install -y g++
     cp /vagrant/kakadu/v6_4_1-00305L.zip /vagrant/src/Kakadu
     cd /vagrant/src/Kakadu
     unzip -o v6_4_1-00305L.zip
  SHELL
end
