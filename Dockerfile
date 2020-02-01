FROM limina/nginx-ldap

# Install envsubst
ENV BUILD_DEPS="gettext"  \
    RUNTIME_DEPS="libintl"
RUN set -x && \
    apk add --update $RUNTIME_DEPS && \
    apk add --virtual build_deps $BUILD_DEPS &&  \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del build_deps

# Nginx Conf
RUN rm -rf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf.template
COPY default-kibana.conf /etc/nginx/conf.d/default-kibana.conf.template
COPY default-grafana.conf /etc/nginx/conf.d/default-grafana.conf.template
COPY default-alertmanager.conf /etc/nginx/conf.d/default-alertmanager.conf.template
COPY default-prometheus.conf /etc/nginx/conf.d/default-prometheus.conf.template
COPY root-dir/ /etc/nginx/root-dir

# Script entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
