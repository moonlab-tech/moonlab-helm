# Helm Charts

This directory contains Helm charts for various applications.

## Available Charts

- **homepage**: A highly customizable homepage (or startpage / application dashboard) with Docker and service API integrations

## Adding New Charts

To add a new Helm chart:

1. Create a new directory in `charts/` with your chart name
2. Initialize the chart structure:
   ```bash
   helm create charts/your-app-name
   ```
3. Update the `Chart.yaml` with proper metadata
4. Add your chart configuration to `values.yaml`

## Installation

Add this repository:
```bash
helm repo add moonlab https://moonlab-tech.github.io/moonlab-helm
helm repo update
```

Install a chart:
```bash
helm install my-release moonlab/homepage
``` 