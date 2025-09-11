#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';

const workspaceRoot = path.resolve('/workspace');
const seedsPath = path.join(workspaceRoot, 'rails/db/seeds.rb');
const blogDir = path.join(workspaceRoot, 'astro/src/content/blog');
const assetsSrcDir = path.join(workspaceRoot, 'rails/app/assets/images');
const assetsDestDir = path.join(workspaceRoot, 'astro/src/assets');

/**
 * Utility: ensure directory exists
 */
function ensureDir(dir) {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
}

/**
 * Convert HTML content to Markdown-ish content per README guidelines.
 * - Convert <figure><img/></figure> with optional <p>caption</p>
 * - Convert <img>
 * - Convert <a>
 * - Convert <em>
 * - Convert <h3>
 * - Convert <p>
 * Leave iframes as-is (Astro Markdown supports raw HTML blocks).
 */
function htmlToMarkdown(html) {
  let s = html;
  // Unescape doubled single quotes from Ruby strings
  s = s.replace(/''/g, "'");

  // Normalize newlines
  s = s.replace(/\r\n/g, '\n');

  // Figures with caption
  s = s.replace(/<figure[^>]*>\s*<img[^>]*src='\/assets\/([^']+)'[^>]*alt='([^']*)'[^>]*>\s*(?:<p>([\s\S]*?)<\/p>)?\s*<\/figure>/g,
    (_, file, alt, caption) => {
      const img = `![${alt}](/images/${file})`;
      const cap = caption ? `\n_${caption.trim()}._` : '';
      return `${img}${cap}`;
    }
  );

  // Standalone <img>
  s = s.replace(/<img[^>]*src='\/assets\/([^']+)'[^>]*alt='([^']*)'[^>]*\/>/g, (_, file, alt) => `![${alt}](/images/${file})`);

  // Anchors
  s = s.replace(/<a\s+href='([^']+)'>([\s\S]*?)<\/a>/g, '[$2]($1)');

  // Headings h3
  s = s.replace(/<h3>([\s\S]*?)<\/h3>/g, (_, text) => `\n### ${text.trim()}\n`);

  // Emphasis
  s = s.replace(/<em>([\s\S]*?)<\/em>/g, '_$1_');

  // Paragraphs -> ensure blank line separation
  s = s.replace(/<p>\s*([\s\S]*?)\s*<\/p>/g, (_, text) => `\n${text.trim()}\n`);

  // Remove any remaining figure wrappers (rare edge)
  s = s.replace(/<figure[^>]*>/g, '').replace(/<\/figure>/g, '');

  // Replace any remaining src='/assets/...' occurrences in case of variants
  s = s.replace(/src='\/assets\//g, "src='/images/");

  // Collapse multiple blank lines
  s = s.replace(/\n{3,}/g, '\n\n');

  return s.trim() + '\n';
}

/**
 * Extract plain text from converted markdown-ish content for description.
 */
function extractDescription(md) {
  const withoutImages = md.replace(/!\[[^\]]*\]\([^\)]*\)/g, '');
  const withoutLinks = withoutImages.replace(/\[([^\]]+)\]\([^\)]*\)/g, '$1');
  const withoutMarkup = withoutLinks.replace(/[#*_`>]/g, '');
  const text = withoutMarkup.replace(/\s+/g, ' ').trim();
  const max = 180;
  return text.length <= max ? text : text.slice(0, max - 1).trim() + '…';
}

/**
 * Copy hero image into astro/src/assets if present.
 * Return relative heroImage path to use in frontmatter (../../assets/filename)
 */
function ensureHeroImage(filename) {
  if (!filename) return undefined;
  const src = path.join(assetsSrcDir, filename);
  const dest = path.join(assetsDestDir, filename);
  if (fs.existsSync(src)) {
    if (!fs.existsSync(dest)) {
      fs.copyFileSync(src, dest);
      console.log(`Copied hero image: ${filename}`);
    }
    return `../../assets/${filename}`;
  }
  // If not found in rails assets, maybe already exists in astro assets
  if (fs.existsSync(dest)) {
    return `../../assets/${filename}`;
  }
  return undefined;
}

function parseSeeds(content) {
  // Limit to the Article.create! array for safety
  const startIdx = content.indexOf('Article.create!');
  if (startIdx === -1) throw new Error('Could not find Article.create! in seeds.rb');
  const articlesSection = content.slice(startIdx);
  // Regex to capture each article block
  // Support title quoted with either single or double quotes
  const re = /\{\s*title:\s*(["'])(([\s\S]*?))\1,\s*slug:\s*'([^']+)',\s*header_image_html:\s*"([\s\S]*?)",\s*content_html:\s*"([\s\S]*?)",\s*publish_date:\s*'([^']+)'\s*\}/gm;
  const items = [];
  let m;
  while ((m = re.exec(articlesSection)) !== null) {
    const title = m[2];
    const slug = m[4];
    const headerHtml = m[5].replace(/''/g, "'");
    const contentHtml = m[6];
    const publishDate = m[7];
    // Extract hero image filename from headerHtml
    let hero = undefined;
    const mImg = headerHtml.match(/src='\/assets\/([^']+)'/);
    if (mImg) hero = mImg[1];
    items.push({ title, slug, hero, contentHtml, publishDate });
  }
  return items;
}

function toPubDate(dateStr) {
  // 'YYYY-MM-DD HH:MM:SS' => 'YYYY-MM-DD'
  const d = dateStr.split(' ')[0];
  return d;
}

function buildFrontmatter({ title, description, pubDate, heroImage }) {
  const fm = [
    '---',
    `title: ${JSON.stringify(title)}`,
    `description: ${JSON.stringify(description)}`,
    `pubDate: ${pubDate}`,
    ...(heroImage ? [`heroImage: ${heroImage}`] : []),
    '---',
    '',
  ];
  return fm.join('\n');
}

function main() {
  ensureDir(blogDir);
  ensureDir(assetsDestDir);
  const seeds = fs.readFileSync(seedsPath, 'utf8');
  const articles = parseSeeds(seeds);
  console.log(`Found ${articles.length} articles in seeds.rb`);

  let created = 0;
  for (const a of articles) {
    const outPath = path.join(blogDir, `${a.slug}.md`);
    if (fs.existsSync(outPath)) {
      console.log(`Skip (exists): ${a.slug}.md`);
      continue;
    }
    const mdBody = htmlToMarkdown(a.contentHtml);
    const description = extractDescription(mdBody) || a.title;
    const pubDate = toPubDate(a.publishDate);
    const heroImage = ensureHeroImage(a.hero);
    const fm = buildFrontmatter({ title: a.title, description, pubDate, heroImage });
    const finalContent = fm + mdBody;
    fs.writeFileSync(outPath, finalContent, 'utf8');
    created++;
    console.log(`Created: ${path.relative(workspaceRoot, outPath)}`);
  }

  console.log(`Done. Created ${created} posts.`);
}

main();

