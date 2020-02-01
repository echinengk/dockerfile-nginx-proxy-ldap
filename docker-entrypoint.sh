#!/usr/bin/env sh
set -eu

envsubst '${LDAP_URL} ${LDAP_BIND_DN} ${LDAP_BIND_PASSWORD} ${LDAP_GROUP}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

if [[ ${UPSTREAM_TYPE} = "kibana" ]]
then
    envsubst '${LDAP_MESSAGE} ${UPSTREAM_URL}' < /etc/nginx/conf.d/default-kibana.conf.template > /etc/nginx/conf.d/default.conf
fi
if [[ ${UPSTREAM_TYPE} = "grafana" ]]
then
    envsubst '${LDAP_MESSAGE} ${UPSTREAM_URL}' < /etc/nginx/conf.d/default-grafana.conf.template > /etc/nginx/conf.d/default.conf
fi
if [[ ${UPSTREAM_TYPE} = "alertmanager" ]]
then
    envsubst '${LDAP_MESSAGE} ${UPSTREAM_URL}' < /etc/nginx/conf.d/default-alertmanager.conf.template > /etc/nginx/conf.d/default.conf
fi
if [[ ${UPSTREAM_TYPE} = "prometheus" ]]
then
    envsubst '${LDAP_MESSAGE} ${UPSTREAM_URL}' < /etc/nginx/conf.d/default-prometheus.conf.template > /etc/nginx/conf.d/default.conf
fi

exec "$@"
