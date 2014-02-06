#
#-*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "ubuntu-test-5-berkshelf"
  config.vm.box = "Ubuntu-12.04-daily-Cloud-Image-x86_64"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"
  config.vm.network :private_network, ip: "33.33.33.10"
  config.vm.boot_timeout = 120
  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest
  config.vm.provision :chef_solo do |chef|
     chef.json = {
       :postgresql =>{
       :password =>{
       :postgres =>"iloverandompasswordsbutthiswilldo"
       },
       'php' => {
           'install_method' => 'package'
       },
       :singularity_stack => {
         :project_name => 'foo'
       }
     }
   }
     chef.run_list = [
     "recipe[postgresql::server]",
     "recipe[php-fpm]",
     "recipe[nginx]",
     "recipe[php]",
     "recipe[composer]",
     "recipe[singularity-stack]"
   ]
   end

end
