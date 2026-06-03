_User Documentation - Inception 42SP

# USER_DOC

## Services

There are 3 services running for this infrastructure - Nginx, Wordpress and Mariadb.
Those services can be managed via the outlined commands inside the managament section
below and you may also change many aspects of your website by accessing the domain and
then the administration panel in https://dasimoes.42.fr/wp-admin. You'll need to input
the admin user outlined in the .env file and the password described in the credentials
section. Inside the administration panel you may manage every aspect of the content 
displayed and you may even increase functionality through the use of a plugin.

## Credentials

After you hit make on the project, it will generate random passwords inside a folder
named secrets inside te project, you may take a look at each .txt and find any credential
you might need. You may also change the contents inside those files to update the password but
if you do you will need to restart the containers via make restart.

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
