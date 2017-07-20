#!/bin/bash

target="$1"
secdir="${2:-../cloudfoundry/secure}"
secfile="concourse-secrets.yml.gpg"
secrets="${secdir}/${secfile}"

# EV 'PP' = prefix to pipeline name for local customization of test
#           pipelines

if [ ! -f "${secrets}" ]
then
    echo -e 1>&2 "$0: Failed to find the secrets file ${secrets}\n\tPlease specify the correct directory holding \"${secfile}\"."
    exit 1
fi

fly -t "$target" set-pipeline -p ${PP}uaa-kube-dist -c uaa-kube-dist/uaa-kube-dist.yml \
    -v s3-bucket=cf-opensusefs2 \
    -l <(gpg -d --no-tty "${secrets}" 2> /dev/null)

fly -t "$target" expose-pipeline -p ${PP}uaa-kube-dist
fly -t "$target" unpause-pipeline -p ${PP}uaa-kube-dist