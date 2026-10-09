# FreeRADIUS with DMA Patch and Radius Manager

A collection of shell scripts and installation archives for setting up a FreeRADIUS-based environment with a DMA patch, Radius Manager, and supporting ionCube loaders.

## Overview

This repository contains scripts for updating and installing components associated with a FreeRADIUS and Radius Manager deployment.

### Repository Contents

| File | Purpose |
|---|---|
| `1repoupdate.sh` | Repository update preparation |
| `2macupdate.sh` | Additional update or configuration preparation |
| `3install.sh` | Installation workflow |
| `freeradius-server-2.2.0-dma-patch-2.tar.gz` | FreeRADIUS 2.2.0 source archive with DMA patch |
| `ioncube_loaders_lin_x86-64.tar.gz` | ionCube Loader package for 64-bit Linux |
| `radiusmanager-4.1.6.gz` | Radius Manager 4.1.6 archive |
| `README.md` | Installation instructions |

> **Compatibility warning:** These are legacy software versions. FreeRADIUS 2.2.0 and older Radius Manager releases may not be compatible with modern Linux distributions, PHP versions, OpenSSL libraries, or database versions. Verify compatibility before installing.

## Requirements

- A Linux server supported by the specific software versions.
- Root or `sudo` privileges.
- Internet access for repository updates and package downloads.
- Sufficient disk space for extracted archives, databases, logs, and configuration files.
- A compatible PHP environment if required by the selected Radius Manager release.
- A compatible database server.
- A backup of existing RADIUS configuration and accounting data before upgrades.

## Installation

### 1. Download the scripts

Run the following commands on the target server:

```bash
curl -fL -o 1repoupdate.sh \
  https://github.com/redhatmurali/radius-dma/raw/main/1repoupdate.sh

curl -fL -o 2macupdate.sh \
  https://github.com/redhatmurali/radius-dma/raw/main/2macupdate.sh

curl -fL -o 3install.sh \
  https://github.com/redhatmurali/radius-dma/raw/main/3install.sh
```

### 2. Review the scripts

Before executing them as root, inspect their contents:

```bash
less 1repoupdate.sh
less 2macupdate.sh
less 3install.sh
```

Check for repository changes, package removals, configuration overwrites, external downloads, and service restarts.

### 3. Make the scripts executable

```bash
chmod +x 1repoupdate.sh 2macupdate.sh 3install.sh
```

### 4. Run the repository update script

```bash
sudo ./1repoupdate.sh
```

Proceed only after confirming that the script's repository configuration is appropriate for your operating system.

### 5. Run the additional update script

```bash
sudo ./2macupdate.sh
```

Review the script first to understand which components it updates and whether it modifies network or authentication settings.

### 6. Run the installer

```bash
sudo ./3install.sh
```

Follow the script's output and check for errors. This repository's README alone does not establish every installation step or guarantee that the scripts work on current distributions.

## Verify the Installation

Check whether FreeRADIUS is installed:

```bash
freeradius -v
```

On some distributions, the executable may be named `radiusd`:

```bash
radiusd -v
```

Check the service status:

```bash
sudo systemctl status freeradius --no-pager
```

If the service uses a different name:

```bash
sudo systemctl status radiusd --no-pager
```

Inspect recent logs:

```bash
sudo journalctl -u freeradius -n 100 --no-pager
```

Use the service name applicable to your distribution.

## Configuration and Security

Before using the installation in production:

- Back up existing FreeRADIUS configuration files and accounting databases.
- Restrict access to RADIUS authentication and accounting ports according to your network design.
- Protect shared secrets and database credentials.
- Avoid exposing administrative interfaces directly to the public internet.
- Verify that supported encryption and authentication methods are enabled.
- Confirm the compatibility and security status of legacy components.
- Test authentication and accounting in a controlled environment before migrating live subscribers.

## Troubleshooting

### Package repository errors

The repository update script may rely on distribution-specific package repositories. Check the operating-system version and review the script if a repository is unavailable or has reached end of life.

### FreeRADIUS fails to start

Check the service logs:

```bash
sudo journalctl -u freeradius -n 100 --no-pager
```

Validate the configuration using the debug mode supported by your installed FreeRADIUS version.

### PHP or ionCube compatibility problems

The included ionCube Loader archive is intended for a particular architecture. Verify that the loader supports your PHP version and runtime before enabling it.

### Database connection problems

Check the database service, connection settings, permissions, and credentials. Do not publish passwords, shared secrets, or other sensitive configuration in GitHub.

## Important Notice

This repository contains legacy installation components. Running old installation scripts on a modern or production server may introduce package conflicts, security risks, or service disruption.

Review and test the scripts in an isolated environment before executing them on a live ISP or subscriber network.

## License

Add a `LICENSE` file to specify the terms under which this repository may be used, modified, and redistributed.
