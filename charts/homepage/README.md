# Homepage Helm Chart

This Helm chart deploys [Homepage](https://gethomepage.dev/) - a highly customizable homepage (or startpage / application dashboard) with Docker and service API integrations.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `homepage`:

```bash
helm repo add moonlab https://moonlab-tech.github.io/moonlab-helm
helm install homepage moonlab/homepage
```

The command deploys Homepage on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `homepage` deployment:

```bash
helm delete homepage
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `nameOverride`            | String to partially override homepage.fullname | `""`  |
| `fullnameOverride`        | String to fully override homepage.fullname     | `""`  |

### Homepage Image parameters

| Name                | Description                                          | Value                            |
| ------------------- | ---------------------------------------------------- | -------------------------------- |
| `image.repository`  | Homepage image repository                            | `ghcr.io/gethomepage/homepage`   |
| `image.tag`         | Homepage image tag (immutable tags are recommended) | `latest`                         |
| `image.pullPolicy`  | Homepage image pull policy                           | `Always`                         |
| `imagePullSecrets`  | Homepage image pull secrets                          | `[]`                             |

### Homepage deployment parameters

| Name                                    | Description                                                                               | Value           |
| --------------------------------------- | ----------------------------------------------------------------------------------------- | --------------- |
| `replicaCount`                          | Number of Homepage replicas to deploy                                                     | `1`             |
| `strategy.type`                         | Homepage deployment strategy type                                                         | `RollingUpdate` |
| `revisionHistoryLimit`                  | The number of old ReplicaSets to retain                                                   | `3`             |
| `podAnnotations`                        | Annotations for Homepage pods                                                             | `{}`            |
| `podSecurityContext`                    | Set Homepage pod's Security Context                                                       | `{}`            |
| `securityContext`                       | Set Homepage container's Security Context                                                 | `{}`            |
| `resources`                             | Set Homepage container's resource requests and limits                                     | `{}`            |
| `nodeSelector`                          | Node labels for Homepage pods assignment                                                  | `{}`            |
| `tolerations`                           | Tolerations for Homepage pods assignment                                                  | `[]`            |
| `affinity`                              | Affinity for Homepage pods assignment                                                     | `{}`            |
| `dnsPolicy`                             | DNS Policy for pod                                                                        | `ClusterFirst`  |
| `enableServiceLinks`                    | Enable service links                                                                      | `true`          |
| `automountServiceAccountToken`          | Automount service account token for the server service account                           | `true`          |

### Homepage Service Account parameters

| Name                         | Description                                                            | Value  |
| ---------------------------- | ---------------------------------------------------------------------- | ------ |
| `serviceAccount.create`      | Specifies whether a ServiceAccount should be created                   | `true` |
| `serviceAccount.name`        | The name of the ServiceAccount to use                                  | `""`   |
| `serviceAccount.annotations` | Additional Service Account annotations (evaluated as a template)       | `{}`   |

### Homepage RBAC parameters

| Name                        | Description                                          | Value  |
| --------------------------- | ---------------------------------------------------- | ------ |
| `rbac.create`               | Specifies whether RBAC resources should be created  | `true` |
| `rbac.additionalRules`      | Additional RBAC rules to append to the default role | `[]`   |
| `rbac.existingClusterRole`  | Use existing ClusterRole instead of creating new one | `""`   |
| `rbac.existingClusterRoleBinding` | Use existing ClusterRoleBinding instead of creating new one | `""`   |

### Homepage Service parameters

| Name           | Description                        | Value       |
| -------------- | ---------------------------------- | ----------- |
| `service.type` | Homepage service type              | `ClusterIP` |
| `service.port` | Homepage service HTTP port         | `3000`      |

### Homepage Ingress parameters

| Name                       | Description                                                                   | Value                                    |
| -------------------------- | ----------------------------------------------------------------------------- | ---------------------------------------- |
| `ingress.enabled`          | Enable ingress record generation for Homepage                                 | `true`                                   |
| `ingress.className`        | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)| `""`                                     |
| `ingress.annotations`      | Additional annotations for the Ingress resource                               | `{}`                                     |
| `ingress.hosts`            | An array with hosts and paths                                                 | `[{"host": "homepage.my.network", "paths": [{"path": "/", "pathType": "Prefix"}]}]` |
| `ingress.tls`              | TLS configuration for Homepage ingress                                        | `[]`                                     |

### Homepage Configuration parameters

| Name                        | Description                                    | Value                    |
| --------------------------- | ---------------------------------------------- | ------------------------ |
| `config.existingConfigMap`  | Use existing ConfigMap instead of creating new one | `""`              |
| `config.kubernetes`         | Kubernetes configuration                       | See values.yaml          |
| `config.settings`           | Homepage settings configuration                | `""`                     |
| `config.customCss`          | Custom CSS for Homepage                        | `""`                     |
| `config.customJs`           | Custom JavaScript for Homepage                 | `""`                     |
| `config.bookmarks`          | Bookmarks configuration                        | See values.yaml          |
| `config.services`           | Services configuration                         | See values.yaml          |
| `config.widgets`            | Widgets configuration                          | See values.yaml          |
| `config.docker`             | Docker configuration                           | See values.yaml          |

### Homepage Environment Variables

| Name                        | Description                                    | Value                    |
| --------------------------- | ---------------------------------------------- | ------------------------ |
| `env.HOMEPAGE_ALLOWED_HOSTS`| Allowed hosts for Homepage                     | `gethomepage.dev`        |

### Homepage Persistence parameters

| Name                              | Description                                     | Value   |
| --------------------------------- | ----------------------------------------------- | ------- |
| `persistence.logs.enabled`        | Enable persistence for logs                    | `true`  |
| `persistence.logs.storageClass`   | PVC Storage Class for logs volume              | `""`    |
| `persistence.logs.accessMode`     | PVC Access Mode for logs volume                | `""`    |
| `persistence.logs.size`           | PVC Storage Request for logs volume            | `""`    |

### Homepage Autoscaling parameters

| Name                                            | Description                                                                                                          | Value   |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ------- |
| `autoscaling.enabled`                           | Enable Horizontal POD autoscaling for Homepage                                                                       | `false` |
| `autoscaling.minReplicas`                       | Minimum number of Homepage replicas                                                                                  | `1`     |
| `autoscaling.maxReplicas`                       | Maximum number of Homepage replicas                                                                                  | `100`   |
| `autoscaling.targetCPUUtilizationPercentage`    | Target CPU utilization percentage                                                                                    | `80`    |
| `autoscaling.targetMemoryUtilizationPercentage` | Target Memory utilization percentage                                                                                 | `""`    |

## Configuration and installation details

### Configuring Homepage

Homepage can be configured through the `config` section in values.yaml. The main configuration files are:

- `kubernetes.yaml`: Kubernetes integration settings
- `settings.yaml`: General Homepage settings
- `bookmarks.yaml`: Bookmark configuration
- `services.yaml`: Services to display on the homepage
- `widgets.yaml`: Widget configuration
- `docker.yaml`: Docker integration settings
- `custom.css`: Custom CSS styling
- `custom.js`: Custom JavaScript

### Example Configuration

Create a custom values file (e.g., `my-values.yaml`):

```yaml
config:
  settings: |
    providers:
      longhorn:
        url: https://longhorn.my.network
  
  services: |
    - Development:
        - GitHub:
            href: https://github.com
            description: Code repository
            icon: github.png
        - GitLab:
            href: https://gitlab.com
            description: DevOps platform
            icon: gitlab.png
```

Then install with custom values:

```bash
helm install homepage moonlab/homepage -f my-values.yaml
```

### Ingress Configuration

To configure ingress for Homepage:

```yaml
ingress:
  enabled: true
  className: "nginx"
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
  hosts:
    - host: homepage.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: homepage-tls
      hosts:
        - homepage.example.com
```

### Using Existing ConfigMaps

If you have an existing ConfigMap with Homepage configuration, you can use it instead of creating a new one:

```yaml
config:
  existingConfigMap: "my-homepage-config"
```

When using an existing ConfigMap, make sure it contains all the required keys:
- `kubernetes.yaml`
- `settings.yaml`
- `bookmarks.yaml`
- `services.yaml`
- `widgets.yaml`
- `docker.yaml`
- `custom.css`
- `custom.js`

Example of creating a ConfigMap manually:

```bash
kubectl create configmap my-homepage-config \
  --from-file=kubernetes.yaml \
  --from-file=settings.yaml \
  --from-file=bookmarks.yaml \
  --from-file=services.yaml \
  --from-file=widgets.yaml \
  --from-file=docker.yaml \
  --from-file=custom.css \
  --from-file=custom.js
```

### RBAC Configuration

The chart creates a ClusterRole with basic permissions for Homepage functionality. You can extend these permissions in several ways:

#### Adding Custom Permissions

To add additional permissions (e.g., for restarting deployments):

```yaml
rbac:
  additionalRules:
    - apiGroups: ["apps"]
      resources: ["deployments"]
      verbs: ["get", "list", "patch", "update"]
    - apiGroups: ["apps"]
      resources: ["deployments/restart"]
      verbs: ["patch"]
    - apiGroups: ["apps"]
      resources: ["replicasets"]
      verbs: ["get", "list"]
    - apiGroups: [""]
      resources: ["events"]
      verbs: ["get", "list", "watch"]
```

#### Using Existing RBAC Resources

If you have existing ClusterRole and ClusterRoleBinding:

```yaml
rbac:
  create: true
  existingClusterRole: "my-custom-cluster-role"
  existingClusterRoleBinding: "my-custom-cluster-role-binding"
```

#### Disabling RBAC

To disable RBAC entirely:

```yaml
rbac:
  create: false
```

### Persistence

By default, logs are stored in an emptyDir volume. To enable persistent storage:

```yaml
persistence:
  logs:
    enabled: true
    storageClass: "fast-ssd"
    accessMode: ReadWriteOnce
    size: 1Gi
```

## Upgrading

To upgrade the Homepage deployment:

```bash
helm repo update
helm upgrade homepage moonlab/homepage
```

## Troubleshooting

### Check pod status
```bash
kubectl get pods -l app.kubernetes.io/name=homepage
```

### Check logs
```bash
kubectl logs -l app.kubernetes.io/name=homepage
```

### Check service
```bash
kubectl get svc -l app.kubernetes.io/name=homepage
```
