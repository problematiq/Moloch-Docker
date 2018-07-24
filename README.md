# Moloch-Docker
Docker image for moloch


# Requirements
This image requires an ElasticSearch instance, and does not come with one. \
You can either setup your own, or wait until I post an Ansible script which will setup both moloch, and ES.

# Prerequisites
The following is an example on how to create an ES instance, currently the last tested ES version was 6.3.1

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

If this is your first-time running this container, and do not have a `config.ini` already in `/data/moloch/etc/` then run the Following:
  - ***Before creating the container*** `mkdir -p /data/moloch/etc && touch /data/moloch/etc/config.ini`
  - ***After creating the container*** `docker exec -it moloch cp /data/moloch/etc/config.ini.sample /data/moloch/etc/config.ini`

***Running the container***
```
docker run \
  --name=moloch \
  -dit \
  --restart=on-failure \
  --net=host \
  -v /data/moloch/raw:/data/moloch/raw \
  -v /data/moloch/logs:/data/moloch/logs \
  -v /data/moloch/etc/config.ini:/data/moloch/etc/config.ini \
  problematiq/moloch-docker
```

You will need to edit `/data/moloch/etc/config.ini` and fill out the config file. The following are required for moloch to function:
  - `elasticsearch=` The url to your ES instance. e.g `elasticsearch=http://localhost:9200`
  - `interface=` Semi-colon separated value of the interfaces you will be monitoring traffic from. e.g `interface=eno1;emp3;ens01n5`

The following changes are not required, but are highly suggested:
  - `passwordSecret =` CHANGE ME!!!

If this is the first time you've installed moloch, there are two commands you need to run after the container is created for it to function.
  - `docker exec -it moloch /data/moloch/db/db.pl http://localhost:9200 init` ***note*** localhost will need to be changed to whatever hostname ES resides on.
  - `docker exec -it moloch /data/moloch/bin/moloch_add_user.sh admin admin admin --admin`
This will create a username:admin password:admin you can create a new user and delete this one via the web gui. \

# Future version changes:
Clean up dockerfile. \
Improve readme. \
create a method of deploying an All-in-one other than Ansible. \
figure out what to do about setting up an initial deployment for the Following:
  - certificates, or maybe i'll just ignore this One.

**Critical** \
move all the initial setup into a script. \
insure interface settings, log rotate, and limits get set on host.

## Release Notes:
+ **7/24/18 - v1.5.1_3**
`db.pl init` instructions added. \
instructions to create default admin account added. \
Overall added tons to the readme. \
Added ES Example

+ **7/23/18 - v1.5.1_2**
Remembered im setting `--net=host` so there's no reason to expose a port. \
Added a quick how-to for setting up ES locally

+ **7/23/18 - v1.5.1**
Moloch version 1.5.1 \
Following Moloch's SVC

+ **7/22/18 - v1.5**
Moloch version 1.5

+ **3/26/18 - v1.1**
Moloch version 1.1 \
Remove un-needed environmental variables. \
Added OS version for ubuntu. \
Cleaned up the build file a bit.

+ **3/23/18 - v1.0.1**
Changed to version 1.0 \
Removed systemd YAY~! \
Moved shell steps from my ansible script to dockerfile.

+ **3/20/18 - v1.0**
Changed to version Moloch 1.0 rc1-1. \
stopped using Nightly-builds for moloch.

+ **3/6/18 - v0.50**
Started version control. \
Removed nano and less from installed packages. \
Created notes within the dockerfile to explain each step of the build.
