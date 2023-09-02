## Summary
### OS : ubuntu 20.04, 22.04
### k8s : 1.24.6
### cni : flannel
### cri : containerd v1.6.8
### kubespray : release-2.20
-------------------------------
# How to use this repository
-------------------------------
### * Please remind that removal command of offlined node doesn't work on ubuntu 22.04.
### 1. install k8s and setup one master node using bootstrap.sh
### 2. run 'add_node.sh' before adding a new node into the cluster 
### 3. 'ssh-copy-id "remote-user"@"ip-of-new-node"'
-------------------------------
# How to enter dashboard
-------------------------------
### 1. kubectl create token -n kube-system admin-user
### 2. copy the token then paste it to the browser
-------------------------------
# How to add worker
-------------------------------
### 1. inventory/<cluster-name>/hosts.yml에 추가할 노드 명시
### 2. ansible-playbook -i inventory/<cluster-name>/hosts.yml --become --become-user=root facts.yml -K
### 3-1. (option 1) ansible-playbook -i inventory/<cluster-name>/hosts.yml --become --become-user=root scale.yml -K
### 3-2. (option 2) ansible-playbook -i inventory/<cluster-name>/hosts.yml --become --become-user=root scale.yml --limit=<추가할 노드 이름> -K
### 3-3. (option 3) ansible-playbook -i inventory/<cluster-name>/hosts.yml --become --become-user=root cluster.yml -K
-------------------------------
# How to add control plane(not etcd)
-------------------------------
### 1. inventory/<cluster-name>/hosts.yml에 추가할 노드 명시
### 2. ansible-playbook -i inventory/<cluster-name>/hosts.yml --become --become-user=root cluster.yml -K
-------------------------------
# How to add control plane(also etcd)
-------------------------------
### 1. inventory/<cluster-name>/hosts.yml에 추가할 노드 명시(반드시 etcd는 홀수가 되어야함)
### 2. ansible-playbook -i inventory/<cluster-name>/hosts.yml --become --become-user=root cluster.yml --limit=etcd,kube_control_plane -e ignore_assert_errors=yes -K
### 3. ansible-playbook -i inventory/<cluster-name>/hosts.yml --become --become-user=root upgrade-cluster.yml --limit=etcd,kube_control_plane -e ignore_assert_errors=yes -K
### 4. 모든 control plane 노드에서 /etc/kubernetes/manifests/kube-apiserver.yaml 안의 --etcd-servers 파라미터에 새로운 etcd를 추가
-------------------------------
#  How to remove worker or control plane(not etcd)
-------------------------------
### 1. inventory/<cluster-name>/hosts.yml에 삭제할 노드 명시
### 2-1. [online] ansible-playbook -i inventory/<cluster-name>/hosts.yml --become --become-user=root remove-node.yml -e node=<NODE_NAME> -K
### 2-2. [offline] ansible-playbook -i inventory/<cluster-name>/hosts.yml --become --become-user=root remove-node.yml -e node=<NODE_NAME> -e reset_nodes=false -e allow_ungraceful_removal=true -K
### 3. inventory/<cluster-name>/hosts.yml에 삭제된 노드 제거
-------------------------------
# How to remove and replace control plane(also etcd) when one is down
-------------------------------
### 1. inventory/<cluster-name>/hosts.yml에 삭제할 노드 명시
### 2-1. [online] ansible-playbook -i inventory/<cluster-name>/hosts.yml --become --become-user=root remove-node.yml -e node=<NODE_NAME> -K
### 2-2. [unofficial] [offline] ansible-playbook -i inventory/<cluster-name>/hosts.yml --become --become-user=root remove-node.yml -e node=NODE_NAME -e reset_nodes=false -e allow_ungraceful_removal=true -K
### 3. inventory/<cluster-name>/hosts.yml에서 삭제된 노드 제거 & 새로 추가될 노드 명시(etcd 노드 수는 홀수가 되어야함)
### 7. ansible-playbook -i inventory/<cluster-name>/hosts.yml --become --become-user=root cluster.yml -K
### 8. ansible-playbook -i inventory/<cluster-name>/hosts.yml --become --become-user=root upgrade-cluster.yml --limit=etcd,kube_control_plane -e ignore_assert_errors=yes -K
### 9. 모든 control plane 노드에서 /etc/kubernetes/manifests/kube-apiserver.yaml 안의 --etcd-servers 파라미터에 새로운 etcd 서버아이피 명시
-------------------------------
# How to replace first deployed control plane(etcd or not)
-------------------------------
### 1. inventory/<cluster-name>/hosts.yml의 [kube_control_plane] 항목에서 삭제할 control plane을 맨 아래로 배치
### 2-1. [online] ansible-playbook -i inventory/<cluster-name>/hosts.yml --become --become-user=root remove-node.yml -e node=<NODE_NAME> -K
### 2-2. [unofficial] [offline] ansible-playbook -i inventory/<cluster-name>/hosts.yml --become --become-user=root remove-node.yml -e node=<NODE_NAME> -e reset_nodes=false -e allow_ungraceful_removal=true -K
### 3. "kubectl  edit cm -n kube-public cluster-info"를 이용하여 [server] 필드에 있던 삭제된 control plane 노드의 아이피를 추가될 control plane 의 아이피로 변경. 인증서 변경했을 경우에 [certificate-authority-data] 필드로 변경
### 4. inventory/<cluster-name>/hosts.yml에서 삭제된 노드 제거 및 새로 추가될 노드 명시(etcd 노드 수는 홀수가 되어야함)
### 5. ansible-playbook -i inventory/<cluster-name>/hosts.yml --become --become-user=root cluster.yml --limit=etcd,kube_control_plane -K (모든 노드에 설정 파일 재생성)
-------------------------------
# How to delete entire cluster
-------------------------------
### 1. ansible-playbook -i inventory/<cluster-name>/hosts.yml -b --become-user=root reset.yml -K
