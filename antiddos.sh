#!/bin/bash

sudo apt install -y ufw
sudo ufw allow proto tcp from any to any
sudo ufw allow proto udp from any to any
sudo ufw default allow outgoing
sudo ufw enable
sudo service fastnetmon start
sudo systemctl start fastnetmon
sudo service fastnetmon restart
sudo systemctl restart fastnetmon
echo "======| Fastnetmon and UFW is Enabled/Restarted |======"
sleep 5
# Configure FastNetMon settings
sudo fcli set main networks_list 11.22.33.0/22
sudo fcli set main networks_list 0.0.0.0/1
sudo fcli set main networks_list 127.0.0.1/1
sudo fcli set main networks_list beef::1/64
sudo fcli commit
echo "======| Finished network list |======="
sleep 5

sudo fcli set main netflow enable
sudo fcli set main netflow_ports 2055
sudo fcli set main netflow_host 0.0.0.0
sudo fcli set main netflow_host ::
sudo fcli commit
sudo service fastnetmon restart
sudo systemctl restart fastnetmon
echo "======| Finished netflow main set |======"
sleep 5

# Update and install Softflowd
sudo apt update
sudo apt install -y softflowd

# Start Softflowd with specified interface and collector
sudo softflowd -i eth0 -n 127.0.0.1:2055

# Add NetFlow configuration to FastNetMon config file
echo -e "netflow = on\nnetflow_port = 2055" | sudo tee -a /etc/init/fastnetmon.conf

echo "======| Installed Netflow |======"
sleep 5
# Start and restart FastNetMon service
sudo service fastnetmon start
sudo service fastnetmon restart
sudo systemctl restart fastnetmon

# Define the fastnetmon configuration
FASTNETMON_CONF="/etc/init/fastnetmon.conf"

# Add netflow settings to fastnetmon configuration file
echo -e "netflow = on\nnetflow_port = 2055" | sudo tee -a $FASTNETMON_CONF

# Update package lists
sudo apt-get update

# Install pmacct
sudo apt-get install -y pmacct

# Define the pmacct configuration
PMACCT_CONF="/etc/pmacct/pmacctd.conf"

# Add settings to pmacct configuration file
echo -e "plugins: nfprobe\nnfacctd_port: 2055" | sudo tee -a $PMACCT_CONF

# Start pmacctd with the specified interface and configuration file
sudo pmacctd -i eth0 -f $PMACCT_CONF

# Enable and start Softflowd service
sudo systemctl enable fastnetmon
sudo systemctl start fastnetmon
sudo service fastnetmon enable
sudo service fastnetmon restart
sudo service fastnetmon restart
sudo fcli commit
sudo systemctl daemon-reload

echo "======| Configured pmacct |======"
sleep 5

sudo fcli set main netflow_sampling_ratio 1
sudo fcli commit

sudo fcli set main average_calculation_time 45
sudo fcli commit

sudo fcli set main netflow_count_packets_per_device true
sudo fcli commit

sudo fcli set main netflow_socket_read_mode recvmsg
sudo fcli commit

sudo fcli set main netflow_multi_thread_processing true
sudo fcli set main netflow_threads_per_port 2
sudo fcli commit

sudo fcli set main netflow_multi_thread_mode random
sudo fcli commit
sudo service fastnetmon restart
sudo systemctl restart fastnetmon
echo "======| Finished netflow configuration |======"
sleep 5
# Install and configure UFW

sudo service fastnetmon restart
sudo systemctl softflowd restart
sudo fastnetmon_client
