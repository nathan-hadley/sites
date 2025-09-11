# nathanhadley site

This repo contains a static Astro blog (`astro/`) migrated from a legacy Rails app (`rails/`). Posts are Markdown files with image assets reused from the Rails app and copied to the Astro project.

## Quick start

- Node 20+ recommended (works on Node 18+, CI uses current LTS)
- From `astro/`:
  - `npm install`
  - `npm run dev` → http://localhost:4321
  - `npm run build` → outputs to `astro/dist`
  - `npm run preview` → serve the production build locally

## Content authoring

Posts live at:

- `astro/src/content/blog/*.md`

Frontmatter:

```yaml
---
title: Post Title
description: One sentence summary
pubDate: YYYY-MM-DD
heroImage: ../../assets/hero-file.jpg
---
```

Guidelines:

- Use plain Markdown for headings, paragraphs, and images.
- Images inside the body should reference public paths: `![alt](/images/filename.jpg)`
- If a caption is needed, place it immediately on the next line in italics:
  
  ```md
  ![Jasna on P7](/images/HADLEY-Jasna-on-P7-Deep-Blue.jpg)
  _Jasna on P7 (5.12+)._ 
  ```
- Keep hero images horizontal; copy hero files into `astro/src/assets/` and reference via `heroImage` in frontmatter.

## Images

- Legacy images live under `rails/app/assets/images/` and were copied to `astro/public/images/`.
- Body images should use `/images/...` (served from `astro/public`).
- Hero images must be placed in `astro/src/assets/` so Astro can optimize them and be referenced via `heroImage` in frontmatter.

Common operations:

```sh
# copy a legacy image to public for body use
cp rails/app/assets/images/FILE.jpg astro/public/images/FILE.jpg

# copy a horizontal hero image to src/assets
cp rails/app/assets/images/HERO.jpg astro/src/assets/HERO.jpg
```

## Layout & styling

- Shared layout: `astro/src/layouts/SiteLayout.astro` (sidebar + content)
- Post layout styles use Tailwind Typography (`prose` classes)
- Global styles: `astro/src/styles/global.css`
- Sidebar: `astro/src/components/Sidebar.astro`

