#
# Cookbook:: docker
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
execute "allow-apt-over-https" do
    command "apt-get update & apt-get install \
            apt-transport-https \
            ca-certificates \
            curl \
            gnupg-agent \
            software-properties-common -y "
      action :run
      notifies :run, 'execute[add-docker-gpg-key]', :immediately
  end
  
execute "add-docker-gpg-key" do
    command " curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -"
    action :nothing
    notifies :run, 'execute[add-docker-repository]', :immediately
end

execute "add-docker-repository" do
    command "add-apt-repository \
            \"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
            $(lsb_release -cs) \
            stable\""
    action :nothing
    notifies :run, 'execute[install-docker]', :immediately
end
  
  execute "install-docker" do
    command "apt-get update & apt-get install docker-ce containerd.io --allow-unauthenticated -y"
    action :nothing
  end
  