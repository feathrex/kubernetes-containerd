NS1="NS1"
NS2="NS2"
NODE_IP_TESTVM1="10.0.1.42"
BRIDGE_SUBNET_VM1="172.16.0.0/24"
BRIDGE_IP_VM1="172.16.0.1"
NS1_IP1_VM1="172.16.0.2"
NS2_IP1_VM1="172.16.0.3"
NODE_IP_TESTVM2="10.0.1.43"
BRIDGE_SUBNET_VM2="172.16.1.0/24"
BRIDGE_IP_VM2="172.16.1.1"
NS1_IP1_VM2="172.16.1.2"
NS2_IP1_VM2="172.16.1.3"


# Run on both testvm1 and testvm2
echo "Creating namespaces"
sudo ip netns add ${NS1}
sudo ip netns add ${NS2}

ip netns show

# Run on both testvm1 and testvm2
echo "Creating the virtual ethernet adapter pairs"
sudo ip link add veth10 type veth peer name veth11
sudo ip link add veth20 type veth peer name veth21

  ip link show type veth

# Run on both testvm1 and testvm2
echo "Adding the veth pairs to the namespaces"
sudo ip link set veth11 netns ${NS1}
sudo ip link set veth21 netns ${NS2}


echo "Configuring the interfaces in the network namespaces with IP addresses on testvm1."
sudo ip netns exec ${NS1} ip addr add ${NS1_IP1_VM1}/24 dev veth11
sudo ip netns exec ${NS2} ip addr add ${NS2_IP1_VM1}/24 dev veth21


echo "Configuring the interfaces in the network namespaces with IP addresses on testvm2."
sudo ip netns exec ${NS1} ip addr add ${NS1_IP1_VM2}/24 dev veth11
sudo ip netns exec ${NS2} ip addr add ${NS2_IP1_VM2}/24 dev veth21

# Run on both testvm1 and testvm2
echo "Enabling the interfaces inside the network namespaces."
sudo ip netns exec ${NS1} ip link set dev veth11 up
sudo ip netns exec ${NS2} ip link set dev veth21 up

# Run on both testvm1 and testvm2
echo "Creating the bridge"
sudo ip link add br0 type bridge
sudo ip link show type bridge
sudo ip link show br0

# Run on both testvm1 and testvm2
sudo echo "Adding the network namespaces interfaces to the bridge."
sudo ip link set dev veth10 master br0
sudo ip link set dev veth20 master br0

echo "Assigning the IP address to the bridge on testvm1"
sudo ip addr add ${BRIDGE_IP_VM1}/24 dev br0

echo "Assigning the IP address to the bridge on testvm2"
sudo ip addr add ${BRIDGE_IP_VM2}/24 dev br0

# Run on both testvm1 and testvm2
echo "Enabling the bridge"
sudo ip link set dev br0 up

# Run on both testvm1 and testvm2
echo "Enabling the interfaces connected to the bridge."
sudo ip link set dev veth10 up
sudo ip link set dev veth20 up

# Run on both testvm1 and testvm2
echo "Setting the loopback interfaces in the network namespaces."
sudo ip netns exec ${NS1} ip link set lo up
sudo ip netns exec ${NS2} ip link set lo up
sudo ip netns exec ${NS1} ip a
sudo ip netns exec ${NS2} ip a

echo "Setting the default route in the network namespaces on testvm1."
sudo ip netns exec ${NS1} ip route add default via ${BRIDGE_IP_VM1} dev veth11
sudo ip netns exec ${NS2} ip route add default via ${BRIDGE_IP_VM1} dev veth21

echo "Setting the default route in the network namespaces on testvm2."
sudo ip netns exec ${NS1} ip route add default via ${BRIDGE_IP_VM2} dev veth11
sudo ip netns exec ${NS2} ip route add default via ${BRIDGE_IP_VM2} dev veth21


# Run on testvm1
echo "Setting the route to the node to reach network namespaces on other VM."
sudo ip route add ${BRIDGE_SUBNET_VM2} via ${NODE_IP_TESTVM2} dev enp0s3

# Run on testvm2
echo "Setting the route to the node to reach network namespaces on other VM."
sudo ip route add ${BRIDGE_SUBNET_VM1} via ${NODE_IP_TESTVM1} dev enp0s3

# Run on both testvm1 and testvm2
echo "Enable IP forarding on the node."
sudo sysctl -w net.ipv4.ip_forward=1

# Testing

# Ping adaptor attached to NS1
sudo ip netns exec ${NS1} ping -W 1 -c 2 172.16.0.2

# Ping the bridge
sudo ip netns exec ${NS1} ping -W 1 -c 2 172.16.0.1

# Ping the adapter of the second container
sudo ip netns exec ${NS1} ping -W 1 -c 2 172.16.0.3

# Ping the other host testvm2
sudo ip netns exec ${NS1} ping -W 1 -c 2 10.0.1.43

# Ping the bridge on testvm2
sudo ip netns exec ${NS1} ping -W 1 -c 2 172.16.1.1

# Ping the first container on testvm2
sudo ip netns exec ${NS1} ping -W 1 -c 2 172.16.1.2

# Ping the second container on testvm2
sudo ip netns exec ${NS1} ping -W 1 -c 2 172.16.1.3


# Section 4 TCP tunnel setup ~48 minutes in video
#echo "Starts the UDP tunnel in the background"
#sudo socat UDP:${NODE_IP_TESTVM2}:9000,bind=${NODE_IP_TESTVM1}:9000 TUN:${TUNNEL_IP}/16,tun-name=tundudp,iff-no-pi,tun-type=tun &

#echo "Setting up the MTU on the tun interface"
#sudo ip link set dev tundudp mtu 1492

#echo "Disables reverse path filtering"
#sudo bash -c 'echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter'
#sudo bash -c 'echo 0 > /proc/sys/net/ipv4/conf/enp0s3/rp_filter'
#sudo bash -c 'echo 0 > /proc/sys/net/ipv4/conf/br0/rp_filter'
#sudo bash -c 'echo 0 > /proc/sys/net/ipv4/conf/tundudp/rp_filter'


