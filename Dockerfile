FROM jenkins:latest

COPY server.pem /var/lib/jenkins/cert
COPY server.key /var/lib/jenkins/pk
ENV JENKINS_OPTS --httpPort=-1 --httpsPort=8083 --httpsCertificate=/var/lib/jenkins/cert --httpsPrivateKey=/var/lib/jenkins/pk
EXPOSE 8083
EXPOSE 50000

