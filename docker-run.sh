docker run -it --rm \
-e GITLAB_USER="tcteo" \
-e GITLAB_TOKEN="$(cat access_token.txt)" \
-v $(pwd)/tmp:/data \
gitlab_backup:latest /data/sync
