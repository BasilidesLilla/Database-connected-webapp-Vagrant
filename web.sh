#!/bin/bash
# Create your provisioning script here
apt-get update
apt-get install -y openjdk-11-jre-headless
groupadd tomcat
useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
cd /tmp
sudo yes | cp -rf /vagrant/apache-tomcat-9.0.41.tar ./
mkdir /opt/tomcat
tar xvf apache-tomcat-*tar -C /opt/tomcat --strip-components=1
cd /opt/tomcat
sudo chgrp -R tomcat /opt/tomcat
sudo chmod -R g+x /opt/tomcat
sudo chmod -vR g+r conf
sudo chmod -v g+x conf
sudo chown -vR tomcat webapps/ work/ temp/ logs/
# Create service
cat > /etc/systemd/system/tomcat.service << EOF
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl start tomcat
systemctl status tomcat
systemctl enable tomcat
cat > /opt/tomcat/bin/setenv.sh << EOF
export SPRING_DATASOURCE_url=jdbc:postgresql://192.168.56.102:5432/chinook
export SPRING_DATASOURCE_USERNAME=vagrant
export SPRING_DATASOURCE_PASSWORD=vagrant
EOF
cp /tmp/web.war /opt/tomcat/webapps/ROOT.war
rm -r /opt/tomcat/webapps/ROOT
systemctl restart tomcat
