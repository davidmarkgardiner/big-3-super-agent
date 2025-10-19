#!/bin/bash
# Big Three Super Agent - Quick Start Script

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=================================================="
echo "  Big Three Super Agent - Quick Start"
echo "=================================================="
echo ""

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "❌ Error: .env file not found!"
    echo "Please create .env file with your API keys."
    echo "See .env.sample for reference."
    exit 1
fi

echo "Select startup mode:"
echo ""
echo "1. Content Generation App (Backend + Frontend)"
echo "2. Realtime Voice Agent (Voice Mode)"
echo "3. Realtime Voice Agent (Text Mode)"
echo "4. Both Services + Realtime Agent"
echo "5. Multi-Agent Observability Dashboard"
echo "6. Exit"
echo ""
read -p "Enter choice [1-6]: " choice

case $choice in
    1)
        echo ""
        echo "🚀 Starting Content Generation App..."
        echo ""
        cd apps/content-gen
        ./start.sh
        ;;
    2)
        echo ""
        echo "🎤 Starting Realtime Voice Agent (Voice Mode)..."
        echo "Press Ctrl+C to exit"
        echo ""
        uv run apps/realtime-poc/big_three_realtime_agents.py --voice
        ;;
    3)
        echo ""
        echo "💬 Starting Realtime Voice Agent (Text Mode)..."
        echo "Press Ctrl+C to exit"
        echo ""
        uv run apps/realtime-poc/big_three_realtime_agents.py --input text --output text
        ;;
    4)
        echo ""
        echo "🚀 Starting ALL services..."
        echo ""

        # Start content-gen in background
        cd apps/content-gen
        ./start.sh &
        CONTENT_GEN_PID=$!

        # Wait a bit for services to start
        sleep 3

        cd ../..

        echo ""
        echo "✅ Content Generation services started"
        echo "   Backend:  http://localhost:4444"
        echo "   Frontend: http://localhost:3333"
        echo ""
        echo "🎤 Starting Realtime Voice Agent..."
        echo ""

        # Start realtime agent in foreground
        uv run apps/realtime-poc/big_three_realtime_agents.py --voice

        # Cleanup when agent exits
        trap "kill $CONTENT_GEN_PID 2>/dev/null; exit" INT TERM EXIT
        ;;
    5)
        echo ""
        echo "🔭 Starting Multi-Agent Observability Dashboard..."
        echo ""
        ./start-observability.sh
        ;;
    6)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac
