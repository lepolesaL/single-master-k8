# single-master-k8-cluster
Kubernetes cluster with single master and  two nodes using vagrant and chef-solo

## Creating K8 cluster control-plane (Manual step to be automated)
Run the following command on master node
```sh
vagrant ssh kmaster
```
In kmaster shell run the following command
```sh
sudo kubeadm init --apiserver-advertise-address=192.168.50.2 --apiserver-cert-extra-sans=<hostname>
```
## Join worker node master node
Run the following command on worker to master node
```sh
vagrant ssh knode-n # n is the number representing the node, knode-1
```
In knode shell run the following
```sh
sudo kubeadm join 192.168.50.2:6443 --token <token>    --discovery-token-ca-cert-hash <token-ca-cert-hash>
```

## Copy Adim configuration for kubectl
On the master node, navigate to /etc/kubernetes and copy admin.conf to the host machine in ~/.kube/config the change the ip address to that of the bridge network, interface 3. (TODO use domain name)

## Install network
Install Flannel network (simple overlay network) on kubernetes cluster
```sh
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

