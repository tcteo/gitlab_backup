docker run -it --rm \
-e GITLAB_USER="tcteo" \
-e GITLAB_TOKEN="$(cat access_token.txt)" \
-v $(pwd)/tmp:/data \
gitlab_backup:latest /data/sync

#--mount type=bind,source=$(pwd)/access_token.txt,target=/access_token.txt gitlab_backup:latest \
