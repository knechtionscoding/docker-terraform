#!/bin/sh

sts_role="$(aws sts assume-role --role-arn $AWS_ROLE_ARN --role-session-name $AWS_ROLE_SESSION_NAME)"

AWS_ACCESS_KEY_ID=$(echo $sts_role | jq -r .Credentials.AccessKeyId) \
AWS_SECRET_ACCESS_KEY=$(echo $sts_role | jq -r .Credentials.SecretAccessKey) \
AWS_SESSION_TOKEN=$(echo $sts_role | jq -r .Credentials.SessionToken) \
$*
