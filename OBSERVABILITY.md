# Multi-Agent Observability Setup Guide

## Overview

Your Big Three Super Agent project is now configured with real-time observability! This system captures, stores, and visualizes all Claude Code agent activities through comprehensive hook event tracking.

**Watch a [full breakdown here](https://youtu.be/9ijnN985O_c)**

## What's Included

The observability system monitors:
- 🔧 **PreToolUse** - Before each tool execution
- ✅ **PostToolUse** - After tool completion
- 🔔 **Notification** - User interactions
- 💬 **UserPromptSubmit** - Every user prompt
- 🛑 **Stop** - Response completions with chat transcripts
- 👥 **SubagentStop** - Subagent completions
- 📦 **PreCompact** - Context compaction events
- 🚀 **SessionStart** - Session initiated
- 🏁 **SessionEnd** - Session completed

## Quick Start

### Option 1: Interactive Launcher
```bash
./quick-start.sh
# Select option 5: Multi-Agent Observability Dashboard
```

### Option 2: Direct Start
```bash
./start-observability.sh
```

### Option 3: Manual Start
```bash
cd claude-code-hooks-multi-agent-observability
./scripts/start-system.sh
```

## Access the Dashboard

Once started, open your browser to:
- **Dashboard**: http://localhost:5173
- **Server API**: http://localhost:4000
- **WebSocket**: ws://localhost:4000/stream

## Architecture

```
Claude Code Agents → Hook Scripts → HTTP POST → Bun Server → SQLite → WebSocket → Vue Dashboard
```

### Data Flow

1. **Event Generation**: Claude Code executes an action (tool use, notification, etc.)
2. **Hook Activation**: Hook script runs based on `.claude/settings.json` configuration
3. **Data Collection**: Hook script gathers context (tool name, inputs, outputs, session ID)
4. **Transmission**: `send_event.py` sends JSON payload to server via HTTP POST
5. **Server Processing**: Validates event, stores in SQLite, broadcasts via WebSocket
6. **Dashboard Update**: Vue app receives event and updates timeline in real-time

## Configuration

### Your Project Configuration

The `.claude/settings.json` is already configured with:
- **Source App**: `big-3-super-agent`
- **All Hook Types**: PreToolUse, PostToolUse, Notification, Stop, SubagentStop, PreCompact, UserPromptSubmit, SessionStart, SessionEnd
- **AI Summarization**: Enabled with `--summarize` flag on relevant hooks

### Hook Script Locations

All hook scripts are in `.claude/hooks/`:
- `send_event.py` - Universal event sender to observability server
- `pre_tool_use.py` - Tool validation & blocking dangerous commands
- `post_tool_use.py` - Result logging
- `notification.py` - User interaction tracking
- `user_prompt_submit.py` - User prompt logging
- `stop.py` - Session completion with chat history
- `subagent_stop.py` - Subagent completion tracking
- `session_start.py` - Session start logging
- `session_end.py` - Session end logging

## Dashboard Features

### Visual Design
- **Dual-color system**: App colors (left border) + Session colors (second border)
- **Dark/light theme** support
- **Real-time updates** via WebSocket
- **Smooth animations** and gradient indicators

### Key Features

1. **Event Timeline**
   - Real-time event stream
   - AI-generated summaries
   - Tool names and details
   - Timestamps
   - Session tracking

2. **Live Pulse Chart**
   - Canvas-based visualization
   - Session-specific colors
   - Event type emojis on bars
   - Time range selection (1m, 3m, 5m)
   - Smooth animations with glow effects

3. **Multi-Criteria Filtering**
   - Filter by app
   - Filter by session
   - Filter by event type
   - Combine multiple filters

4. **Chat Transcript Viewer**
   - Full conversation history
   - Syntax highlighting
   - Modal display

5. **Auto-scroll Control**
   - Auto-scroll to latest events
   - Manual override with "Stick Scroll" button
   - Scroll position memory

## Event Types Reference

| Event Type       | Emoji | Purpose                | What You'll See                       |
| ---------------- | ----- | ---------------------- | ------------------------------------- |
| PreToolUse       | 🔧     | Before tool execution  | Tool name & input parameters          |
| PostToolUse      | ✅     | After tool completion  | Tool name & execution results         |
| Notification     | 🔔     | User interactions      | Notification message                  |
| Stop             | 🛑     | Response completion    | Summary & chat transcript button      |
| SubagentStop     | 👥     | Subagent finished      | Subagent details                      |
| PreCompact       | 📦     | Context compaction     | Compaction trigger reason             |
| UserPromptSubmit | 💬     | User prompt submission | Prompt: _"user message"_ (italic)     |
| SessionStart     | 🚀     | Session started        | Session source (startup/resume/clear) |
| SessionEnd       | 🏁     | Session ended          | End reason (clear/logout/exit/other)  |

## Testing the Setup

### 1. Start the Dashboard
```bash
./start-observability.sh
```

Wait for:
```
✅ Server is ready!
✅ Client is ready!
🖥️  Client URL: http://localhost:5173
```

### 2. Open Dashboard
Open browser to http://localhost:5173

### 3. Trigger Events
In Claude Code (this session), run any command:
```
Run a simple bash command to test observability
```

### 4. Watch Events Stream
You should see events appear in real-time:
- 💬 UserPromptSubmit - Your prompt
- 🔧 PreToolUse - Before tool execution
- ✅ PostToolUse - After tool completion
- 🛑 Stop - Response completion

## Viewing Multi-Agent Activity

The observability system shines when monitoring multiple agents:

### Scenario 1: Claude Code + Realtime Agent

**Terminal 1**: Start observability
```bash
./start-observability.sh
```

**Terminal 2**: Start realtime agent
```bash
uv run apps/realtime-poc/big_three_realtime_agents.py --voice
```

**Dashboard**: Watch events from both:
- `big-3-super-agent` - Your current Claude Code session
- Events from the realtime orchestrator
- Events from spawned Claude Code agents
- Events from Gemini browser agents

### Scenario 2: Multiple Claude Code Sessions

Open multiple Claude Code sessions in different directories (all using this project's .claude setup), and watch all events flow into the same dashboard with different session colors.

## Advanced Features

### AI-Generated Summaries

Most hooks include `--summarize` flag, which:
- Sends event payload to Claude/OpenAI
- Generates concise, context-aware summary
- Displays on the right side of each event
- Helps understand complex tool executions

Example:
```
Event: PreToolUse - Bash
Summary: "Executing git status to check repository state"
```

### Chat Transcript on Stop

When a response completes (Stop event):
- Click the "View Chat" button
- See full conversation history
- Syntax-highlighted messages
- Helps debug agent reasoning

### Session Tracking

Each Claude Code session gets:
- Unique session ID
- Distinct color in the dashboard
- Filterable event stream
- Session start/end markers

## Customization

### Change Max Events Displayed

Edit `claude-code-hooks-multi-agent-observability/apps/client/.env`:
```env
VITE_MAX_EVENTS_TO_DISPLAY=100  # Default
```

Increase for longer history, decrease for better performance.

### Disable AI Summarization

Edit `.claude/settings.json` and remove `--summarize` flags:
```json
{
  "type": "command",
  "command": "uv run $CLAUDE_PROJECT_DIR/.claude/hooks/send_event.py --source-app big-3-super-agent --event-type PreToolUse"
}
```

### Add Custom Events

You can send custom events to the dashboard:
```bash
curl -X POST http://localhost:4000/events \
  -H "Content-Type: application/json" \
  -d '{
    "source_app": "my-custom-app",
    "session_id": "session-123",
    "hook_event_type": "PreToolUse",
    "payload": {"tool_name": "CustomTool", "details": "Custom event data"}
  }'
```

## Ports Used

- **4000** - Observability server (HTTP + WebSocket)
- **5173** - Vue dashboard (Vite dev server)

If ports are in use:
```bash
cd claude-code-hooks-multi-agent-observability
./scripts/reset-system.sh  # Stops all processes
```

## Stopping the System

### Option 1: Ctrl+C
Press `Ctrl+C` in the terminal where you started it

### Option 2: Reset Script
```bash
cd claude-code-hooks-multi-agent-observability
./scripts/reset-system.sh
```

This will:
- Kill processes on ports 4000 and 5173
- Clean up background processes
- Reset the system state

## Troubleshooting

### Hooks Not Firing

**Problem**: Events not appearing in dashboard

**Solutions**:

1. **Check server is running**:
   ```bash
   curl http://localhost:4000/health
   # Should return: {"status":"ok"}
   ```

2. **Verify hook scripts are executable**:
   ```bash
   ls -la .claude/hooks/*.py
   # All should have execute permissions
   ```

3. **Check hook paths**:
   - Settings.json uses `$CLAUDE_PROJECT_DIR` variable
   - Ensures hooks work from any directory

4. **Test hook manually**:
   ```bash
   uv run .claude/hooks/send_event.py \
     --source-app test \
     --event-type PreToolUse \
     --test
   ```

### Server Won't Start

**Problem**: Port 4000 or 5173 already in use

**Solution**:
```bash
# Check what's using the ports
lsof -i :4000
lsof -i :5173

# Kill the processes
cd claude-code-hooks-multi-agent-observability
./scripts/reset-system.sh
```

### Dashboard Not Updating

**Problem**: Events not appearing in real-time

**Solutions**:

1. **Check WebSocket connection**:
   - Open browser console (F12)
   - Look for WebSocket connection messages
   - Should see: "Connected to WebSocket"

2. **Refresh the page**:
   - Hard refresh: Cmd+Shift+R (Mac) or Ctrl+Shift+R (Windows)

3. **Check server logs**:
   - Server terminal should show incoming events
   - Look for HTTP POST to /events

### Bun Not Found

**Problem**: `bun: command not found`

**Solution**:
```bash
# Install Bun
curl -fsSL https://bun.sh/install.sh | bash

# Reload shell
exec $SHELL

# Or manually add to PATH
export PATH="$HOME/.bun/bin:$PATH"
```

### Rollup Module Error (Rosetta 2 / Apple Silicon)

**Problem**: `Cannot find module @rollup/rollup-darwin-x64` or `@rollup/rollup-darwin-arm64`

**Cause**: Architecture mismatch between your shell (Rosetta 2 x64 emulation) and installed packages

**Solution**:
```bash
# If running under Rosetta 2 (x64), install x64 rollup
npm install --prefix claude-code-hooks-multi-agent-observability/apps/client @rollup/rollup-darwin-x64

# If running natively on ARM (Apple Silicon), install ARM rollup
npm install --prefix claude-code-hooks-multi-agent-observability/apps/client @rollup/rollup-darwin-arm64

# Check your architecture
arch  # Shows current architecture (i386 = Rosetta, arm64 = native)
```

### Database Issues

**Problem**: SQLite errors or corrupt database

**Solution**:
```bash
# Stop the system
cd claude-code-hooks-multi-agent-observability
./scripts/reset-system.sh

# Remove database (events will be lost)
# Note: Use with caution, or manually delete the file in Finder
# rm apps/server/events.db

# Restart (database will be recreated)
./scripts/start-system.sh
```

## Project Structure

```
claude-code-hooks-multi-agent-observability/
├── apps/
│   ├── server/                 # Bun TypeScript server
│   │   ├── src/
│   │   │   ├── index.ts       # Main server
│   │   │   ├── db.ts          # SQLite management
│   │   │   └── types.ts       # TypeScript interfaces
│   │   └── events.db          # SQLite database
│   │
│   └── client/                # Vue 3 dashboard
│       ├── src/
│       │   ├── App.vue        # Main app
│       │   ├── components/    # Vue components
│       │   ├── composables/   # Vue composables
│       │   └── utils/         # Utilities
│       └── .env               # Client config
│
├── .claude/                   # Claude Code integration
│   ├── hooks/                # Hook scripts (Python)
│   └── settings.json         # Hook configuration
│
└── scripts/
    ├── start-system.sh       # Start server + client
    ├── reset-system.sh       # Stop all processes
    └── test-system.sh        # System validation
```

## Security Features

The hook scripts include safety checks:
- ✅ Blocks dangerous commands (`rm -rf`, etc.)
- ✅ Prevents access to sensitive files (`.env`, private keys)
- ✅ Validates all inputs before execution
- ✅ No external dependencies for core functionality

## Technical Stack

- **Server**: Bun, TypeScript, SQLite (with WAL mode)
- **Client**: Vue 3, TypeScript, Vite, Tailwind CSS
- **Hooks**: Python 3.8+, Astral uv
- **Communication**: HTTP REST, WebSocket
- **AI**: Claude/OpenAI (for summarization)

## Resources

### Documentation
- **Main README**: `README.md` - Project overview
- **Deployment Guide**: `DEPLOYMENT.md` - Setup instructions
- **Audio Controls**: `AUDIO_CONTROLS.md` - Voice agent controls
- **This Guide**: `OBSERVABILITY.md` - Observability setup

### Scripts
- `./quick-start.sh` - Interactive launcher (includes observability option)
- `./start-observability.sh` - Direct observability launcher
- `./start-content-gen.sh` - Content generation app launcher

### Links
- [Claude Code Hooks Observability Repo](https://github.com/disler/claude-code-hooks-multi-agent-observability)
- [Claude Code Hooks Mastery](https://github.com/disler/claude-code-hooks-mastery)
- [Full Video Breakdown](https://youtu.be/9ijnN985O_c)
- [Tactical Agentic Coding Course](https://agenticengineer.com/tactical-agentic-coding)

## Next Steps

1. **Start the dashboard**: `./start-observability.sh`
2. **Open browser**: http://localhost:5173
3. **Trigger some events**: Use Claude Code to run commands
4. **Watch the magic**: See real-time events streaming in
5. **Explore filters**: Try filtering by session, app, or event type
6. **View chat transcripts**: Click "View Chat" on Stop events

---

**Happy monitoring!** 🔭 Watch your agents work in real-time.
