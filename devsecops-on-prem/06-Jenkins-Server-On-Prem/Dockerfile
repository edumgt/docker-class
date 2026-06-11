FROM jenkins/jenkins:latest

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends docker.io git curl nginx python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY scripts/sse_log_server.py /usr/local/bin/sse_log_server.py
COPY scripts/start-services.sh /usr/local/bin/start-services.sh
COPY www/install-log.html /usr/share/nginx/html/install-log.html

RUN chmod +x /usr/local/bin/sse_log_server.py /usr/local/bin/start-services.sh \
    && rm -f /etc/nginx/sites-enabled/default \
    && mkdir -p /var/lib/nginx /var/log/nginx /run /var/jenkins_home/logs \
    && chown -R jenkins:jenkins /var/lib/nginx /var/log/nginx /run /var/jenkins_home/logs

USER jenkins
EXPOSE 8888 50000

ENTRYPOINT ["/usr/local/bin/start-services.sh"]
