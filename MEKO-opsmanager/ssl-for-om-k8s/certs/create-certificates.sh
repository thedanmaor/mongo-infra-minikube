#!/bin/bash
# Cleanup old certs
rm -rf *.pem; rm -rf *.crt; rm -rf *.csr; rm -rf *.key; rm -rf ca-pem; rm -rf *.srl

# 1 generate root CA
openssl genrsa -out custom-ca.key 4096

# Generate cert
openssl req -x509 -extensions ext -new -key custom-ca.key -days 800 -out custom-ca.crt -config conf/ca-openssl.cnf

# unify inta ca-pem
cat custom-ca.crt custom-ca.key > ca-pem

# 2 Prepare the MongoDB server certificate key
openssl genrsa -out my-replica-sample.key 4096

# Generate CSR and crt
openssl req -new -sha256 -key my-replica-sample.key -out my-replica-sample.csr -config conf/mdb-openssl.cnf

openssl x509 -req -CA custom-ca.crt -CAkey custom-ca.key -CAcreateserial -in my-replica-sample.csr -out my-replica-sample.crt -days 800 -extfile conf/mdb-openssl.cnf -extensions server_cert

# 3 Generate Agent Certs key
openssl genrsa -out my-replica-sample-agent.key 4096

# Generate the CSR and the certificate
openssl req -new -sha256 -key my-replica-sample-agent.key -out my-replica-sample-agent.csr -config conf/agent-openssl.cnf
openssl x509 -req -CA custom-ca.crt -CAkey custom-ca.key -CAcreateserial -in my-replica-sample-agent.csr -out my-replica-sample-agent.crt -days 800 -extfile conf/agent-openssl.cnf -extensions client_cert

# verify the ca cert
# openssl verify -CAfile custom-ca.crt custom-ca.crt
# openssl x509 -noout -text -in custom-ca.crt

# verify the replica certs
# openssl verify -CAfile custom-ca.crt my-replica-sample.crt
# openssl x509 -noout -text -in my-replica-sample.crt

# review the agent cert
# openssl x509 -noout -text -in my-replica-sample-agent.crt