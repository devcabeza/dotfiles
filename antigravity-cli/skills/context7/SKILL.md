---
name: context7
description: "Always invoke when the user's message or task involves third-party libraries, frameworks, npm packages, or API documentation (e.g., React, Next.js, Tailwind CSS, Zod, Vitest, Playwright, Laravel, etc.). Also invoke when checking framework-specific syntax, syntax for hooks, components, routes, testing libraries, or configuration patterns. Skip for: internal custom modules, database queries on the local DB, local folder exploration, and general logic with no third-party library dependencies."
license: MIT
compatibility: opencode
metadata:
  author: opencode
  workflow: explorer
---

# Context7 MCP Integration Skill

This skill defines the protocol for using the **Context7 MCP Server** to retrieve accurate, up-to-date documentation and code examples for popular libraries and frameworks.

## Purpose

To prevent LLM hallucinations, outdated API usage, and code bloat by querying official, version-specific library documentation directly from the Context7 MCP server, rather than relying on generic web searches or browser automation.

## Available Tools

The `context7` MCP server provides the following tools:
1. `resolve-library-id`: Maps a query or library name (e.g., "react", "nextjs") to a recognized Context7 library ID.
2. `get-library-docs`: Retrieves specific documentation sections, guides, or code examples for a resolved library.

## Operational Workflow

When a task requires working with a third-party framework or library:

### 1. Identify & Resolve the Library
Extract the framework or library name mentioned in the task. Execute the `resolve-library-id` tool first to find the exact ID.
* *Example query:* `react-query` or `nextjs`.

### 2. Fetch Focused Documentation
Once you have the resolved library ID, retrieve the documentation using `get-library-docs`.
* **Important:** Try to target specific topics (e.g., "useQuery", "app-router", "after") to get only the relevant context, saving token space and improving response latency.

### 3. Apply Local Version Checks
When possible, check the project's local dependency files (e.g., [package.json](file:///package.json)) to determine the exact version installed, and request documentation matching that major version.

## Best Practices & Rules

- **First-Choice Doc Retrieval:** Always check `context7` before resorting to standard `web_search` or launching a Playwright browser instance (`playwright_browser_navigate`).
- **Reduce Token Bloat:** Avoid reading whole documentation files when only a specific API or hook is needed. Filter by topic keywords.
- **Code Fidelity:** Match the examples retrieved via `get-library-docs` to guarantee that code structures and import paths comply with the library's latest official standards.
