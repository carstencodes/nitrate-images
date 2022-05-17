##
## Copyright (c) 2022 Carsten Igel.
##
## This file is part of Nitrate Alpine Docker Images With Social-Auth 
## (see https://github.com/carstencodes/nitrate-images).
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU Affero General Public License as
## published by the Free Software Foundation, either version 3 of the
## License, or (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU Affero General Public License for more details.
##
## You should have received a copy of the GNU Affero General Public License
## along with this program. If not, see <http://www.gnu.org/licenses/>.
##
FROM alpine:3.15 as nitrate

ARG NITRATE_VERSION=4.12

ARG PYTHON_VERSION=3.9.7-r4
ARG OPENSSL_VERSION=1.1.1o-r0
ARG PSQL_VERSION_MAJOR=13
ARG PSQL_VERSION_TAIL=6-r0
ARG MARIADB_VERSION=10.6.7-r0
ARG BUILD_BASE_VERSION=0.5-r2
ARG LIBFFI_VERSION=3.4.2-r1
ARG CARGO_VERSION=1.56.1-r0
ARG PYWHEEL_VERSION=0.36.2-r2
ARG PYPIP_VERSION=20.3.4-r1
ARG LIBPQ_VERSION=14.3-r0
ARG MARIADB_CONN_VERSION=3.1.13-r2
ARG SIX_VERSION=1.16.0
ARG PY3_SIX_VERSION=1.16.0-r0
ARG PY3_SETUPTOOLS_VERSION=52.0.0-r4

RUN mkdir -p /home/nitrate /opt/nitrate \
  && addgroup -S nitrate \
  && adduser -G nitrate -h /home/nitrate -S nitrate -s /bin/sh \
  && chown -R nitrate:nitrate /home/nitrate /opt/nitrate \
  && apk add --no-cache \
                python3=${PYTHON_VERSION} \
                libpq=${LIBPQ_VERSION} \
                mariadb-connector-c=${MARIADB_CONN_VERSION} \
                py3-six=${PY3_SIX_VERSION} \
                py3-setuptools=${PY3_SETUPTOOLS_VERSION}

COPY --chown=nitrate:nitrate app/*.py /opt/nitrate/

RUN apk add --no-cache --virtual build-deps \
        openssl-dev=${OPENSSL_VERSION} \
        postgresql${PSQL_VERSION_MAJOR}-dev=${PSQL_VERSION_MAJOR}.${PSQL_VERSION_TAIL} \
        mariadb-dev=${MARIADB_VERSION} \
        python3-dev=${PYTHON_VERSION} \
        build-base=${BUILD_BASE_VERSION} \
        libffi-dev=${LIBFFI_VERSION} \
        cargo=${CARGO_VERSION} \
        py3-wheel=${PYWHEEL_VERSION} \
        py3-pip=${PYPIP_VERSION} \
  && pip install --no-cache-dir \
        "nitrate-tcms[mysql,pgsql]"==${NITRATE_VERSION} \
  && apk del build-deps

USER nitrate:nitrate

WORKDIR /opt

ENV PYTHONPATH=/opt \
    NITRATE_DB_HOST= \
    NITRATE_DB_BACKEND=pgsql \
    DJANGO_SETTINGS_MODULE=nitrate.settings

FROM nitrate as web

ARG NITRATE_VERSION=4.12
ARG PYTHON_VERSION=3.9.7-r4
ARG GUNICORN_VERSION=20.1.0

ARG OPENSSL_VERSION=1.1.1o-r0
ARG PSQL_VERSION_MAJOR=13
ARG PSQL_VERSION_TAIL=.6-r0
ARG MARIADB_VERSION=10.6.7-r0
ARG BUILD_BASE_VERSION=0.5-r2
ARG LIBFFI_VERSION=3.4.2-r1
ARG CARGO_VERSION=1.56.1-r0
ARG PYWHEEL_VERSION=0.36.2-r2
ARG PYPIP_VERSION=20.3.4-r1
ARG KRB_VERSION=1.19.3-r0

USER root:root

RUN apk add --no-cache --virtual build-deps \
          openssl-dev=${OPENSSL_VERSION} \
          python3-dev=${PYTHON_VERSION} \
          build-base=${BUILD_BASE_VERSION} \
          libffi-dev=${LIBFFI_VERSION} \
          cargo=${CARGO_VERSION} \
          py3-wheel=${PYWHEEL_VERSION} \
          py3-pip=${PYPIP_VERSION} \
          krb5-dev=${KRB_VERSION} \
  && pip install --no-cache-dir \
          gunicorn==${GUNICORN_VERSION} \
          "nitrate-tcms[krbauth,socialauth]"==${NITRATE_VERSION} \
  && apk del build-deps

USER nitrate:nitrate

EXPOSE 8000

#TODO Add config file
ENTRYPOINT [ "/usr/bin/gunicorn", "--bind", "0.0.0.0", "--port", "8000", "nitrate.wsgi:application" ]

FROM nitrate as migrate

ENTRYPOINT [ "/usr/bin/django-admin", "migrate" ]

FROM nitrate as setup

COPY --chown=nitrate:nitrate setup/bootstrap.py /opt/nitrate/setup/bootstrap.py

ENV NITRATE_SUPERUSER_LOGIN= \
    NITRATE_SUPERUSER_PASSWORD= \
    NITRATE_SUPERUSER_EMAIL= \
    NITRATE_SUPERUSER_FIRSTNAME= \
    NITRATE_SUPERUSER_LASTNAME= 

ENTRYPOINT [ "/opt/nitrate/setup/bootstrap.py" ]

FROM nitrate as worker

ARG NITRATE_VERSION=4.12
ARG PYTHON_VERSION=3.9.7-r4

ARG OPENSSL_VERSION=1.1.1o-r0
ARG PSQL_VERSION_MAJOR=13
ARG PSQL_VERSION_TAIL=.6-r0
ARG MARIADB_VERSION=10.6.7-r0
ARG BUILD_BASE_VERSION=0.5-r2
ARG LIBFFI_VERSION=3.4.2-r1
ARG CARGO_VERSION=1.56.1-r0
ARG PYWHEEL_VERSION=0.36.2-r2
ARG PYPIP_VERSION=20.3.4-r1
ARG KRB_VERSION=1.19.3-r0

USER root:root

RUN apk add --no-cache --virtual build-deps \
          openssl-dev=${OPENSSL_VERSION} \
          python3-dev=${PYTHON_VERSION} \
          build-base=${BUILD_BASE_VERSION} \
          libffi-dev=${LIBFFI_VERSION} \
          cargo=${CARGO_VERSION} \
          py3-wheel=${PYWHEEL_VERSION} \
          py3-pip=${PYPIP_VERSION} \
          krb5-dev=${KRB_VERSION} \
  && pip install --no-cache-dir \
          "nitrate-tcms[async]"==${NITRATE_VERSION} \
  && apk del build-deps

USER nitrate:nitrate

ENTRYPOINT [ "/usr/bin/celery", "-A", "tcms", "worker", "-l", "INFO" ]
