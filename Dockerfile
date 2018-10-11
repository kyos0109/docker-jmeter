FROM openjdk:8-jre-alpine

LABEL maintainer "kyosls@gmail.com"

ENV JMETER_VERSION      5.0
ENV JMETER_HOME         /opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_DOWNLOAD_URL https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz
ENV PATH                ${JMETER_HOME}/bin:$PATH

COPY jmeter.sh          ${JMETER_HOME}/bin/jmeter-args.sh

RUN set -x && \
    chmod +x ${JMETER_HOME}/bin/jmeter-args.sh && \
    apk add --no-cache --virtual .dep_pack curl && \
    mkdir -p /opt && \
    curl -L --silent ${JMETER_DOWNLOAD_URL} | tar -xz -C /opt && \
    curl -L --silent https://jmeter-plugins.org/files/packages/jpgc-functions-2.1.zip -o /tmp/jpgc-functions-2.1.zip && \
    unzip -o -d ${JMETER_HOME} /tmp/jpgc-functions-2.1.zip && \
    rm /tmp/jpgc-functions-2.1.zip && \
    apk del .dep_pack

EXPOSE 60000

ENTRYPOINT ["jmeter-args.sh","-n","-Jclient.rmi.localport=60000","-Jclient.tries=3","-Jclient.retries_delay=10000","-Jclient.continue_on_fail=true"]
