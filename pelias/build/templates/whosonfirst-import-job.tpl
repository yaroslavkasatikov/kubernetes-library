apiVersion: batch/v1
kind: Job
metadata:
  name: pelias-whosonfirst-import
spec:
  template:
    metadata:
      name: pelias-whosonfirst-import
    spec:
      initContainers:
      - name: setup
        image: busybox
        command: ["/bin/sh","-c"]
        args: ["mkdir -p /data/whosonfirst && chown 1000:1000 /data/whosonfirst"]
        volumeMounts:
          - name: data-volume
            mountPath: /data
      - name: download
        image: pelias/whosonfirst:{{ .Values.whosonfirstDockerTag | default "latest" }}
        command: ["./bin/download"]
        volumeMounts:
          - name: config-volume
            mountPath: /etc/config
          - name: data-volume
            mountPath: /data
        env:
          - name: PELIAS_CONFIG
            value: "/etc/config/pelias.json"
        resources:
          limits:
            memory: 3Gi
            cpu: 4
          requests:
            memory: 512Mi
            cpu: 1.5
      containers:
      - name: pelias-whosonfirst-import-container
        image: pelias/whosonfirst:{{ .Values.whosonfirstDockerTag | default "latest" }}
        command: ["./bin/start"]
        volumeMounts:
          - name: config-volume
            mountPath: /etc/config
          - name: data-volume
            mountPath: /data
        env:
          - name: PELIAS_CONFIG
            value: "/etc/config/pelias.json"
        resources:
          limits:
            memory: 3Gi
            cpu: 1.5
          requests:
            memory: 2Gi
            cpu: 1
      restartPolicy: OnFailure
      volumes:
        - name: config-volume
          configMap:
            name: pelias-json-configmap
            items:
              - key: pelias.json
                path: pelias.json
        - name: data-volume
          emptyDir: {}
