FROM debian:sid

RUN apt-get update && apt-get install --no-install-recommends -y \
     gdal-bin \
     xmlstarlet \
     cgi-mapserver \
     spawn-fcgi \
     multiwatch \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV GDAL_CACHEMAX=1024

# ENV GDAL_HTTP_CONNECTTIMEOUT
# ENV GDAL_HTTP_TIMEOUT
# ENV GDAL_HTTP_MAX_RETRY
# ENV GDAL_HTTP_RETRY_DELAY=10
# ENV GDAL_HTTP_PROXY=cache:3128

ENV MS_MAPFILE="/app/namibia-50k-topo.map"
ENV MS_MAPFILE_PATTERN="\.map$"
ENV MS_DEBUGLEVEL="0"
ENV MS_ERRORFILE="stderr"

WORKDIR /app

COPY namibia-50k-topo.map /app/

EXPOSE 9000

CMD ["/usr/bin/spawn-fcgi", "-n", "-p", "9000", "-b", "1", "--", "/usr/bin/multiwatch", "-f", "4", "--signal=TERM", "--", "/usr/lib/cgi-bin/mapserv"]
