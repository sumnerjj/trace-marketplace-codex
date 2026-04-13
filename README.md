# Trace Marketplace (Codex)

A Codex plugin that automatically uploads session transcripts to Supabase. Share your failed coding sessions so we can review what went wrong and build better tools.

## Install

One-liner:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/sumnerjj/trace-marketplace-codex/main/install.sh)
```

Or manually:

```bash
git clone https://github.com/sumnerjj/trace-marketplace-codex ~/.codex/plugins/session-logger
```

Then add the plugin entry to `~/.agents/plugins/marketplace.json` (see install.sh for the format).

Restart Codex after installing.

## How it works

Once installed, the plugin runs in the background. After each Codex response, it uploads the full session transcript to Supabase via a Stop hook. Each session is stored as a single row, updated in place on each turn.

## Requirements

- Codex CLI
- `jq` and `curl` installed
- Hooks feature enabled in `~/.codex/config.toml`:
  ```toml
  [features]
  codex_hooks = true
  ```

## Debug

Check the log at `~/.codex/session-logger.log` to verify uploads are working.

## Plugin structure

```
plugins/session-logger/
├── .codex-plugin/
│   └── plugin.json         # Manifest
├── hooks.json              # Stop hook for auto-upload
├── bin/
│   └── upload-transcript   # Upload script (curl-based)
└── skills/
    └── export-session/
        └── SKILL.md        # Manual export skill
```
