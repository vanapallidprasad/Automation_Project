#!/bin/bash

# Initialize variables
myname="Deviprasad"
s3_bucket="upgrad-vanapallidevi"

# Perform an update of the package details and the package list
sudo apt update -y

# Check if apache2 package is installed
dpkg -s apache2 &> /dev/null
if [ $? -ne 0 ]; then
    # Install apache2 package
    sudo apt install apache2 -y
fi

# Check if apache2 service is running
sudo systemctl is-active --quiet apache2
if [ $? -ne 0 ]; then
    # Start apache2 service
    sudo systemctl start apache2
fi

# Check if apache2 service is enabled
sudo systemctl is-enabled --quiet apache2
if [ $? -ne 0 ]; then
    # Enable apache2 service
    sudo systemctl enable apache2
fi

# Create tar archive of apache2 access logs and error logs
timestamp=$(date '+%d%m%Y-%H%M%S')
tar -cvf /tmp/${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log --exclude '*.zip' --exclude '*.tar'

# Copy archive to S3 bucket using AWS CLI
aws s3 cp /tmp/${myname}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar

