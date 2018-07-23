########################################################################
# Moloch capture/viewer container
# v2.2
# By Problematiq
########################################################################

# Base Image #
FROM ubuntu:16.04

MAINTAINER Taylor Ashworth <silvertear33@yahoo.com>

#####################
# Enviromental variables
#####################
ENV DEBIAN_FRONTEND noninteractive
# Auto accepts Java EULA #
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

#####################
# Setup
#####################

# Install Moloch dependencies #
RUN apt-get update \
        && apt-get install -y software-properties-common \
        && apt-get update \
        && apt-get install -y wget \
        npm \
        curl \
        libwww-perl \
        libjson-perl \
        ethtool \
        libyaml-dev

# Install Java #
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
        && add-apt-repository -y ppa:webupd8team/java \
        && apt-get update \
        && apt-get install -y oracle-java8-installer \
        && rm -rf /var/lib/apt/lists/* \
        && rm -rf /var/cache/oracle-jdk8-installer

# Install Moloch #
RUN apt-get -y upgrade \
        && apt-get -y dist-upgrade \
        && wget https://files.molo.ch/builds/ubuntu-16.04/moloch_1.5.1-1_amd64.deb \
        && apt-get -f -y install \
        && dpkg -i moloch_1.5.1-1_amd64.deb \
        && sh /data/moloch/bin/moloch_update_geo.sh

### Area reserved for PKI's ###
# COPY /certs/CA_or_chain.crt /usr/local/share/ca-certificates/
# RUN update-ca-certificates --fresh
####

#####################
# Files
#####################

### Adding start script ###
COPY /startscript/start_script.sh /data/moloch/bin/
RUN chmod 755 /data/moloch/bin/start_script.sh

#####################
# Mounted volumes
#####################

# Assigns volumes to later mount to host #
VOLUME /data/moloch/raw \
        /data/moloch/logs \
# Mount for config files.
        /data/moloch/etc
#####################
# Start script(s)
#####################

### start script for moloch
CMD /data/moloch/bin/start_script.sh
#### Finished! ####
