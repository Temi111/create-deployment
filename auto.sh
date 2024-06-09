#!/bin/bash

# Variables
BRANCH_NAME=$1
NAMESPACE=${BRANCH_NAME//\//-}  # Replace '/' with '-' to make it a valid namespace name
HELM_RELEASE_NAME=$NAMESPACE
CHART_PATH="./helm"  # Ensure this path points to the directory containing your Chart.yaml
INGRESS_TEMPLATE_PATH="helm/ingress-template.yaml"  # Ensure this path points to your ingress template

# Check if Namespace Exists
if kubectl get namespace $NAMESPACE; then
  echo "Namespace $NAMESPACE already exists"
else
  # Create Namespace
  kubectl create namespace $NAMESPACE
fi

# Deploy Application using Helm
helm install $HELM_RELEASE_NAME $CHART_PATH --namespace $NAMESPACE

# Apply Ingress Configuration
INGRESS_FILE="./generated-ingress.yaml"
cp $INGRESS_TEMPLATE_PATH $INGRESS_FILE
sed -i '' "s/{{NAMESPACE}}/$NAMESPACE/g" $INGRESS_FILE  # Adjusted for correct sed syntax
kubectl apply -f $INGRESS_FILE --namespace $NAMESPACE

echo "Deployment completed for branch: $BRANCH_NAME"
