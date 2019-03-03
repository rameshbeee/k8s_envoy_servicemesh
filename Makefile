clean:
	@rm -rf dist

build:
	@ docker build -t gcr.io/envoy_servicemesh/servicea:latest service_a/ 
	@ docker build -t gcr.io/envoy_servicemesh/serviceb:latest service_b/ 
	@ docker build -t gcr.io/envoy_servicemesh/servicec:latest service_c/ 
push:
	@ docker push gcr.io/envoy_servicemesh/servicea:latest
	@ docker push gcr.io/envoy_servicemesh/serviceb:latest
	@ docker push gcr.io/envoy_servicemesh/servicec:latest

servicea:
	@ kubectl delete configmap sidecar-config-a;exit 0
	@ kubectl create configmap sidecar-config-a --from-file=envoy-config=./service_a/envoy-config.yaml
	@ kubectl delete -f ./service_a/k8_deployment.yml;exit 0
	@ kubectl create -f ./service_a/k8_deployment.yml

serviceb:
	@ kubectl delete configmap sidecar-config-b;exit 0
	@ kubectl create configmap sidecar-config-b --from-file=envoy-config=./service_b/envoy-config.yaml
	@ kubectl delete -f ./service_b/k8_deployment.yml; exit 0
	@ kubectl create -f ./service_b/k8_deployment.yml

servicec:
	@ kubectl delete configmap sidecar-config-c;exit 0
	@ kubectl create configmap sidecar-config-c --from-file=envoy-config=./service_c/envoy-config.yaml
	@ kubectl delete -f ./service_c/k8_deployment.yml; exit 0
	@ kubectl create -f ./service_c/k8_deployment.yml

frontend:
	@ kubectl delete configmap frontend-config;exit 0
	@ kubectl create configmap frontend-config --from-file=envoy-config=./front_envoy/envoy-config.yaml
	@ kubectl delete -f ./front_envoy/k8_deployment.yml;exit 0
	@ kubectl create -f ./front_envoy/k8_deployment.yml

bootup: serviceb servicec servicea frontend

shutdown:
	@ kubectl delete configmap sidecar-config-b;exit 0
	@ kubectl delete -f ./service_b/k8_deployment.yml; exit 0
	@ kubectl delete configmap sidecar-config-c;exit 0
	@ kubectl delete -f ./service_c/k8_deployment.yml; exit 0
	@ kubectl delete configmap sidecar-config-a;exit 0
	@ kubectl delete -f ./service_a/k8_deployment.yml;exit 0
	@ kubectl delete configmap frontend-config;exit 0
	@ kubectl delete -f ./front_envoy/k8_deployment.yml;exit 0

.PHONY: build clean push servicea serviceb servicec frontend shutdown shutdown
