# Troubleshooting log – what went wrong and how to fix it

## 1. Domain stuck in "Pending" validation

**Symptoms**

- Front Door Domains blade shows:
  - Validation state: `Pending`
  - Certificate state: `Domain validation needed`
- TXT record health in the side panel shows as correct.
- `nslookup` from Cloud Shell returns `NXDOMAIN`:

  ```bash
  nslookup ekaetteumoh.tech
  nslookup -type=TXT _dnsauth.ekaetteumoh.tech
  ```

**Root cause**

The *registrar* (Namecheap) was still pointing the domain to **old** DNS servers.  
The nameservers in Namecheap did **not** match the Azure DNS zone NS records.

So Azure Front Door was checking the public DNS for `_dnsauth.*` and getting `NXDOMAIN`.

**Fix**

1. In Azure DNS zone, note NS records:

   ```text
   ns1-09.azure-dns.com
   ns2-09.azure-dns.net
   ns3-09.azure-dns.org
   ns4-09.azure-dns.info
   ```

2. In Namecheap, under **Nameservers**, choose **Custom DNS** and paste those four values.

3. Wait for propagation (can take up to 24–48 hours globally, usually faster):

   ```bash
   nslookup -type=NS ekaetteumoh.cloud
   ```

4. Once `nslookup` shows the Azure NS servers, re‑check:

   ```bash
   nslookup -type=TXT _dnsauth.ekaetteumoh.cloud
   ```

5. Go back to Front Door → Domains and hit **Refresh**; validation completes.

---

## 2. `*.azurefd.net` endpoint shows "Page not found"

**Symptoms**

- Visiting the Front Door endpoint returns the blue Azure "Page not found" cloud screen.

**Root cause**

- Route not correctly linked:
  - No domain selected for the route, or
  - Origin group misconfigured, or
  - Static website not yet enabled.

**Fix checklist**

1. Storage Account → **Static website**
   - Status: `Enabled`
   - Index document name: `index.html`
   - Upload `index.html` to `$web`.

2. Front Door → **Origin groups**
   - Origin host name: `<storage-account>.z13.web.core.windows.net`
   - Health probe path: `/`.

3. Front Door → **Routes**
   - Endpoint: your `*.azurefd.net` endpoint.
   - Domains: that same endpoint selected.
   - Patterns: `/*`.
   - Origin group: the group that points to storage.
   - Forwarding protocol: `HTTPS only`.

After saving, wait a minute and refresh the endpoint.

---

## 3. `nslookup` returns NXDOMAIN for the new domain

Just confirm:

- Domain is actually **registered** (you own it).
- Registrar nameservers match Azure DNS NS records.
- You gave DNS enough time to propagate.

