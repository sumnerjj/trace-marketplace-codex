#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="${HOME}/.codex/plugins/session-logger"
MARKETPLACE_FILE="${HOME}/.agents/plugins/marketplace.json"

echo "Installing session-logger plugin for Codex..."

# Clone or update the plugin
if [ -d "$PLUGIN_DIR" ]; then
  echo "Updating existing installation..."
  cd "$PLUGIN_DIR" && git pull
else
  echo "Cloning plugin..."
  git clone https://github.com/sumnerjj/trace-marketplace-codex "$PLUGIN_DIR"
fi

# Ensure marketplace directory exists
mkdir -p "$(dirname "$MARKETPLACE_FILE")"

# Create or update marketplace.json
if [ -f "$MARKETPLACE_FILE" ]; then
  # Check if session-logger is already in the marketplace
  if jq -e '.plugins[] | select(.name == "session-logger")' "$MARKETPLACE_FILE" > /dev/null 2>&1; then
    echo "Plugin already registered in marketplace."
  else
    # Add plugin entry to existing marketplace
    jq '.plugins += [{
      "name": "session-logger",
      "source": {"source": "local", "path": "'"$PLUGIN_DIR/plugins/session-logger"'"},
      "policy": {"installation": "AVAILABLE", "authentication": "ON_FIRST_USE"},
      "category": "Observability"
    }]' "$MARKETPLACE_FILE" > "${MARKETPLACE_FILE}.tmp" && mv "${MARKETPLACE_FILE}.tmp" "$MARKETPLACE_FILE"
    echo "Plugin added to existing marketplace."
  fi
else
  # Create new marketplace file
  cat > "$MARKETPLACE_FILE" << MKTJSON
{
  "name": "personal-plugins",
  "interface": {
    "displayName": "Personal Plugins"
  },
  "plugins": [
    {
      "name": "session-logger",
      "source": {
        "source": "local",
        "path": "$PLUGIN_DIR/plugins/session-logger"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_FIRST_USE"
      },
      "category": "Observability"
    }
  ]
}
MKTJSON
  echo "Created marketplace at $MARKETPLACE_FILE"
fi

echo ""
echo "Done! Restart Codex to load the plugin."
echo "Debug log: ~/.codex/session-logger.log"
