_This project has been created as part of the 42 curriculum by dasimoes

# Inception

## Description

The inception project is about creating a small infrastructure using container technology through a popular
container management tool called Docker and its orchestrator (Docker Compose). By going through the project one 
is expected to build at least 3 indepent services to host a website which are MariaDB, NGINX and Wordpress.
These services have to be handled in a secure and automated way through the use of docker-compose, a well-thought out
Makefile and following decent security practices outlined in the project.

## Instructions

To run the project you may simply type in make in the root repository to build the images using the .env.example file
and generating the passwords automatically in the new secrets folder and then you may type in make up to run each
container. After that you may see the website in the standard domain dasimoes.42.fr. You may also provide your own .env file 
using the .env.example file inside srcs as a blueprint.

## Resources

The resources utilized for this project are mainly each service's documentation alongside tutorials one may find online.
The use of AI was done to further understand a topic such as the different types of network supported by docker or
how namespaces work, for example.

You will find a list of what I used as resources by service below:

Mariadb:
https://www.youtube.com/watch?v=-b3trv4e5TE&t=1159s
https://mariadb.com/docs/

Docker:
https://docs.docker.com/
https://www.youtube.com/watch?v=RqTEHSBrYFw&t=10737s
https://www.youtube.com/watch?v=85k8se4Zo70

NGINX:
https://www.youtube.com/watch?v=9t9Mp0BGnyI
https://nginx.org/en/docs/

Wordpress:
https://www.youtube.com/watch?v=R4v_7hh4Yys
https://wordpress.org/documentation/

## Project Description

Docker was used as the tool to manage the containers in the project's infrastructure. 
Inside srcs you will find a .yml file which is used to tell docker-compose how to 
run our containers, which volumes to mount and which settings to use and inside the
requirements folder you may find all the image specific files separated in each folder
for each service so docker has the exact context it needs to build each image correctly.
Below I also outline a comparison in different areas so one may better understand why 
to use a container instead of a virtual machine.

What's the difference between virtual machines and Docker?

A virtual machine virtualizes another entire operational system so you may have a 
completely different system running on top of the same hardware. You may run a windows 
machine on top of linux, for example. Docker, on the other hand, is a tool that allows
you to create a container which is a process that runs on the same operational system,
however it believes it's the only process running, it does not know anything about your
host system because we limited what the process can "see" and do via cgroups and namespaces. 
Since containers are simply processes they are much lighter and easier to handle than 
entire virtualized machines which is why they are preferred.

What's the difference between secrets and enviroment variables?

Secrets are files that contain sensitive information that must no be shared openly so 
docker mounts them on your running container only and enviroment variables are variables 
needed for the execution of your project. You may have a domain name that must be shared 
across different services so instead of hard coding that in many different files, you simply 
set an enviroment variable and pass that value as a placeholder inside each file.

What's the difference between Docker network and host network?

The Docker network is simply a namespace for a process. They are not "real" networks
in the sense that the process believes it's inside a completely isolated network but
the kernel is simply lying to the process and docker is managing a maping of this fake
network to your regular network that runs on your host.

What's the difference between Docker volumes and bind mounts?

Docker volumes are storage space that's handled directly by Docker in its own space
(usually /var/lib/docker/volumes/), however bind amounts map a specific provided 
folder in my filesystem to a container I choose.
