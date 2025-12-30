# Manual WireGuard setup (recommended)

> Goal: keep the repo GitHub-safe while still letting you practice the real install.

## 1) SSH to the server
Use the Terraform output `ssh_connection`.

## 2) Install packages
```bash
sudo apt-get update
sudo apt-get install -y wireguard iptables qrencode
```

## 3) Enable IP forwarding
```bash
echo 'net.ipv4.ip_forward=1' | sudo tee /etc/sysctl.d/99-wireguard.conf
sudo sysctl --system
```

## 4) Create keys (server + one client)
```bash
sudo umask 077
sudo mkdir -p /etc/wireguard
cd /etc/wireguard

sudo wg genkey | sudo tee server.key | sudo wg pubkey | sudo tee server.pub
sudo wg genkey | sudo tee client1.key | sudo wg pubkey | sudo tee client1.pub
```

## 5) Create server config
```bash
SERVER_PRIV=$(sudo cat /etc/wireguard/server.key)
CLIENT1_PUB=$(sudo cat /etc/wireguard/client1.pub)

sudo tee /etc/wireguard/wg0.conf >/dev/null <<EOF
[Interface]
Address = 10.8.0.1/24
ListenPort = 51820
PrivateKey = ${SERVER_PRIV}

PostUp   = iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
PostDown = iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE; iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT

[Peer]
PublicKey = ${CLIENT1_PUB}
AllowedIPs = 10.8.0.2/32
EOF

sudo chmod 600 /etc/wireguard/wg0.conf
```

## 6) Start WireGuard
```bash
sudo systemctl enable wg-quick@wg0
sudo systemctl start wg-quick@wg0
sudo wg show
```

## 7) Build client config (on the server, then copy securely)

Get the server public key and server public IP:
```bash
SERVER_PUB=$(sudo cat /etc/wireguard/server.pub)
CLIENT1_PRIV=$(sudo cat /etc/wireguard/client1.key)
PUBLIC_IP=$(curl -s https://api.ipify.org)
```

Create a client file in your home dir (NOT in git):
```bash
cat > ~/client1.conf <<EOF
[Interface]
Address = 10.8.0.2/24
PrivateKey = ${CLIENT1_PRIV}
DNS = 1.1.1.1

[Peer]
PublicKey = ${SERVER_PUB}
Endpoint = ${PUBLIC_IP}:51820
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
EOF

chmod 600 ~/client1.conf
```

Optional QR for mobile:
```bash
qrencode -t ansiutf8 < ~/client1.conf
```

Copy `client1.conf` to your Mac securely (example):
```bash
# run on your Mac:
scp azureuser@<PUBLIC_IP>:~/client1.conf .
```
