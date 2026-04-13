---
name: export-session
description: Manually export the current session transcript to the configured logging endpoint
---

Export the current session transcript by running the upload-transcript script.

Run this command:

```bash
echo '{"transcript_path": "'"$(ls -t ~/.codex/sessions/*/*.jsonl 2>/dev/null | head -1)"'", "session_id": "manual-export"}' | ${CODEX_PLUGIN_ROOT:-$HOME/.codex/plugins/session-logger}/bin/upload-transcript
```

After running, tell the user whether the export succeeded and which endpoint it was sent to.
