#!/bin/bash
set -e

# - List projects the token owner is a member of
# - Use jq to convert it to a tab separated format
# - Back up each repo to dst_base specified in $1

if [ -z "${1}" ]; then
  echo 'no dst dir'
  exit 1
fi
dst_base="${1}"

if [ -z "${GITLAB_USER}" ]; then
  echo 'no gitlab username'
  exit 1
fi
if [ -z "${GITLAB_TOKEN}" ]; then
  echo 'no gitlab token'
  exit 1
fi

do_backup () {
  namespace="${1}"
  repo="${2}"
  sshurl="${3}"
  httpurl="${4}"

  echo "do_backup: namespace=${namespace} repo=${repo} sshurl=${sshurl} httpurl=${httpurl}"
  dst="${dst_base}/${namespace}/${repo}"
  echo "dst: ${dst}"

  httpurl_auth="$( echo "${httpurl}" | sed -e "s/https:\/\//https:\/\/${GITLAB_USER}:${GITLAB_TOKEN}@/g" )"

  wd="$(pwd)"
  if [ ! -d "${dst}" ]; then
    mkdir -p "${dst}"
    echo "cloning..."
    git clone --mirror "${httpurl_auth}" "${dst}"
  else
    cd "${dst}"
    echo "fetching..."
    git fetch "${httpurl_auth}" || (
      echo "fetch failed, deleting and cloning...";
      rm -rf "${dst}"
      git clone --mirror "${httpurl_auth}" "${dst}"
    )
    cd "${wd}"
  fi
  
  echo '----------------------------'
}

glab api graphql -f query='
query {
  projects(membership:true) {
    nodes {
      namespace {
        id
        fullPath
        actualRepositorySizeLimit
        additionalPurchasedStorageSize
        storageSizeLimit
        totalRepositorySize
      }
      id
      path
      sshUrlToRepo
      httpUrlToRepo
    }
  }
}
' \
| jq -r '
.["data"]["projects"]["nodes"] 
| map([
  .["namespace"]["fullPath"],
  .["path"],
  .["sshUrlToRepo"],
  .["httpUrlToRepo"]
])
| map(. | join("\t"))
| join("\n")
' \
| (
  while read -r namespace repo sshurl httpurl; do
    do_backup "${namespace}" "${repo}" "${sshurl}" "${httpurl}"
  done
)
