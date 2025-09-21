import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const stories = defineCollection({
  // Load Markdown and MDX files in the `src/content/stories/` directory.
  loader: glob({ base: './src/content/stories', pattern: '**/*.{md,mdx}' }),
  // Type-check frontmatter using a schema
  schema: ({ image }) =>
    z.object({
      title: z.string(),
      description: z.string(),
      // Transform string to Date object
      pubDate: z.coerce.date(),
      updatedDate: z.coerce.date().optional(),
      heroImage: image().optional(),
    }),
});

const software = defineCollection({
  // Load Markdown and MDX files in the `src/content/software/` directory.
  loader: glob({ base: './src/content/software', pattern: '**/*.{md,mdx}' }),
  // Use the same schema as stories
  schema: ({ image }) =>
    z.object({
      title: z.string(),
      description: z.string(),
      pubDate: z.coerce.date(),
      updatedDate: z.coerce.date().optional(),
      heroImage: image().optional(),
    }),
});

export const collections = { stories, software };
