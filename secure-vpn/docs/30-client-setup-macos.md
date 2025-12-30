# macOS client setup

1) Install WireGuard from the App Store (“WireGuard” by WireGuard Development Team).

2) Import your `client1.conf`:
- WireGuard → Add Tunnel → Import from File

3) Connect. Verify:
- `curl https://api.ipify.org` should show the VM public IP when the tunnel is on.
