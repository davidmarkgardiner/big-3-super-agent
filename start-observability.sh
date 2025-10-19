#!/bin/bash
# Start Multi-Agent Observability System
# Convenience wrapper for the observability dashboard

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OBSERVABILITY_DIR="$SCRIPT_DIR/claude-code-hooks-multi-agent-observability"

echo "🔭 Starting Multi-Agent Observability Dashboard"
echo "================================================"
echo ""

# Check if Bun is available
if ! command -v bun &> /dev/null; then
    export PATH="$HOME/.bun/bin:$PATH"
    if ! command -v bun &> /dev/null; then
        echo "❌ Bun is not installed or not in PATH"
        echo "   Install it with: curl -fsSL https://bun.sh/install | bash"
        exit 1
    fi
fi

echo "✅ Bun found: $(which bun)"
echo ""

# Navigate to observability directory
cd "$OBSERVABILITY_DIR"

# Run the start script
./scripts/start-system.sh
