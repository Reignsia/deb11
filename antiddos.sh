#!/bin/bash

sudo systemctl restart fastnetmon

# Configure FastNetMon settings
sudo fcli set main networks_list 11.22.33.0/22
sudo fcli set main networks_list 0.0.0.0/1
sudo fcli set main networks_list 127.0.0.1/1
sudo fcli set main networks_list beef::1/64
sudo fcli commit

sudo fcli set main netflow enable
sudo fcli set main netflow_ports 2055
sudo fcli set main netflow_host 0.0.0.0
sudo fcli set main netflow_host ::
sudo fcli commit

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

# Update and install Softflowd
sudo apt update
sudo apt install -y softflowd

# Start Softflowd with specified interface and collector
sudo softflowd -i eth0 -n 127.0.0.1:2055

# Add NetFlow configuration to FastNetMon config file
echo -e "netflow = on\nnetflow_port = 2055" | sudo tee -a /etc/init/fastnetmon.conf

# Start and restart FastNetMon service
sudo service fastnetmon start
sudo service fastnetmon restart

# Create Softflowd systemd service file
sudo bash -c 'cat <<EOF > /etc/systemd/system/softflowd.service
[Unit]
Description=Softflowd NetFlow Exporter
After=network.target

[Service]
ExecStart=/usr/sbin/softflowd -i eth0 -n 127.0.0.1:2055
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF'

# Enable and start Softflowd service
sudo systemctl enable softflowd
sudo systemctl start softflowd

# Install and configure UFW
sudo apt install -y ufw
sudo ufw allow proto tcp from any to any
sudo ufw allow proto udp from any to any
sudo ufw default allow outgoing
sudo ufw enable
sudo service fastnetmon restart
sudo systemctl softflowd restart
sudo fastnetmon_client
