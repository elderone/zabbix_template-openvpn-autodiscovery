#!/bin/bash

OPENVPN_CONF_DIR=$(echo $2 | grep -o "^/[^\s]+" || echo "/etc/openvpn")

for conf in ${OPENVPN_CONF_DIR}/*.conf; do
    if [[ $1 = CLIENT && $(grep -c ^remote ${conf}) > 0 ]]; then
	socket=$(grep management ${conf} | cut -d' ' -f2)
	name=$(basename ${conf} .conf)
	instances="$instances,"'{"{#'$1'}":"'${socket}'","{#'$1'_NAME}":"'${name}'"}'
    elif [[ $1 = SERVER && $(grep -c ^remote ${conf}) = 0 ]]; then
	socket=$(grep management ${conf} | cut -d' ' -f2)
	name=$(basename ${conf} .conf)
	instances="$instances,"'{"{#'$1'}":"'${socket}'","{#'$1'_NAME}":"'${name}'"}'
    fi
done

echo '{"data":['${instances#,}']}'
