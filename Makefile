
SSL_KEY_SIZE ?= 4096
SSL_CERT_DAYS ?= 365
SSL_DOMAIN ?= www.example.com
SSL_FILENAME ?= server


$(info SSL_KEY_SIZEL: $(SSL_KEY_SIZE))
$(info SSL_CERT_DAYS: $(SSL_CERT_DAYS))
$(info SSL_DOMAIN: $(SSL_DOMAIN))
$(info SSL_FILENAME: $(SSL_FILENAME))


LOCAL_VOLUME ?= $(PWD)/data/
VOLUME_PATH ?= /var/jenkins_home

IMAGE_NAME ?= jenkins
IMAGE_TAG ?= latest

CONTAINER_NAME ?= jenkins

DOCKER_IP ?= $(shell boot2docker ip)


all: selfsignedcert dockerrun


dockerpull:
	docker pull $(IMAGE_NAME):$(IMAGE_TAG)

dockerrun: dockerbuild
	mkdir -p $(LOCAL_VOLUME)
	docker stop $(CONTAINER_NAME) || echo "Not stoppable yet"
	docker rm $(CONTAINER_NAME) || echo "Not removable yet"
	docker run -p 50000:50000 -p 8080:8080 -p 8083:8083 -v $(LOCAL_VOLUME):$(VOLUME_PATH) --name $(CONTAINER_NAME) -d $(IMAGE_NAME):$(IMAGE_TAG)
	docker ps | grep $(CONTAINER_NAME)
	@echo "jenkins now running on $(DOCKER_IP):8043"	

dockerbuild:
	docker build -t $(CONTAINER_NAME) . 

clean:
	rm -fv $(SSL_FILENAME).key $(SSL_FILENAME).crt
	echo "TODO: clean"


selfsignedcert:
	@test -f "$(SSL_FILENAME).key" || \
	openssl req \
          -new \
          -newkey rsa:$(SSL_KEY_SIZE) \
          -days $(SSL_CERT_DAYS) \
          -nodes \
          -x509 \
          -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=$(SSL_DOMAIN)" \
          -keyout "$(SSL_FILENAME).key" \
          -out "$(SSL_FILENAME).pem"



