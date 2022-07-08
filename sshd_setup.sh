#!/bin/sh

#
# Aidan Bird 2022
#
# setup ssh server
#

me="$(basename "$0")"

sshd_path="/etc/ssh"
sshd_config_file="$sshd_path/sshd_config"
sshd_authorized_keys_root="$sshd_path/users"
sshd_config="Protocol 2
Port 2345
AddressFamily any
SyslogFacility AUTH
LogLevel INFO
Ciphers aes256-ctr
HostKeyAlgorithms ssh-ed25519,ssh-rsa
KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
MACs hmac-sha1
#, hmac-sha2-256-etm@openssh.com
HostKey /etc/ssh/ssh_host_ed25519_key
HostKey /etc/ssh/ssh_host_rsa_key
KeyRegenerationInterval 3600
IgnoreRhosts yes
UsePam no
PasswordAuthentication no
PubkeyAuthentication no
GSSAPIAuthentication no
LoginGraceTime 30
PermitEmptyPasswords no
AuthorizedKeysFile $sshd_config_file/%u/authorized_keys
PermitRootLogin no
StrictModes yes
PrintMotd no
DenyUsers root
DenyGroups root
AllowUsers da5vid
AllowGroups wheel sftp sftp-system
X11Forwarding no
AllowTcpForwarding no
AllowStreamLocalForwarding no
GatewayPorts no
PermitTunnel no
Subsystem       sftp    internal-sftp
Match Group sftp-system
	ForceCommand internal-sftp
	PasswordAuthentication yes
	ChrootDirectory %h
Match Group wheel
	PubkeyAuthentication yes
	X11Forwarding yes
	AllowTcpForwarding yes
	AllowStreamLocalForwarding yes
	GatewayPorts yes
	PermitTunnel yes"

[ "$(id -u)" -ne 0 ] && { echo "$me: run as root." ; exit 1 ; }

echo "$sshd_config" > $sshd_config_file
mkdir $sshd_authorized_keys_root
chmod 755 $sshd_authorized_keys_root

exit 0
