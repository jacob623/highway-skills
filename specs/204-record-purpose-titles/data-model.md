# Data Model: Record Purpose Titles

## Decision title (read only)

| Part | Rule |
|---|---|
| Lead | A leading `Adopt`, matched without regard to case. Removed |
| Product | Text before the first ` for `, matched without regard to case |
| Purpose | Text after the first ` for ` |

## Architecture title

| Case | Title |
|---|---|
| Person supplied a title that names no product | That title |
| Purpose present | The purpose, with its first letter capitalized |
| No ` for `, Selected Option name in the title | The remaining title without that name |
| No ` for `, no such name | The remaining title |
| Empty, or names the product | Ask for a purpose title. Write nothing until one is given |

## Implementation title

| Case | Title |
|---|---|
| Person supplied a title | That title |
| Product present | The product, with its first letter capitalized |
| No ` for `, Selected Option name in the title | That name |
| No ` for `, no such name | The remaining title |
| Same title on an implementation of a different architecture | `[Product] for [purpose]` |
| That is also taken | The existing `title` step |
| Same title under the same architecture | Reuse that record |

## Worked examples

| Decision | Architecture | Implementation |
|---|---|---|
| Adopt Notion for teacher scheduling | Teacher scheduling | Notion |
| Adopt Flodesk for the community newsletter | The community newsletter | Flodesk |
| Adopt Sawyer for class registration, class payments, and family records | Class registration, class payments, and family records | Sawyer |
| Adopt Shopify for online kit sales, kit payments, and the website | Online kit sales, kit payments, and the website | Shopify |
| Adopt Amazon for marketplace kit sales and kit order fulfillment | Marketplace kit sales and kit order fulfillment | Amazon |
| Adopt Cursor for AI-assisted engineering and planning | AI-assisted engineering and planning | Cursor |
| Adopt the factory for kit prototypes | Kit prototypes | The factory |
| Adopt Time Machine and Google Drive for MacBook backups | MacBook backups | Time Machine and Google Drive |
| Adopt local MacBook design apps for kit design | Kit design | Local MacBook design apps |
