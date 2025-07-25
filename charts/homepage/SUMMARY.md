# Homepage Helm Chart - Summary

## Overview
This Helm chart was generated from the official Homepage Kubernetes manifests available at https://gethomepage.dev/installation/k8s/. It provides a complete, production-ready deployment of Homepage with all necessary Kubernetes resources.

## Chart Structure
```
homepage-helm-chart/
├── Chart.yaml                          # Chart metadata
├── values.yaml                         # Default configuration values
├── README.md                          # Comprehensive documentation
├── install.sh                         # Installation script
├── SUMMARY.md                         # This summary
└── templates/
    ├── _helpers.tpl                   # Template helpers
    ├── NOTES.txt                      # Post-installation notes
    ├── serviceaccount.yaml            # Service Account
    ├── secret.yaml                    # Service Account Token Secret
    ├── configmap.yaml                 # Configuration files
    ├── clusterrole.yaml               # RBAC ClusterRole
    ├── clusterrolebinding.yaml        # RBAC ClusterRoleBinding
    ├── service.yaml                   # Kubernetes Service
    ├── deployment.yaml                # Main Deployment
    ├── ingress.yaml                   # Ingress resource
    ├── pvc.yaml                       # PersistentVolumeClaim for logs
    └── hpa.yaml                       # HorizontalPodAutoscaler
```

## Key Features
- ✅ **Complete Resource Coverage**: All original K8s manifests converted to Helm templates
- ✅ **Configurable Values**: Extensive values.yaml with sensible defaults
- ✅ **RBAC Support**: Full RBAC configuration for Kubernetes integration
- ✅ **Ingress Ready**: Pre-configured ingress with Homepage annotations
- ✅ **Persistence**: Optional persistent storage for logs
- ✅ **Autoscaling**: HPA support for production deployments
- ✅ **Security**: Service account with minimal required permissions
- ✅ **Validation**: Passes `helm lint` and `helm template` validation

## Resources Created
1. **ServiceAccount**: `homepage` - For Kubernetes API access
2. **Secret**: Service account token for authentication
3. **ConfigMap**: Contains all Homepage configuration files
4. **ClusterRole**: Minimal permissions for K8s resource discovery
5. **ClusterRoleBinding**: Binds the role to the service account
6. **Service**: ClusterIP service exposing port 3000
7. **Deployment**: Main Homepage application deployment
8. **Ingress**: HTTP ingress with Homepage-specific annotations
9. **PersistentVolumeClaim**: Optional persistent storage for logs
10. **HorizontalPodAutoscaler**: Optional autoscaling configuration

## Configuration Files Included
- `kubernetes.yaml`: Kubernetes integration settings
- `settings.yaml`: General Homepage settings (customizable)
- `bookmarks.yaml`: Bookmark configuration with GitHub example
- `services.yaml`: Service definitions with sample services
- `widgets.yaml`: Widget configuration (Kubernetes, resources, search)
- `docker.yaml`: Docker integration settings
- `custom.css`: Custom CSS styling
- `custom.js`: Custom JavaScript

## Installation Methods

### Method 1: Basic installation
```bash
helm repo add moonlab https://moonlab-tech.github.io/moonlab-helm
helm install homepage moonlab/homepage
```

### Method 2: With custom values
```bash
helm repo add moonlab https://moonlab-tech.github.io/moonlab-helm
helm install homepage moonlab/homepage -f my-values.yaml
```

### Method 3: With specific namespace
```bash
helm repo add moonlab https://moonlab-tech.github.io/moonlab-helm
helm install homepage moonlab/homepage --namespace my-namespace --create-namespace
```

## Customization
The chart is highly customizable through the `values.yaml` file. Key customization areas:
- Image repository and tag
- Resource limits and requests
- Ingress configuration and TLS
- Homepage configuration files
- Persistence settings
- RBAC permissions
- Environment variables

## Validation Status
- ✅ `helm lint .` - Passed (1 chart linted, 0 failed)
- ✅ `helm template .` - Generates valid Kubernetes manifests
- ✅ All original manifest features preserved
- ✅ Helm best practices followed

## Original Source
Based on the official Homepage Kubernetes manifests from:
https://gethomepage.dev/installation/k8s/

## Next Steps
1. Add the MoonLab Helm repository: `helm repo add moonlab https://moonlab-tech.github.io/moonlab-helm`
2. Run `helm install homepage moonlab/homepage --dry-run` to preview changes
3. Deploy with `helm install homepage moonlab/homepage`
4. Access Homepage via ingress or port-forward
5. Customize configuration through values files or ConfigMaps

The chart is ready for production use and follows Helm best practices for maintainability and upgradability.
