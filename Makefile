
SSL_KEY_SIZE ?= 4096
SSL_CERT_DAYS ?= 365
SSL_DOMAIN ?= www.example.com
SSL_FILENAME ?= server


$(info SSL_KEY_SIZEL: $(SSL_KEY_SIZE))
$(info SSL_CERT_DAYS: $(SSL_CERT_DAYS))
$(info SSL_DOMAIN: $(SSL_DOMAIN))
$(info SSL_FILENAME: $(SSL_FILENAME))


all: clean selfsignedcert



clean:
	rm -fv $(SSL_FILENAME).key $(SSL_FILENAME).crt
	echo "TODO: clean"


selfsignedcert:
	openssl req \
          -new \
          -newkey rsa:$(SSL_KEY_SIZE) \
          -days $(SSL_CERT_DAYS) \
          -nodes \
          -x509 \
          -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=$(SSL_DOMAIN)" \
          -keyout "$(SSL_FILENAME).key" \
          -out "$(SSL_FILENAME).crt"



