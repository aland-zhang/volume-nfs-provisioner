#!/bin/sh -ax

nfs_ns="$1"
nfs_sts="$2"
nfs_pvc="$3"
nfs_pv="$4"
data_pvc="$5"
data_pv="$6"

exec 1>&2

envsubst < tmpl/nfs-sts.yaml | kubectl apply -f -

# wait for service endpoints to be ready
SECONDS=0
endpoints=
while [ -z "$endpoints" ] ; do
    endpoints="$( kubectl -n volume-nfs get ep "$nfs_sts" -o jsonpath='{.subsets[0].addresses[0].ip}' )"
    sleep 3
    [ "$SECONDS" -ge 60 ] && echo 'Cannot get endpoints, please check volume-nfs pod' && exit 0
done