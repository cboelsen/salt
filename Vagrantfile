# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "archlinux/archlinux"
  config.vm.hostname = "archdev"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 8192
    vb.cpus = 6
    vb.customize ["modifyvm", :id, "--vram", "32"]
  end

  config.vm.provision "shell", inline: <<-SHELL
    pacman --noconfirm -Sy
    pacman --noconfirm -S salt python2-pygit2 git
  SHELL

  config.vm.provision :salt do |salt|
      salt.pillar({
          "user" => ENV["USER"],
          "email" => ENV["EMAIL"]
      })
      salt.masterless = true
      salt.minion_config = "minion"
      salt.run_highstate = true      
  end
end
