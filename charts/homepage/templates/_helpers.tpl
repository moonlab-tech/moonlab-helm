{{/*
Expand the name of the chart.
*/}}
{{- define "homepage.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "homepage.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "homepage.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "homepage.labels" -}}
helm.sh/chart: {{ include "homepage.chart" . }}
{{ include "homepage.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "homepage.selectorLabels" -}}
app.kubernetes.io/name: {{ include "homepage.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "homepage.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "homepage.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the name of the ConfigMap to use
*/}}
{{- define "homepage.configMapName" -}}
{{- if .Values.config.existingConfigMap }}
{{- .Values.config.existingConfigMap }}
{{- else }}
{{- include "homepage.fullname" . }}
{{- end }}
{{- end }}

{{/*
Get the ConfigMap name for a specific config file
Usage: {{ include "homepage.configMapNameForFile" (dict "context" . "file" "kubernetes") }}
*/}}
{{- define "homepage.configMapNameForFile" -}}
{{- $file := .file -}}
{{- $context := .context -}}
{{- if index $context.Values.config.existingConfigMaps $file }}
{{- index $context.Values.config.existingConfigMaps $file }}
{{- else if $context.Values.config.existingConfigMap }}
{{- $context.Values.config.existingConfigMap }}
{{- else }}
{{- include "homepage.fullname" $context }}
{{- end }}
{{- end }}

{{/*
Check if we should create the main ConfigMap
Returns true if no existing ConfigMaps are specified
*/}}
{{- define "homepage.shouldCreateConfigMap" -}}
{{- $hasExistingConfigMap := .Values.config.existingConfigMap -}}
{{- $hasAnyExistingConfigMaps := false -}}
{{- range $key, $value := .Values.config.existingConfigMaps -}}
{{- if $value -}}
{{- $hasAnyExistingConfigMaps = true -}}
{{- end -}}
{{- end -}}
{{- if or $hasExistingConfigMap $hasAnyExistingConfigMaps -}}
false
{{- else -}}
true
{{- end -}}
{{- end }}
