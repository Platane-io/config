# @platane/config

Shared tooling config for [Platane](https://platane.io) projects: strict
[oxlint](https://oxc.rs/docs/guide/usage/linter) presets for our stack.

| Preset | For | Adds to `base` |
| --- | --- | --- |
| `oxlint/base.json` | Any TypeScript code | — |
| `oxlint/tanstack-start.json` | TanStack Start apps | react, jsx-a11y, hooks rules, browser + node env |
| `oxlint/payload.json` | Payload CMS (Next.js) apps | react, jsx-a11y, nextjs, `_status`-style fields, Payload's CSS import |
| `oxlint/node.json` | Node services and workers | node plugin, node env |

`base` enables the `correctness`, `suspicious`, `perf` and `pedantic`
categories as errors (minus `prefer-readonly-parameter-types`), plus
`no-console` (no exception), `node:` imports and no blanket disable comments. The vitest
plugin applies to `*.test.*` / `*.spec.*` files. `style` and `restriction` stay
off: formatting belongs to the formatter, the rest is taste.

## Usage

```sh
pnpm add -D -w oxlint oxlint-tsgolint @platane/config
```

Point each app at its preset with a nested config (`extends` takes file
paths, resolved from the config file):

```jsonc
// apps/www/.oxlintrc.json
{ "extends": ["../../node_modules/@platane/config/oxlint/tanstack-start.json"] }
```

Keep `options` and the ignore list in the **root** `.oxlintrc.json`: oxlint
only reads `options` there, and silently ignores them in an extended preset
(type-aware rules would quietly stop running).

```jsonc
// .oxlintrc.json
{
  "options": {
    "typeAware": true,
    "denyWarnings": true,
    "reportUnusedDisableDirectives": "error"
  },
  "ignorePatterns": ["apps/www/src/routeTree.gen.ts"]
}
```

Then `"lint": "oxlint"` at the repo root.

## Releasing

Bump `version` in `package.json`, merge, then publish a GitHub release tagged
`vX.Y.Z`: the `Publish` workflow runs the preset tests and publishes to npm
with provenance.
