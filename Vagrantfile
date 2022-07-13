# -*- mode: ruby -*-
# vi: set ft=ruby :

IMAGE_NAME = "ubuntu/focal64"
#IMAGE_NAME = "ubuntu/jammy64"
#IMAGE_NAME = "aspyatkin/ubuntu-20.04-server" # Minimal server install
N = 5

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false

    config.vm.provider "virtualbox" do |v|
        v.memory = 4096
        v.cpus = 4
    end

    config.vm.define "kubelb-01" do |kubelb|
      kubelb.vm.box = IMAGE_NAME
      kubelb.vm.network "private_network", ip: "192.168.60.130"
      kubelb.vm.hostname = "kubelb-01"
      kubelb.vm.network :public_network, bridge: "enp39s0", ip: "10.0.1.130"
      kubelb.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbooks/node-lb-playbook.yml"
        ansible.extra_vars = {
        #node_ip: "192.168.60.130",
        node_ip: "10.0.1.130",
      }
      end
    end

    (1..N).each do |i|
      config.vm.define "controller-0#{i}" do |master|
        config.vm.synced_folder ".", "/vagrant", disabled: false
        master.vm.box = IMAGE_NAME
        master.vm.network "private_network", ip: "192.168.60.1#{i + 30}"
        master.vm.network :public_network, bridge: "enp39s0", ip: "10.0.1.1#{i + 30}"
        master.vm.hostname = "controller-0#{i}"
        master.vm.provision "ansible" do |ansible|
            ansible.playbook = "playbooks/master-containerd-playbook.yml"
            ansible.extra_vars = {
                #node_ip: "192.168.60.1#{i + 30}",
              node_ip: "10.0.1.1#{i + 30}",
            }
        end
      end
    end

    (1..N).each do |i|
        config.vm.define "worker-0#{i}" do |worker|
        #if Vagrant.has_plugin?("vagrant-vbguest")
        config.vbguest.auto_update = false
        #end
            worker.vm.box = IMAGE_NAME
            worker.vm.network "private_network", ip: "192.168.60.1#{i + 33}"
            worker.vm.hostname = "worker-0#{i}"
            worker.vm.network :public_network, bridge: "enp39s0", ip: "10.0.1.1#{i + 33}"
            worker.vm.provision "ansible" do |ansible|
                ansible.playbook = "playbooks/worker-containerd-playbook.yml"
                ansible.extra_vars = {
                    #node_ip: "192.168.60.1#{i + 33}",
                    node_ip: "10.0.1.1#{i + 33}",
                }
            end
        end
    end
end


