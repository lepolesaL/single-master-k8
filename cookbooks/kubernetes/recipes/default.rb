#
# Cookbook:: kubernetes
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

execute "update-install" do
  command "sudo apt-get update & sudo apt-get install -y apt-transport-https curl"
  action :run
  notifies :run, 'execute[add-apt-key]', :immediately
end

execute "add-apt-key" do
  command "sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -"
  action :nothing
end

template "/etc/apt/sources.list.d/kubernetes.list" do
  source "kubernetes.list"
  action :create
  notifies :run, 'execute[add-apt-key]', :before
  notifies :run, 'execute[update-repositories-kubernetes]', :immediately
end
# execute "add-repository" do
#   command "cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
#   deb https://apt.kubernetes.io/ kubernetes-xenial main
#   EOF"
#   action :run
# end

execute "update-repositories-kubernetes" do
  command "apt-get update"
  action :nothing
  notifies :run, 'execute[install-kubeadm-kubelet]', :immediately
end

execute "install-kubeadm-kubelet" do
  command "apt-get install -y kubelet kubeadm kubectl"
  action :nothing
  # notifies :run, 'execute[initialize-kubeadm]', :immediately
end

execute "configure-kubectl" do
  command "mkdir $HOME/.kube/ & export KUBECONFIG=$KUBECONFIG:$HOME/.kube/config & cp /etc/kubernetes/admin.conf $HOME/.kube/config"
  action :nothing
end

execute "start-kubelet" do
  command "systemctl start kubelet"
  action :nothing
end

# execute "initialize-kubeadm" do
#   command "kubeadm init"
#   action :nothing
#   notifies :run, 'execute[start-kubelet]', :immediately
#   notifies :run, 'execute[configure-kubectl]', :immediately
# end

