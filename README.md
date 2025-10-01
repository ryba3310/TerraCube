
# Intro

A project deploying and running Kubernetes cluster within cloud, using Terraform and Ansible as IaC to prepare environment and dynamically provision new worker nodes using spot instances for scaleability in case of temporal intense traffic.
In cluster there is hosted a full monitoring stack, Grafana, Prometheus, Telegraf, InfluxDB and some Self-hosted utilities like PiHole or dashboard(Heimdall) and Nextcloud.

Run kuberneet cluster with minimm neccessary resources and proviion spot instances which join the cluster in case of traffic spike.



# TODO

- ✅ Some basic outline of purpose
- ⚠️   Prepare master-node and worker-node images with Packer
- ⚠️   Make Terraform script to provision long living nodes
- ⚠️   Make Terraform script to provision temporary nodes
- ⚠️   Prepare SSH access for every node after provisioning
- ⚠️   Create Ansible playbook which takes care of node membership after being provisioned
- ⚠️   Use cloud features to divide network into public and private
- ⚠️   Gather KPIs to monitor cluster utilization
- ⚠️   Create alert/threshold which provisions new nodes during heavy times
- ⚠️   Use Kafka messege queuing ?
- ⚠️   Prepare YAML configs for Kubernetes cluster
- ⚠️   Prepare some interface to put any contaierized application ?
- ❌  reserved
