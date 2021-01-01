FROM openjdk:11-ea-13-jre

ENV KEYCLOAK_VERSION=12.0.0
ARG POSTGRESQL_JDBC_JAR=postgresql-42.2.11.jar

RUN wget -q -O- https://downloads.jboss.org/keycloak/${KEYCLOAK_VERSION}/keycloak-${KEYCLOAK_VERSION}.tar.gz | tar zxf - &&\
    mv keycloak-${KEYCLOAK_VERSION} keycloak

RUN mkdir -p keycloak/standalone/data && chmod 0777 keycloak/standalone/data
RUN mkdir -p keycloak/standalone/log && chmod 0777 keycloak/standalone/log

RUN chmod -R 0666  keycloak/standalone/configuration/ && chmod 777 keycloak/standalone/configuration
RUN chmod 0777 keycloak/standalone/tmp
RUN chmod 0777 /keycloak/standalone/deployments

RUN mkdir -p /keycloak/modules/system/layers/keycloak/org/postgresql/main/
RUN wget -q -O /keycloak/modules/system/layers/keycloak/org/postgresql/main/${POSTGRESQL_JDBC_JAR} https://jdbc.postgresql.org/download/${POSTGRESQL_JDBC_JAR}
RUN echo "<?xml version=\"1.0\" ?>\n<module xmlns=\"urn:jboss:module:1.3\" name=\"org.postgresql\">\n    <resources>\n        <resource-root path=\"${POSTGRESQL_JDBC_JAR}\"/>\n    </resources>\n    <dependencies>\n        <module name=\"javax.api\"/>\n        <module name=\"javax.transaction.api\"/>\n    </dependencies>\n</module>\n" \
    > /keycloak/modules/system/layers/keycloak/org/postgresql/main/module.xml

VOLUME keycloak/standalone/data
VOLUME keycloak/standalone/log
VOLUME keycloak/standalone/configuration

EXPOSE 9990 8080
USER 1234:1234


ENTRYPOINT ["/keycloak/bin/standalone.sh"]
