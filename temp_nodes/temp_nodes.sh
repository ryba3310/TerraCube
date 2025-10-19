#!/bin/bash

[ -f ./temp_timer ] && echo 360 > temp_timer && exit 0


cd ./temp_nodes/
eval $(ssh-agent)
ssh-add ./terracube.key
export GOOGLE_APPLICATION_CREDENTIALS=google_key.json

terraform apply -auto-approve


declare -a worker_node=$(terraform output -json | jq -r '.workers.value[]')

ansible_ini_file='inventory.ini'

# Populate worker hosts
echo "[workers]" > "${ansible_ini_file}"
for ip in ${worker_node[@]}; do
  echo "${ip} ansible_user=admin" >> "${ansible_ini_file}"
done

# Sleep to avoid connection errors
sleep 20

export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i inventory.ini playbook_temp.yml

echo 300 > temp_timer

while true
do
  sleep 1
  read -r time  < temp_timer
  (( time )) || break
  ((time--))
  echo $time > temp_timer
done

terraform apply -destroy -auto-approve

