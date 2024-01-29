# Gebruik oraclelinux:8-slim als basisimage
FROM oraclelinux:8-slim

# Stel de werkomgeving in
WORKDIR /opt/app

# Kopieer de Oracle Instant Client ZIP-bestanden
# Zorg ervoor dat u de juiste versie van de Oracle Instant Client downloadt en deze bestanden in uw Docker context plaatst
COPY instantclient-basic-linux.x64-21.12.0.0.0dbru.zip /opt/oracle/
COPY instantclient-sqlplus-linux.x64-21.12.0.0.0dbru.zip /opt/oracle/

# Installeer de benodigde pakketten en afhankelijkheden
RUN microdnf install unzip && \
    microdnf install oracle-epel-release-el8 && \
    microdnf module disable python36 && \
    microdnf module enable python39 && \
    microdnf install python39 python39-pip python39-setuptools python39-wheel vim vi httpd-tools libaio && \
	microdnf install sudo && microdnf install util-linux-user &&  microdnf install net-tools && \
    microdnf clean all

RUN groupadd oinstall && groupadd dba  && useradd -m -g oinstall -G dba oracle

# Stel de omgevingsvariabelen in voor Oracle Instant Client
ENV ORACLE_HOME=/opt/oracle/instantclient_21_12 \
    LD_LIBRARY_PATH=/opt/oracle/instantclient_21_12:$LD_LIBRARY_PATH \
    PATH=/opt/oracle/instantclient_21_12:$PATH

# Pak de Oracle Instant Client ZIP-bestanden uit
RUN unzip /opt/oracle/instantclient-basic-linux.x64-21.12.0.0.0dbru.zip -d /opt/oracle/ && \
    unzip /opt/oracle/instantclient-sqlplus-linux.x64-21.12.0.0.0dbru.zip -d /opt/oracle/ 

RUN rm /opt/oracle/instantclient-basic-linux.x64-21.12.0.0.0dbru.zip  /opt/oracle/instantclient-sqlplus-linux.x64-21.12.0.0.0dbru.zip

Copy ./scripts /scripts 

# Installeer python-oracledb
RUN pip3 install oracledb
RUN python3 -m pip install oracledb --user --no-warn-script-location

WORKDIR /scripts

