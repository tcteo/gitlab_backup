docker run -it --rm \
-e GITLAB_TOKEN="$(cat access_token.txt)" \
gitlab_backup:latest

#--mount type=bind,source=$(pwd)/access_token.txt,target=/access_token.txt gitlab_backup:latest \
