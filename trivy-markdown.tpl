### Secret Scanning Analysis Results

{{- if . }}
| Severity | Description | Evidence | Location |
|:---:|:---|:---|:---|
{{- range . }}
{{- range .Secrets }}
| {{ .Severity }} | {{ .Title }} | `{{ .Match }}` | {{ .StartLine }} |
{{- end }}
{{- end }}
{{- else }}
No secrets found.
{{- end }}
