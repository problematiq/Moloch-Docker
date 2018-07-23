# Moloch-Docker
Docker image for moloch


# Requirements
This image requires an ElasticSearch instance, and does not come with one. \
You can either setup your own, or wait until I post my Ansible script which will setup both moloch, and ES.

# Example run command:
```
docker run \
  --name=moloch \
  -dit \
  --restart=on-failure \
  --net=host \
  -v /data/moloch/raw:/data/moloch/raw \
  -v /data/moloch/logs:/data/moloch/logs \
  -v /data/moloch/etc/config.ini:/data/moloch/etc/config.ini \
  -p 8005:8005 \
  problematiq/moloch-docker
```

# Future version changes:
Clean up dockerfile. \
Improve readme. \
create a method of deploying an All-in-one other than Ansible \.
figure out what to do about setting up an initial deployment for the Following: \
  - certificates, or maybe i'll just ignore this One. \
  - `db.pl init` \
  - create default admin account. \
Change Example to include ES container?

# Release Notes:
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
