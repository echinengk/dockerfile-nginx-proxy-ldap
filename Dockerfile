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
COPY conf/nginx.conf /etc/nginx/nginx.conf.template
COPY conf/default-kibana.conf /etc/nginx/conf.d/default-kibana.conf.template
COPY conf/default-grafana.conf /etc/nginx/conf.d/default-grafana.conf.template
COPY conf/default-alertmanager.conf /etc/nginx/conf.d/default-alertmanager.conf.template
COPY conf/default-prometheus.conf /etc/nginx/conf.d/default-prometheus.conf.template
COPY conf/root-dir/ /etc/nginx/root-dir

# Script entrypoint
COPY bin/docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
