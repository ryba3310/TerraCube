#!/bin/bash



terraform apply -auto-approve


master_node=$(terraform output -json | jq -r '.master.value[]')
declare -a worker_node=$(terraform output -json | jq -r '.workers.value[]')


ansible_ini_file='inventory.ini'

# Populate masteer host
echo "[master]" > "${ansible_ini_file}"
for ip in "${master_node}"; do
  echo "${ip} ansible_user=admin" >> "${ansible_ini_file}"
done
# Populate worker hosts
echo "[workers]" >> "${ansible_ini_file}"
for ip in ${worker_node[@]}; do
  echo "${ip} ansible_user=admin" >> "${ansible_ini_file}"
done

# Sleep to avoid connection errors
sleep 20

export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i inventory.ini playbook.yml



##### USE #####
# /api/v2/authorizations path
# to obtain InfluxDB token
