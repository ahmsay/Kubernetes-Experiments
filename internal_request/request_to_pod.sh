# Run an example web application in a pod
k run myapp --image=httpd
# Get the ip and port of the pod (if port is not shown, default port is 80 like in this example)
k get pod -o wide
# Send an internal request directly to the pod
k run nginxtmp --image=nginx:alpine --restart=Never --rm -it -- curl -m 5 <ip>:<port>