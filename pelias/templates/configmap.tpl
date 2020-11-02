 
apiVersion: v1
kind: ConfigMap
metadata:
  name: pelias-json-configmap
data:
  pelias.json: |
    {
      "esclient": {
        "hosts": [{
          "host": {{ .Values.elasticsearch.host | quote}},
          "port": {{ .Values.elasticsearch.port }},
          "protocol": {{ .Values.elasticsearch.protocol | quote }}
          {{- if .Values.elasticsearch.auth }}
          ,"auth": "{{ .Values.elasticsearch.auth }}"
          {{- end }}
        }]
      },
      "elasticsearch": {
        "settings": {
          "index": {
            "number_of_replicas": "0",
            "number_of_shards": "12",
            "refresh_interval": "1m"
          }
        }
      },
      "api": {
        "accessLog": "{{ .Values.api.accessLog }}",
        "autocomplete": {
          "exclude_address_length": {{ .Values.api.autocomplete.exclude_address_length }}
        },
        "attributionURL": "{{ .Values.api.attributionURL }}",
        "indexName": "{{ .Values.api.indexName }}",
        {{ if (.Values.api.targets.auto_discover) and ( or (eq .Values.api.targets.auto_discover true) ( eq .Values.api.targets.auto_discover false ) ) }}
        "targets": {
          "auto_discover": {{ .Values.api.targets.auto_discover }}
        },
        "exposeInternalDebugTools": {{ .Values.api.exposeInternalDebugTools }},
        {{- end }}
        "services": {
          {{ if .Values.placeholder.enabled  }}
          "placeholder": {
            "url": "{{ .Values.placeholder.host }}",
            "retries": {{ .Values.placeholder.retries }},
            "timeout": {{ .Values.placeholder.timeout }}
          },
          {{- end }}
          {{- if .Values.interpolation.enabled }}
          "interpolation": {
            "url": "{{ .Values.interpolation.host }}",
            "retries": {{ .Values.interpolation.retries }},
            "timeout": {{ .Values.interpolation.timeout }}
          },
          {{- end }}
          {{- if .Values.pip.enabled }}
          "pip": {
            "url": "{{ .Values.pip.host }}",
            "retries": {{ .Values.pip.retries }},
            "timeout": {{ .Values.pip.timeout }}
          },
          {{- end }}
          "libpostal": {
            "url": "{{ .Values.libpostal.host }}",
            "retries": {{ .Values.libpostal.retries }},
            "timeout": {{ .Values.libpostal.timeout }}
          }
        }
      },
      "acceptance-tests": {
        "endpoints": {
          "local": "http://pelias-api-service:3100/v1/"
        }
      },
      "logger": {
        "level": "info",
        "json": true,
        "timestamp": true
      },
      "imports": {
        "adminLookup": {
            "enabled": true,
            "maxConcurrentReqs": 20
        },
        "services": {
          "pip": {
            "url": "http://pelias-pip-service:3102",
            "timeout": 5000
          }
        },
        "geonames": {
          "datapath": "/data/geonames",
          "countryCode": "{{ .Values.imports.geonames.countrycode }}" 
        },
        "openaddresses": {
          "datapath": "/data/openaddresses",
          "files": [] 
        },
        "openstreetmap": {
          "download": [{
              "sourceURL": "{{ .Values.imports.openstreetmap.url }}" 
          }],
          "datapath": "/data/openstreetmap",
          "import": [{
            "filename": "{{ .Values.imports.openstreetmap.filename }}"
          }]
        },
        "polyline": {
          "datapath": "/data/polylines",
          "files": ["extract.0sv"]
        },
        "whosonfirst": {
          "sqlite": {{ .Values.whosonfirst.sqlite }},
          {{ if .Values.whosonfirst.dataHost }}
          "dataHost": "{{ .Values.whosonfirst.dataHost}}",
          {{ end }}
          "importPostalcodes": true,
          "datapath": "/data/whosonfirst",
          "countryCode": "{{ .Values.imports.whosonfirst.countrycode }}"
        }
      }
    }
