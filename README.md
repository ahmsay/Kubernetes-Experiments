# Kubernetes-Experiments
This repository contains various examples that can be hard to find in the official Kubernetes documentation.

To make it shorter, I gave an alias to the kubectl utility:
</br>

```bash
alias k=kubectl
```

## Table of Contents
**[Internal Request](#internal-request)**<br>
**[Verify External Variables](#verify-external-variables)**<br>

## Internal Request
It's possible to send a request to a resource without exposing it to a NodePort service.
### Request to Pod
Run an example web application in a pod.
```bash
k run myapp --image=httpd
```
Get the ip and port of the pod (if port is not shown, default port is 80 like in this example).
```bash
k get pod -o wide
```
Send an internal request directly to the pod.
```bash
k run nginxtmp --image=nginx:alpine --restart=Never --rm -it -- curl -m 5 <ip>:<port>
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
## Verify External Variables
To verify the environment variables, configmap values or secret values you gave are passed to the container, do the following steps.<br>

Create a pod with an environment variable.
```bash
k run myapp --image=nginx --env="DNS_DOMAIN=cluster"
```
Verify the environment inside the container.
```bash
k exec myapp -- printenv DNS_DOMAIN
```
