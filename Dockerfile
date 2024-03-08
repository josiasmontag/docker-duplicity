FROM ghcr.io/tecnativa/docker-duplicity:3.3.0 AS mysql

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/main mariadb-client \
    && mysql --version \
    && mysqldump --version

# Install full version of grep to support more options
RUN apk add --no-cache grep
ENV JOB_200_WHAT set -euo pipefail; mysql -u\"\$MYSQL_USER\" -p\"\$MYSQL_PASSWORD\" -h\"\$MYSQL_HOST\" -srNe \"SHOW DATABASES\"  | grep -E \"\$DBS_TO_INCLUDE\" | grep --invert-match -E \"\$DBS_TO_EXCLUDE\" | xargs -tI DB mysqldump -u\"\$MYSQL_USER\" -p\"\$MYSQL_PASSWORD\" -h\"\$MYSQL_HOST\"  --result-file=\"\$SRC/DB.sql\" DB
ENV JOB_200_WHEN='daily weekly' \
    DBS_TO_INCLUDE='.*' \
    DBS_TO_EXCLUDE='^(mysql|performance_schema|information_schema)\$' \
    MYSQL_HOST=db \
    MYSQL_USER=root \
    MYSQL_PASSWORD=invalid


FROM mysql AS mysql-s3
ENV JOB_500_WHAT='dup full $SRC $DST' \
    JOB_500_WHEN='weekly' \
    OPTIONS_EXTRA='--metadata-sync-mode partial --full-if-older-than 1W --file-prefix-archive archive-$(hostname -f)- --file-prefix-manifest manifest-$(hostname -f)- --file-prefix-signature signature-$(hostname -f)- --s3-european-buckets --s3-multipart-chunk-size 10 --s3-use-new-style'