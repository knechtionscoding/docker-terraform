# build step to create a Terraform bundle per our included terraform-bundle.hcl
FROM golang:alpine AS bundler

RUN apk --no-cache add git unzip && \
    go get -d -v github.com/hashicorp/terraform && \
    git -C ./src/github.com/hashicorp/terraform checkout v0.11.11 && \
    go install ./src/github.com/hashicorp/terraform/tools/terraform-bundle

COPY terraform-bundle.hcl .

RUN terraform-bundle package -os=linux -arch=amd64 terraform-bundle.hcl && \
    mkdir -p terraform-bundle && \
    unzip -d terraform-bundle terraform_*.zip

# create container to use for our jenkins build steps
FROM alpine:3.8

ENV HTTP_PROXY $HTTP_PROXY
ENV HTTPS_PROXY $HTTPS_PROXY
ENV NO_PROXY $NO_PROXY
ENV TF_SKIP_PROVIDER_VERIFY 1

RUN apk --no-cache --update \
        add curl python3 zip jq git openssl && \
    python3 -m ensurepip && \
    pip3 install --upgrade pip awscli pyyaml && \
    rm -r /root/.cache

COPY assume.sh /usr/local/bin/assume.sh
RUN chmod 0755 /usr/local/bin/assume.sh

COPY --from=bundler /go/terraform-bundle/* /usr/local/bin/
