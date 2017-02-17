# Presales Docker # 

## Preinstall Steps ##

### Install Docker on MAC ###

 * Follow [Docker Mac guide](https://docs.docker.com/docker-for-mac/) for install steps
 * Verify docker is installed by running following on terminal
    

```
#!shell

docker status
```

## Create Docker Images ##
Lets build some docker images which are foundation of docker containers. More about basics at [Docker Images](https://docs.docker.com/engine/tutorials/dockerimages/) 

### Harmony Image ###
 This is one time exercise and you will be able to containers as many times afterwards so please continue
    Installs 5.3 GA 
    Installs Patch 16
    Adds JT's github wrappers

```
#!shell
# Build harmony image
cd hy53
# Display status of images
docker images
```

### JReport Image ###
Creates JReport(12.1.3) Image

```
#!shell

# Build Jreport image
cd ../jreport
docker build -t jreport .
# Display status of images
docker images
```

### VLProxy Image ###
Creates VLProxy(3.5.1.6) Image

```
#!shell

# Build VLProxy image
cd ../vlproxy
docker build -t vlproxy .
# Display status of images
docker images
```

## Create Docker Containers ##

Docker-compose is a very powerful tool that enables multiple containers to work together and makes mundane tasks easy. For more information refer to [Docker Compose](https://docs.docker.com/compose/compose-file/)

### Single Node HY/JReport/MYSQL ###
 Creates a Single Node Cluster with 3 containers (HY, JReport, MYSQL)


```
#!shell
 cd hy53
 docker-compose up -d
 # Ensure containers are running
 docker ps -a
 #bootstrap the container
 VERSALEX_CONTAINER=`docker ps -a|grep "harmony:latest"|awk '{print $1}'`
 docker exec -it $VERSALEX_CONTAINER ./bootstrap.sh
 docker restart $VERSALEX_CONTAINER 

 # Stop all containers
 docker-compose stop
 
 # Start all containers
 docker-compose start
```

### Single node HY/JReport/MYSQL/VLProxy ###
 Creates Single Node Cluster with 4 containers ( HY, JReport, MYSQL, VLProxy)
 
```
#!shell
 cd hy53
 # Notice docker compose uses alternate docker compose yml file
 docker-compose up -f docker-compose_1n_vlp.yml up -d
 # Ensure containers are running
 docker ps -a
 #bootstrap the container
 ./post_setup.sh
```
 **There is a manual step to add vlproxy to Harmony UI due to lack of API.
          Domain name of VLproxy is domain:"vlp", port:8080
**

# ToDO #

* Cluster set up. For now docker-compose_2n.yml can be used but there are few manual steps i am trying to overcome
* AWS ECS - This can be used for quickstart POC environments but we cant shutdown EC2 images hence makes it harder for Demo environment
* AWS Cloudformation + Docker - This could be way to go for POC environments. Single EC2 Image can be used for Cluster set up etc for POC / Demo environments.
