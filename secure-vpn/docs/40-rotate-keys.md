# Rotate WireGuard keys

If you suspect exposure, rotate keys immediately:

1) Stop service:
```bash
sudo systemctl stop wg-quick@wg0
```

2) Generate new keys (server + client), update `/etc/wireguard/wg0.conf`.

3) Restart:
```bash
sudo systemctl start wg-quick@wg0
sudo wg show
```

4) Replace the client config on your device.
