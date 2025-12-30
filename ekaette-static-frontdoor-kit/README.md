# ekaetteumoh.cloud – Static Resume Site on Azure Front Door

This repo contains the source code and Azure notes for publishing **ekaetteumoh.cloud** as a static website using:

- Azure Storage (static website hosting)
- Azure Front Door Standard/Premium
- Azure DNS (zone hosted in Azure)
- Third‑party registrar (Namecheap)

The goal: a **clean, reproducible template** you can reuse for other domains.

---

## 1. Repo structure

```text
.
├── README.md
├── .gitignore
├── docs
│   ├── architecture.md
│   ├── dns-and-frontdoor-notes.md
│   └── troubleshooting.md
└── src
    ├── index.html
    ├── styles.css
    └── script.js
```

- `src/` – front‑end code for the static site.
- `docs/architecture.md` – high‑level architecture and flow.
- `docs/dns-and-frontdoor-notes.md` – exact DNS + Front Door steps.
- `docs/troubleshooting.md` – issues you actually hit and how to fix them.

---

## 2. How to use this kit

### 2.1. Run this exact site

1. **Upload `src` to your Storage Account**

   - In the Azure Portal, go to your Storage Account → **Static website**.
   - Make sure it’s **Enabled** and `index.html` is the index document.
   - Open **$web** container and upload:
     - `index.html`
     - `styles.css`
     - `script.js`

2. **Confirm the Storage static website works**

   - Grab the **Primary endpoint**, something like:

     `https://<account>.z13.web.core.windows.net/`

   - Open it in a browser – you should see your resume site.

3. **Make sure Front Door is pointing at this origin**

   - Azure Front Door profile → **Origin groups** → default group.
   - Origin host: your storage static endpoint (`*.z13.web.core.windows.net`).
   - Health probe path: `/`.

   - **Routes**
     - Endpoint: your `*.azurefd.net` endpoint.
     - Domain: that same endpoint selected.
     - Patterns: `/*`.
     - Forwarding protocol: `HTTPS only`.
     - Redirect all traffic to HTTPS: enabled.

4. **Test the Front Door endpoint**

   - Browse to your `*.azurefd.net` hostname.
   - You should see the same resume site.

5. **Wire your custom domain (e.g., ekaetteumoh.cloud)**

   - Make sure your **registrar nameservers** point at Azure DNS.
   - In Azure DNS zone:
     - `A` record for `@` with **alias** to the Front Door endpoint.
     - `CNAME` for `www` → `your-endpoint.azurefd.net`.

   - In Front Door → **Domains**:
     - Add `ekaetteumoh.cloud` and `www.ekaetteumoh.cloud`.
     - Use AFD‑managed certificates.
     - Let TXT validation finish.
     - Associate the validated domains to your endpoint routes.

6. **Final tests**

   - `https://ekaetteumoh.cloud`
   - `https://www.ekaetteumoh.cloud`

   Both should show your static resume site via Front Door.

---

## 3. Reusing this project

When you want to stand this up for another person, you can:

1. **Clone this repo** to a new folder.
2. Update:
   - `index.html` content (their name, links, sections).
   - Any branding colors in `styles.css`.
3. Create:
   - New resource group.
   - New Storage Account.
   - New Front Door profile.
   - New DNS zone + custom domain records.
4. Follow `docs/dns-and-frontdoor-notes.md` exactly, swapping:
   - Domain name.
   - Storage account name.
   - Front Door profile / endpoint names.

---

## 4. What you can showcase on GitHub

In your repo description:

> Static resume site for ekaetteumoh.cloud running on Azure Storage + Azure Front Door with Azure‑hosted DNS. Includes full DNS + Front Door notes and troubleshooting steps I actually hit (TXT validation, nameserver mismatch, alias A record to Front Door, etc.).

This shows:

- Hands‑on Azure Storage (static websites).
- Hands‑on Azure Front Door Standard/Premium.
- DNS, registrar + Azure DNS zone integration.
- Real troubleshooting and logs.

