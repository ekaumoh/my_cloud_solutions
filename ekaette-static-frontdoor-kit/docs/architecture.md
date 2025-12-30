# Architecture – ekaetteumoh.cloud static site

## Components

- **Browser / Client**
- **Azure Front Door Standard/Premium**
- **Azure Storage Account (Static website enabled)**
- **Azure DNS Zone for ekaetteumoh.cloud**
- **Registrar (Namecheap)** for domain ownership

## Flow

```text
User -> https://ekaetteumoh.cloud
  -> Azure DNS zone (A alias record for @ to Front Door)
    -> Azure Front Door endpoint (ekaettefd.*.azurefd.net)
      -> Origin group
        -> Storage static website endpoint (https://<account>.z13.web.core.windows.net/)
          -> index.html (+ CSS/JS)
```

### Why each piece exists

- **Storage static website**
  - Cheap, serverless hosting for HTML/CSS/JS.
- **Front Door**
  - Global entry point, caching, TLS termination, custom domains.
- **Azure DNS**
  - Lets you use an **alias A record** for the root (`@`) to the Front Door endpoint.
- **Registrar**
  - Where you bought the domain; its job is to point the nameservers to Azure.

