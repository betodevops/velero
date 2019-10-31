# Deploying Velero for a Kubernetes cluster hosted in AWS
# For in depth details, check https://heptio.github.io/velero/master/aws-config.html

export VELERO_FOLDER=/opt/velero/
export BUCKET_NAME=k8s-cluster-velero # Use a different name
export CLOUD_REGION=us-east-1


kubectl create secret generic cloud-credentials \
    --namespace velero \
    --from-file cloud=$VELERO_FOLDER/credentials-velero

# https://velero.io/docs/v1.1.0/aws-config/
velero install     --provider aws     --bucket geru-k8s-cluster-velero     --secret-file ./credentials-velero     --backup-location-config region=us-east-1     --snapshot-location-config region=us-east-1
