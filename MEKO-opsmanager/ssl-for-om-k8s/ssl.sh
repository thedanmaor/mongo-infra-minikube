# #/bin/bash
# # Create the CA Config map for both mms and cluster
# kubectl create configmap ca --from-file="ca.pem" --from-file="mms-ca.pem"

# # config the TLS for the DB with the name (mongo-ssl-db) and the cert and key
# kubectl create secret tls mongo-ssl-db-cert --cert="servers.pem" --key="servers-key.pem"

# # redeploy the ssl version
# kubectl apply -f deploy-db-ssl.yaml

kubectl create secret tls my-replica-sample-cert --cert=certs/my-replica-sample.crt --key=certs/my-replica-sample.key

kubectl create secret tls my-replica-sample-agent-certs --cert=certs/my-replica-sample-agent.crt  --key=certs/my-replica-sample-agent.key

kubectl create configmap custom-ca --from-file=certs/ca-pem

echo "kubectl apply -f deploy-db-ssl.yaml"