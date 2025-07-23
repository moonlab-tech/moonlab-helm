#!/bin/bash

# Homepage Helm Chart Installation Script

set -e

# Default values
RELEASE_NAME="homepage"
NAMESPACE="default"
VALUES_FILE=""
DRY_RUN=false
UPGRADE=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Install Homepage using Helm chart

OPTIONS:
    -n, --namespace NAMESPACE    Kubernetes namespace (default: default)
    -r, --release RELEASE        Helm release name (default: homepage)
    -f, --values VALUES_FILE     Custom values file
    -d, --dry-run               Perform a dry run
    -u, --upgrade               Upgrade existing installation
    -h, --help                  Show this help message

EXAMPLES:
    # Install with default values
    $0

    # Install in custom namespace
    $0 -n homepage-system

    # Install with custom values
    $0 -f my-values.yaml

    # Dry run installation
    $0 --dry-run

    # Upgrade existing installation
    $0 --upgrade
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--namespace)
            NAMESPACE="$2"
            shift 2
            ;;
        -r|--release)
            RELEASE_NAME="$2"
            shift 2
            ;;
        -f|--values)
            VALUES_FILE="$2"
            shift 2
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -u|--upgrade)
            UPGRADE=true
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Check if helm is installed
if ! command -v helm &> /dev/null; then
    print_error "Helm is not installed. Please install Helm first."
    exit 1
fi

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    print_error "kubectl is not installed. Please install kubectl first."
    exit 1
fi

# Check if we can connect to Kubernetes cluster
if ! kubectl cluster-info &> /dev/null; then
    print_error "Cannot connect to Kubernetes cluster. Please check your kubeconfig."
    exit 1
fi

print_status "Starting Homepage installation..."
print_status "Release name: $RELEASE_NAME"
print_status "Namespace: $NAMESPACE"

# Create namespace if it doesn't exist
if ! kubectl get namespace "$NAMESPACE" &> /dev/null; then
    print_status "Creating namespace: $NAMESPACE"
    kubectl create namespace "$NAMESPACE"
fi

# Build helm command
HELM_CMD="helm"
if [ "$UPGRADE" = true ]; then
    HELM_CMD="$HELM_CMD upgrade --install"
else
    HELM_CMD="$HELM_CMD install"
fi

HELM_CMD="$HELM_CMD $RELEASE_NAME ."
HELM_CMD="$HELM_CMD --namespace $NAMESPACE"

if [ "$DRY_RUN" = true ]; then
    HELM_CMD="$HELM_CMD --dry-run"
fi

if [ -n "$VALUES_FILE" ]; then
    if [ ! -f "$VALUES_FILE" ]; then
        print_error "Values file not found: $VALUES_FILE"
        exit 1
    fi
    HELM_CMD="$HELM_CMD --values $VALUES_FILE"
fi

# Execute helm command
print_status "Executing: $HELM_CMD"
eval $HELM_CMD

if [ "$DRY_RUN" = false ]; then
    print_status "Homepage installation completed!"
    
    # Wait for deployment to be ready
    print_status "Waiting for deployment to be ready..."
    kubectl wait --for=condition=available --timeout=300s deployment/$RELEASE_NAME -n $NAMESPACE
    
    print_status "Deployment is ready!"
    
    # Show access information
    echo ""
    print_status "Access Information:"
    echo "===================="
    
    # Check if ingress is enabled
    if kubectl get ingress $RELEASE_NAME -n $NAMESPACE &> /dev/null; then
        INGRESS_HOST=$(kubectl get ingress $RELEASE_NAME -n $NAMESPACE -o jsonpath='{.spec.rules[0].host}')
        echo "Ingress URL: http://$INGRESS_HOST"
    fi
    
    echo "Port-forward command: kubectl port-forward svc/$RELEASE_NAME 8080:3000 -n $NAMESPACE"
    echo "Then access: http://localhost:8080"
    
    echo ""
    print_status "Useful commands:"
    echo "=================="
    echo "Check pods: kubectl get pods -l app.kubernetes.io/name=homepage -n $NAMESPACE"
    echo "Check logs: kubectl logs -l app.kubernetes.io/name=homepage -n $NAMESPACE"
    echo "Edit config: kubectl edit configmap $RELEASE_NAME -n $NAMESPACE"
    echo "Uninstall: helm uninstall $RELEASE_NAME -n $NAMESPACE"
else
    print_status "Dry run completed successfully!"
fi
