#!/bin/bash

# Backup existing repo files
echo "Backing up current repository files..."
mkdir -p /etc/yum.repos.d/backup/
cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/backup/CentOS-Base.repo.bak

# Create a new CentOS-Base.repo file with updated vault URLs
echo "Updating the repository configuration to use CentOS 7.9 vault..."

cat <<EOF > /etc/yum.repos.d/CentOS-Base.repo
[base]
name=CentOS-7.9.2009 - Base
baseurl=http://vault.centos.org/7.9.2009/os/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

# Released updates
[updates]
name=CentOS-7.9.2009 - Updates
baseurl=http://vault.centos.org/7.9.2009/updates/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

# Additional packages that may be useful
[extras]
name=CentOS-7.9.2009 - Extras
baseurl=http://vault.centos.org/7.9.2009/extras/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
EOF

# Clean YUM cache and update the system
echo "Cleaning YUM cache and updating the system..."
yum clean all
yum makecache fast
yum update -y

echo "Repository update complete. System is now using the CentOS 7.9 vault repositories."
