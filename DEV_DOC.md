_Developer Documentation - Inception 42SP

# DEV_DOC

## Setting up your own services

You may choose to set up your services from scratch and to do that you will need
to make a dockerfile, an entrypoint script and a configuration file for each service
you are setting up. The docker file dowloads the basic userland needed for the process
and installs any dependencies you might need while building the image and copies both the
entrypoint script and configuration file to the image itself. The entrypoint script has 
any commands you might need to run to have the container set up and the configuration file
tunes the services to your needs. Those 3 files are essential for any service. To coordinate 
those containers in a single file through docker-compose you will also need a .yml file configuring
all the necessary volumes, networks and services and how the interact for your application.
These are necessary in order to coordinate your containers well.

## Makefile and docker compose

You may use docker-compose to manage all your containers according to the docker-compose.yml
file you have written and you may also write your own Makefile including all these commands 
so you can better automate this process. Each command below I made using a specific sequence
of docker-compose commands inside my makefile.

I also made a make manual command one may use to interactively generate a new .env file 
changing the default configuration I use and in that command I used the read command to
capture terminal input.

## Management

There are a few commands you may use to manage the infrastructure and those are outlined below:

make - builds each image and sets up the standard secrets and enviroment variables

make up - runs the containers

make stop - stops the containers

make restart - restarts the containers

make status - spits out a log with everything happening inside each service

make clean - stops and deletes the containers alongside their network

make fclean - cleans everything and deletes the volumes 

make re - cleans everything and then rebuilds it 

## Locations

You may find sensitive secrets information stored in the secrets folder and you may also find
your volume data being saved in a bind mount fashion inside the paths below where <USER> is 
the system user that's saved in the $USER enviroment variable.

/home/<USER>/data/wordpress
/home/<USER>/data/mariadb

