#! /bin/bash

vault login -method=github token=$VAULT_GITHUB_TOKEN

generate Production
generate Staging

base64_ios_fastlane_authkey=$(vault kv get -field=value secret/production/base64_ios_fastlane_authkey)
filename=AuthKey.p8
echo "$base64_ios_fastlane_authkey" | base64 --decode > "$filename"
echo Generated "$filename"