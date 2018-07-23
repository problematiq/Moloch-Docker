# Moloch-Docker
Docker image for moloch


# Requirements
This image requires an ElasticSearch instance, and does not come with one. \
You can either setup your own, or wait until I post my Ansible script which will setup both moloch, and ES.

# Prerequisites
The following is an example on how to create an ES instance, currently the last tested ES version was 6.3.1 \

You can change the amount of memory the container reserves, but be sure and give the container more ram than ES, \
and never give ES more than 30G of ram.
```
mkdir -p /opt/elasticsearch/node/data \
  && chmod -R 755 /opt/elasticsearch/node \
&& docker run \
  --name=ES \
  -dit \
  --restart=on-failure \
  --oom-kill-disable \
  -m 5g \
  --memory-reservation=5g \
  -v /opt/elasticsearch/node/data:/usr/share/elasticsearch/data \
  -p 127.0.0.1:9200:9200/tcp \
  -e "cluster.name=Moloch-cluster" \
  -e "discovery.type=single-node" \
  -e "bootstrap.memory_lock=true" \
  -e "ES_JAVA_OPTS=-Xms4g -Xmx4g" \
  -e "xpack.security.enabled=false" \
  --ulimit nofile=65536:65536 \
  --ulimit memlock=-1:-1 \
  docker.elastic.co/elasticsearch/elasticsearch:6.3.1
```

# Example run command:
```
docker run \
  --name=moloch \
  -dit \
  --restart=on-failure \
  --net=host \
  -v /data/moloch/raw:/data/moloch/raw \
  -v /data/moloch/logs:/data/moloch/logs \
  -v /data/moloch/etc:/data/moloch/etc \
  problematiq/moloch-docker
```

You will likely need to run `docker stop moloch` after using the docker run command above, \
then editing `/data/moloch/etc/config.ini` and filling out the desired settings. \

If this is the first time you've installed moloch, there are two commands to need to run before it will function.


# Future version changes:
Clean up dockerfile. \
Improve readme. \
create a method of deploying an All-in-one other than Ansible \.
figure out what to do about setting up an initial deployment for the Following:
  - certificates, or maybe i'll just ignore this One.
  - `db.pl init`
  - create default admin account.
Change Example to include ES container?

# Release Notes:
# 7/23/18 - v1.5.1_2
Remembered im setting `--net=host` so there's no reason to expose a port.
Added a quick how-to for setting up ES locally

# 7/23/18 - v1.5.1
Moloch version 1.5.1 \
Following Moloch's SVC

# 7/22/18 - v1.5
Moloch version 1.5

# 3/26/18 - v1.1
Moloch version 1.1 \
Remove un-needed environmental variables. \
Added OS version for ubuntu. \
Cleaned up the build file a bit.

# 3/23/18 - v1.0.1
Changed to version 1.0 \
Removed systemd YAY~! \
Moved shell steps from my ansible script to dockerfile.

# 3/20/18 - v1.0
Changed to version Moloch 1.0 rc1-1. \
stopped using Nightly-builds for moloch.

# 3/6/18 - v0.50
Started version control. \
Removed nano and less from installed packages. \
Created notes within the dockerfile to explain each step of the build.
