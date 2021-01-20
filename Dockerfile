FROM gcc:latest AS mcrcon_build
RUN git clone --depth 1 --branch v0.7.1 https://github.com/Tiiffi/mcrcon.git
WORKDIR /mcrcon
RUN gcc -std=gnu11 -pedantic -Wall -Wextra -O2 -s -o mcrcon mcrcon.c

FROM mcr.microsoft.com/java/jre-headless:8-zulu-alpine
ADD ./script /
RUN chmod +x /*.sh

# cron.sh dependency busybox
RUN set -ex; \
    apk add --no-cache \
        busybox wget; \
    mkdir -p /var/spool/cron/crontabs; \
    echo '0 23 * * * /backup.sh' > /var/spool/cron/crontabs/root;
RUN mkdir -p /{backups,tools,server}
COPY --from=mcrcon_build /mcrcon/mcrcon /tools/mcrcon
RUN wget -q https://launcher.mojang.com/v1/objects/1b557e7b033b583cd9f66746b7a9ab1ec1673ced/server.jar -P /server; \
    apk del wget;
WORKDIR /server
RUN java -Xmx1024M -Xms512M -jar server.jar nogui; exit 0
COPY ./properties/server.properties /server/server.properties
COPY ./properties/eula.txt /server/eula.txt
ENV MCRCON_PWD=DEFAULT_MCRCON_PASS
EXPOSE 25565
ENTRYPOINT [ "/entrypoint.sh" ]
