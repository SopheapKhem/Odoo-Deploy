#!/bin/bash
#####################################################################################################
# Script for installing Postgres on Ubuntu 14.04, 15.04 and 16.04 (could be used for other version too)
# Author: Mohamed Hammad
# Inspired by: Yenthe Van Ginneken
#----------------------------------------------------------------------------------------------------
# This script will install Postgres on your Ubuntu 16.04 server.
#-----------------------------------------------------------------------------------------------------
# Make a new file:
# sudo nano 01-postgres-install.sh
# Place this content in it and then make the file executable:
# sudo chmod +x 01-postgres-install.sh
# Execute the script to install Postgres:
# sudo ./01-postgres-install.sh
#######################################################################################################

##fixed parameters
DB_USER="odoo"
DB_PASS="odoo"

#
# Install dialog
#
echo -e "\n---- Update Server ----"
apt-get update >> ./install_log
echo -e "\n---- Install dialog ----"
apt-get install dialog -y >> ./install_log
#
# Remove Odoo and PostgreSQL
#
#--------------------------------------------------
# Update Server
#--------------------------------------------------
echo -e "\n---- Upgrade Server ----"
apt-get upgrade -y >> ./install_log

#--------------------------------------------------
# Install PostgreSQL Server
#--------------------------------------------------
# Add official repository
cat <<EOF > /etc/apt/sources.list.d/pgdg.list
deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main
EOF

echo -e "\n---- Install PostgreSQL Repo Key ----"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -


echo -e "\n---- Install PostgreSQL Server ${OE_POSTGRESQL_VERSION} ----"
apt-get update >> ./install_log
apt-get install postgresql-${OE_POSTGRESQL_VERSION} postgresql-server-dev-${OE_POSTGRESQL_VERSION}   -y >> ./install_log


echo -e "\n---- Creating the Odoo PostgreSQL User  ----"
sudo su - postgres -c "createuser -s $DB_USER" 2> /dev/null || true
sudo su - postgres -c "psql -c \"ALTER USER $DB_USER WITH PASSWORD '$DB_PASS';\""
