FROM openjdk:8-jre-slim

ENV CEREBRO_VERSION=0.8.0

RUN apt-get update \
 && apt-get install -y wget \
 && mkdir -p /opt/cerebro/logs \
 && wget -qO- https://github.com/lmenezes/cerebro/releases/download/v${CEREBRO_VERSION}/cerebro-${CEREBRO_VERSION}.tgz \
  | tar xzv --strip-components 1 -C /opt/cerebro \
 && sed -i '/<appender-ref ref="FILE"\/>/d' /opt/cerebro/conf/logback.xml \
 && groupadd --system cerebro \
 && useradd --system --gid cerebro cerebro \
 && chown -R cerebro:cerebro /opt/cerebro \
 && apt-get remove -y --purge --auto-remove wget \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/cerebro
USER cerebro
CMD [ "/opt/cerebro/bin/cerebro" ]
