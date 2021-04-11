# Dedicated to PostgreSQL

## Story

You're already familiar with Tomcat and Vagrant, now it's time to put it into use with creating a multi-machine enviroment, each running different services, one relying on the other.
Your task is to create a provisioning script which automatically sets up Tomcat and deploys a web-application into it without user interaction.

## What are you going to learn?

- How use Vagrant to create a multi-machine environment
- Learn how two connect two difference services via networking
- How to provision Tomcat automatically
- How to configure Tomcat and deploy a webapp onto it
- Learn by example how to provision PostgreSQL automatically
- See in action how a very basics 3-tier application stack functions

## Tasks

1. The `web` node will run a web-application that needs to be able to connect to the database on the `db` node. For this to happen `web` needs to know _where_ the hell `db` is via an IP address. Make the necessary additions to the `Vagrantfile` to be able to connect the `web` and `db` nodes.
    - The `db` node is configured to have a static private IP address
    - The `web` node is referencing this IP address in its `web.sh` provisioning script

2. Write the provisioning script of the `web` node of the multi-machine setup called `web.sh`. The script needs to do a few things in logical order: install Tomcat's dependency Java, then Tomcat itself, make it a service, configure it with environment variables required to be set for the web-application to be deployed and finally deploy the `.war` web-application archive to the server.
    - Java version 11 is intalled on the system, executing `java -version` includes `java version "11" ...`
    - Tomcat version 9.0.41 is downloaded from the official Apache Tomcat website and installed under `/opt/tomcat`
    - Created a service wrapper file for `systemctl` at `/etc/systemd/system/tomcat.service`
    - Running `systemctl status tomcat`, `systemctl start tomcat` and `systemctl stop tomcat` work as expected
    - Tomcat's welcome page is accessible at `http://localhost:8080`
    - Created `/opt/tomcat/bin/setenv.sh` with the following contents:

```
export SPRING_DATASOURCE_url=jdbc:postgresql://IP_ADDRESS_OF_DB:5432/chinook
export SPRING_DATASOURCE_USERNAME=vagrant
export SPRING_DATASOURCE_PASSWORD=vagrant
```

`IP_ADDRESS_OF_DB` is replaced with the actual private IP of the `db` node
    - `web.war` is copied/deployed under Tomcat's `webapps/` folder
    - Visiting `http://localhost:8080/web` loads the demo web-application, entering `SELECT * FROM artist` works

## General requirements

None

## Hints

- In a multi-machine Vagrant setup you need to use `vagrant ssh web` and such commands to SSH into a specific VM, see more in the [_Controlling multiple Vagrant machines_](https://www.vagrantup.com/docs/multi-machine#controlling-multiple-machines) background material
- In this project you're going to end up with two machines `web` and `db`
- The `Vagrantfile` is already setup to copy `web.war` and `chinook_data.sql` under `/tmp` in each machine
- Since we give you the provisioning script for the database run `vagrant up db` as your first thing when working on this to be done with setting up the dataase node
- When installing with `apt-get` from a provisioning script use the `-y` switch to automatically answer questions asked with _yes_
- Do not use `apt` or `apt-get` to install Tomcat, install it as described in [_Introduction to Tomcat_](project/curriculum/materials/tutorials/introduction-to-tomcat.md)
- SSH into the `web` node via `vagrant ssh web` and checkout Tomcat's logs at `logs/catalina.out` if you have problems deploying the web-application
- When reading about what is a [3-tiered application](https://en.wikipedia.org/wiki/Multitier_architecture#Three-tier_architecture)] think of the web-application provided as a `.war` file in the starter code representing the first 2 tiers

## Background materials

- [Introduction to Tomcat](project/curriculum/materials/tutorials/introduction-to-tomcat.md)
- [Vagrant: controlling multiple machines](https://www.vagrantup.com/docs/multi-machine#controlling-multiple-machines)
- [Vagrant: private networks](https://www.vagrantup.com/docs/networking/private_network#static-ip)
- [3-tiered application](https://en.wikipedia.org/wiki/Multitier_architecture#Three-tier_architecture)
