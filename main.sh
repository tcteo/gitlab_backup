#!/bin/bash

# - List projects I'm a member of
# - Use jq to convert it to a tab separated format
# - Call a function for each repo

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
    echo "namespace=${namespace} repo=${repo} sshurl=${sshurl} httpurl=${httpurl}"
  done
)