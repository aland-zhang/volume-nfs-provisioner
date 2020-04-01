provisioner:	
	docker build . --build-arg http_proxy=$(PROXY)  --build-arg https_proxy=$(PROXY) -f Dockerfile.provisioner -t daocloud.io/piraeus/volume-nfs-provisioner

upload:
	docker push daocloud.io/piraeus/volume-nfs-provisioner

all: provisioner upload test

test:
	kubectl delete -f provisioner.yaml || true
	kubectl apply -f provisioner.yaml