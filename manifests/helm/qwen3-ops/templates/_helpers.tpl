{{/*
Expand the name of the chart.
*/}}
{{- define "model-ops.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "model-ops-deploy.fullname" -}}
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

{{- define "mychart.sanitizeName" -}}
{{- $name := . | trimAll "." | trimAll "-" | lower -}}
{{- $name = regexReplaceAll `[^\-\.a-z0-9]+` $name "-" -}}
{{- $name = replace "." "-" $name -}}
{{- $name = regexReplaceAll `^[\-\.]+|[\-\.]+$` $name "" -}}
{{- $name = substr 0 63 $name -}}
{{- if empty $name }}default-name{{ else }}{{ $name }}{{ end -}}
{{- end -}}

{{- define "model-ops-model.fullname" -}}
{{- $tag := .Values.image.model.tag }}
{{- $rawName := printf "%s-%s" .Release.Name $tag -}}
{{ include "mychart.sanitizeName" $rawName }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "model-ops.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "model-ops.labels" -}}
helm.sh/chart: {{ include "model-ops.chart" . }}
{{ include "model-ops.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "model-ops.selectorLabels" -}}
app.kubernetes.io/name: {{ include "model-ops.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "model-ops.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "qmodel-ops.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
