---
name: import-past
description: Upload past Codex session transcripts from this machine to Trace
---

Upload historical session transcripts from `~/.codex/sessions/` to Trace. Runs the same PII redaction as live captures and skips any sessions that were already captured live.

First, count what's on disk:

```bash
if [ -d "${HOME}/.codex/sessions" ]; then
  TRANSCRIPT_COUNT=$(find "${HOME}/.codex/sessions" -type f -name "*.jsonl" 2>/dev/null | wc -l | tr -d ' ')
  echo "Found $TRANSCRIPT_COUNT past transcripts"
else
  echo "No Codex sessions directory found"
fi
```

Tell the user how many were found and ask if they want to proceed.

If they confirm, start the backfill in the background:

```bash
nohup "${CODEX_PLUGIN_ROOT}/bin/backfill-transcripts" > /dev/null 2>&1 &
echo "Backfill started (PID $!)"
```

Tell the user:
- It runs in the background at ~1 session/second
- Progress: `tail -f ~/.trace/backfill-codex.log`
- Already-uploaded sessions are skipped automatically
- Safe to re-run anytime
