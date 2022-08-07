# Gitlab backup script

A script that mirrors Gitlab repositories that a user is a member of.

Basic docker usage:

```
docker run -it --rm \
-e GITLAB_USER="YourGitlabUsername" \
-e GITLAB_TOKEN="YourGitlabAccessToken" \
-v /path/to/backup/destination:/data \
ghcr.io/tcteo/gitlab_backup:release /data
```

Kubernetes yaml fragment:

```
        spec:
          containers:
          - name: gitlab-backup
            image: ghcr.io/tcteo/gitlab_backup:release
            imagePullPolicy: IfNotPresent
            args:
            - /data
            env:
              - name: GITLAB_USER
                value: YourGitlabUsername
              - name: GITLAB_TOKEN
                valueFrom:
                  secretKeyRef:
                    name: gitlab-read-token
                    key: password
                    optional: false
                # Where the secret might have been created with:
                #     kubectl -n some-namespace create secret generic \
                #     gitlab-read-token --from-literal=password=YourGitlabAccessToken
            volumeMounts:
            - name: data-vol
              mountPath: "/data"
            resources:
              [...]
          volumes:
          - name: data-vol
            persistentVolumeClaim: # PVC to write data to.
              claimName: data-vol
```

