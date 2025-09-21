2025-09-21

# Plan: Migrate liz-hadley-therapy-rails → Astro (lth) with Tailwind

## Scope and pages
- Pages: `/`, `/about`, `/focus-areas`, `/faq`, `/resources`, `/contact`
- Shared layout: header with active nav; footer with CTA hidden on `/contact`
- Fonts: Google Fonts (Crimson Text, Jost)
- Assets: copy from `liz-hadley-therapy-rails/app/assets/images/*`
- No dynamic features: contact is a `mailto:` link; no forms/mailers

## Target project
- Use existing Astro project at `lht/`
- Ensure Tailwind is installed and configured
- Configure `site` in `lht/astro.config.mjs` and add `@astrojs/sitemap`

## Tailwind design system
- Theme
  - font-sans: Jost; font-serif: Crimson Text
  - Simple neutral palette + one accent matching current brand imagery
  - Enable `@tailwindcss/typography` for long-form content
- Base
  - Set global fonts in Tailwind `theme.extend.fontFamily`
  - Use `prose` for content-heavy sections (About, FAQ)

## Information architecture & routing
- Structure
  - `src/layouts/BaseLayout.astro`
  - `src/components/Header.astro`, `Footer.astro`, `NavLink.astro`
  - `src/pages/index.astro`, `about.astro`, `focus-areas.astro`, `faq.astro`, `resources.astro`, `contact.astro`
  - `public/images/*` copied from Rails images
- URLs mirror Rails; add redirects for legacy `/about/index` etc.

## Layout & navigation
- `BaseLayout.astro` supplies `<head>` (fonts, meta, OG/Twitter)
- Active nav via `Astro.url.pathname`
- Footer CTA rendered on all pages except `/contact`

## Page implementations (content parity, Tailwind utilities)
- Home: hero title/subtitle; plant imagery; integrative psychotherapy text block
- About: three blocks w/ images and quote; responsive grid/flex
- Focus Areas: image + text + bullet list
- FAQs: fees; where/how we meet; insurance; what to expect; use `prose`
- Resources: crisis resources list with external links (`rel="noopener"`)
- Contact: title + paragraph with `mailto:liz@lizhadleytherapy.com` and link to `/resources`

## Assets & performance
- Copy images to `lth/public/images`
- Prefer `.webp` variants where easy; add explicit `width`/`height`, `loading="lazy"`
- Optionally use `astro:assets` `<Image />` for optimization

## SEO & metadata
- Per-page titles/descriptions
- OG/Twitter meta in layout with overridable props
- Add sitemap via `@astrojs/sitemap`; include `robots.txt`; canonical from `site`
- Favicon/touch icons in `public/`

## Implementation checklist
- [ ] Install/configure Tailwind in `lht/` (typography plugin included)
- [ ] Add BaseLayout with font links and meta helpers
- [ ] Build Header/Nav with active-state utility classes
- [ ] Build Footer with CTA; hide on `/contact`
- [ ] Implement pages with content parity, responsive Tailwind layouts
- [ ] Migrate images to `public/images` and update references
- [ ] Add SEO tags, sitemap, robots
