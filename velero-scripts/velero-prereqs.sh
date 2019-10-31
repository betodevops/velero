# Configuring Velero namespace, RBAC and CRDs by applying the Kubernetes prerequisites YAML

export VELERO_FOLDER=/opt/velero
export VELERO_VERSION=v1.1.0

wget https://github.com/heptio/velero/releases/download/$VELERO_VERSION/velero-$VELERO_VERSION-linux-amd64.tar.gz
sudo mkdir -p $VELERO_FOLDER
sudo tar -xzvf velero-$VELERO_VERSION-linux-amd64.tar.gz -C $VELERO_FOLDER
sudo mv $VELERO_FOLDER/velero-$VELERO_VERSION-linux-amd64/velero /usr/bin
sudo chmod +x /usr/bin/velero
