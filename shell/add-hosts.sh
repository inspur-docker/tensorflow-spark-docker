#!/bin/bash

#问题：当容器重启之后ip可能会变化，但是/etc/hosts.origin中会纪录之前host的IP，会与当前host ip不同，产生冲突.
if [ ! -f /etc/hosts.origin ]; then
    echo "Backup origin hosts file."
    cp /etc/hosts /etc/hosts.origin
fi
cat /etc/hosts.origin  "$@" > /etc/hosts