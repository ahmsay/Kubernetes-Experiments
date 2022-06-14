# Kubernetes-Experiments
This repository contains various examples that can be hard to find in the official Kubernetes documentation.

To make it shorter, I gave an alias to the kubectl utility:

```bash
alias k=kubectl
```

## Table of Contents
**[Sending Internal Request](#sending-internal-request)**<br>
**[Verifying External Variables](#verifying-external-variables)**<br>
**[Accessing Nodes](#accessing-nodes)**<br>
**[Listing All Resources](#listing-all-resources)**<br>

## Sending Internal Request
It's possible to send a request to a resource without exposing it to a NodePort service.
### Request to Pod
Run an example web application in a pod.
```bash
k run myapp --image=httpd
```
Get the IP and port of the pod (if port is not shown, default port is 80 like in this example).
```bash
k get pod -o wide
```
Send an internal request directly to the pod.
```bash
k run nginxtmp --image=nginx:alpine --restart=Never --rm -it -- curl -m 5 <ip>:<port>
```
The output will be like this:
```
<html><body><h1>It works!</h1></body></html>
```
Lets examine the parameters:
- --restart=Never: To prevent the container to restart
- --rm: Automatically deletes the pod when the container stops
- -it: Interactive Terminal to run sh commands
- --: After this part, everything you type is considered an sh command
- curl -m 5: Sends a curl request with a timeout of 5 seconds
### Request to ClusterIP Service
Run an example web application in a pod.
```bash
k run myapp --image=httpd
```
Create a service for the application.
```bash
k expose pod myapp --port=8080 --target-port=80
```
Get the service ip and port.
```bash
k get svc
```
Send an internal request to the ClusterIP service.
```bash
k run nginxtmp --image=nginx:alpine --restart=Never --rm -it -- curl -m 5 <ip>:8080
```
## Verifying External Variables
To verify the environment variables, configmap values or secret values you gave are passed to the container, do the following steps.

Create a pod with an environment variable.
```bash
k run myapp --image=nginx --env="DNS_DOMAIN=cluster"
```
Verify the environment inside the container.
```bash
k exec myapp -- printenv DNS_DOMAIN
```
The output will be `cluster`.
## Accessing Nodes
You can access your worker nodes without requiring their IP.

List your nodes and their names.
```bash
k get node
```
Connect to your node with its name.
```bash
ssh <node-name>
```
You can also execute a single command without staying connected.
```bash
ssh <node-name> -- echo hello
```
## Listing All Resources
You can't get all resources with `kubectl get all` command. To do that, you should use the following command:
```bash
kubectl api-resources --verbs=list --namespaced -o name  | xargs -n 1 kubectl get --show-kind --ignore-not-found -n <namespace>
```
