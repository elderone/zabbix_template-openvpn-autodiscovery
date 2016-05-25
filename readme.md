# Zabbix Template - OpenVPN Autodiscovery

This is a simple Zabbix Template for OpenVPN with AutoDiscovery
It's aim to provide a simple health check to all OpenVPN client and server instances.

Please note that it not collects traffic data as the host which this template is linked probably already has it's network interfaces autodiscovered, so this data would be be redundant


## Install Instructions 
1.  Add the following UserParameters to zabbix_agentd.conf 
  ```
# OpenVPN Discovery rules
UserParameter=openvpn.list.discovery[*],sudo /usr/local/bin/openvpn_discovery.sh $1

# OpenVPN current sessions
UserParameter=openvpn.conn.status[*],echo "state" | sudo /bin/socat $1 stdio |grep -q CONNECTED,SUCCESS && echo 1 || echo 0
UserParameter=openvpn.server.clients[*],echo "load-stats" | sudo /socat $1 stdio | grep SUCCESS | cut -d= -f 2 |   cut -d, -f 1 || echo 0
  ```

2. Install socat utility
  ```
apt-get install socat
yum install socat
etc
  ```

3. Install sudo utility as socat will need root rights to get data from sockets.
  * Create a file named `/etc/suoders.d/zabbix` and add the lines below.
  ```
Defaults:zabbix !requiretty
zabbix ALL=(ALL) NOPASSWD: /bin/socat /var/run/openvpn/*.sock stdio
zabbix ALL=(ALL) NOPASSWD: /usr/local/bin/openvpn_discovery.sh CLIENT
zabbix ALL=(ALL) NOPASSWD: /usr/local/bin/openvpn_discovery.sh SERVER
  ```

4. Copy `openvpn_discovery.sh` into `/usr/local/bin/` and add executable permission
  ```
sudo chmod +x /usr/local/bin/openvpn_discovery.sh
  ```

5. Import the Zabbix template and link it to the desired host
