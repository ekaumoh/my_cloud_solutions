# DNS & Front Door Notes

## 1. Registrar → Azure DNS

1. In Namecheap, set **Nameservers** to:

   ```text
   ns1-09.azure-dns.com
   ns2-09.azure-dns.net
   ns3-09.azure-dns.org
   ns4-09.azure-dns.info
   ```

2. Wait for delegation to propagate; you can check from Cloud Shell:

   ```bash
   nslookup -type=NS ekaetteumoh.cloud
   ```

   When it works, you should see the Azure DNS nameservers above.

## 2. Azure DNS records

In the `ekaetteumoh.cloud` zone:

1. **A record for root (`@`)**

   - Type: `A`
   - Alias record set: **Yes**
   - Alias type: Azure resource
   - Target: your **Front Door endpoint** (`ekaettefd` for the `ekaettefrontdoor` profile).
   - TTL: 300 seconds (5 minutes).

2. **CNAME for www**

   - Name: `www`
   - Type: `CNAME`
   - TTL: 3600 (1 hour)
   - Value: your `*.azurefd.net` hostname.

3. **TXT for domain validation**

   For each domain you add in Front Door (`ekaetteumoh.cloud` and `www.ekaetteumoh.cloud`):

   - Front Door gives you:
     - Record name (like `_dnsauth.ekaetteumoh.cloud`)
     - Record value (a long token string)
   - Add them as **TXT** records in the Azure DNS zone.
   - Keep them as long as you want Front Door to keep managing the cert.

## 3. Front Door domains & certificates

1. Front Door profile → **Domains** → Add:

   - `ekaetteumoh.cloud`
   - `www.ekaetteumoh.cloud`

2. For each domain:
   - Choose **AFD managed** certificate.
   - Copy the TXT instructions.
   - Once DNS propagates, the **validation state** becomes *Approved*.
   - Certificate state moves from *Certificate needed* to *Deployed*.

3. Associate both domains to your Front Door endpoint in the **Route** config.

