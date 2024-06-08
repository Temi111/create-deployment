#!/bin/bash

# Variables
NAMESPACE= "test"
RELEASE_NAME="temitope"
HELM_CHART_PATH= "helm"
DOCKER_REPO= "temi111/your-flask-app"
DOCKER_TAG= latest

# Check if all arguments are provided
if [ "$#" -ne 5 ]; then
  echo "Usage: $0 <namespace> <release_name> <helm_chart_path> <docker_repo> <docker_tag>"
  exit 1
fi

# Create a new namespace
echo "Creating namespace $NAMESPACE..."
kubectl create namespace $NAMESPACE

# Update the image repository and tag in the values.yaml file
sed -i "s|repository: .*|repository: \"$DOCKER_REPO\"|g" $HELM_CHART_PATH/values.yaml
sed -i "s|tag: .*|tag: \"$DOCKER_TAG\"|g" $HELM_CHART_PATH/values.yaml

# Deploy the Helm chart to the new namespace
echo "Deploying Helm chart to namespace $NAMESPACE..."
helm install $RELEASE_NAME $HELM_CHART_PATH --namespace $NAMESPACE

# Check the deployment status
if [ $? -eq 0 ]; then
  echo "Deployment successful!"
else
  echo "Deployment failed!"
fi
