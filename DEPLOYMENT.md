# Big Three Super Agent - Deployment Guide

## Setup Complete! ✅

Your project has been successfully set up and is ready to deploy.

## What Was Configured

1. **System Dependencies**: Python 3.12.8, uv, Node.js 22.16.0, npm 10.9.2, portaudio
2. **Environment Variables**: Root .env and backend .env configured with your API keys
3. **Python Dependencies**: Backend dependencies installed with uv in virtual environment
4. **Frontend Dependencies**: Node modules installed for Vue.js frontend
5. **Required Directories**: Created videos, agents, and logs directories
6. **Bug Fix**: Fixed Python f-string syntax error in big_three_realtime_agents.py:1949

## Quick Start Commands

### 1. Start Content Generation App (Backend + Frontend)

```bash
# From project root
cd apps/content-gen
./start.sh
```

This will start:
- **Backend** at http://localhost:4444
- **Frontend** at http://localhost:3333
- **Health Check** at http://localhost:4444/health

### 2. Start Realtime Voice Agent

```bash
# From project root

# Voice mode (full experience with microphone)
uv run apps/realtime-poc/big_three_realtime_agents.py --voice

# Text mode (for testing without audio)
uv run apps/realtime-poc/big_three_realtime_agents.py --input text --output text

# Auto-dispatch with prompt (useful for testing)
uv run apps/realtime-poc/big_three_realtime_agents.py --prompt "Create a new claude code agent, and have it list all the files in the working directory"

# Use mini model (faster/cheaper)
uv run apps/realtime-poc/big_three_realtime_agents.py --mini --voice
```

### 3. Manual Service Control

#### Backend Only
```bash
cd apps/content-gen/backend
source .venv/bin/activate
python -m content_gen_backend
```

#### Frontend Only
```bash
cd apps/content-gen/frontend
npm run dev
```

## Environment Configuration

### Root .env (Realtime Agents)
Located at: `/Users/davidgardiner/Desktop/repo/big-3-super-agent/.env`

Contains:
- OPENAI_API_KEY - For voice orchestration and Sora video generation
- ANTHROPIC_API_KEY - For Claude Code agents
- GEMINI_API_KEY - For browser automation
- GROQ_API_KEY - Optional
- DEEPSEEK_API_KEY - Optional
- ELEVENLABS_API_KEY - Optional
- ENGINEER_NAME - Set to "David"
- AGENT_WORKING_DIRECTORY - Defaults to apps/content-gen

### Backend .env (Content Generation)
Located at: `/Users/davidgardiner/Desktop/repo/big-3-super-agent/apps/content-gen/backend/.env`

Contains:
- OPENAI_API_KEY - For Sora video generation
- VIDEO_STORAGE_PATH - ./videos
- Configuration for video generation (model, size, duration, etc.)

## Project Structure

```
big-3-super-agent/
├── .env                           # Root environment variables
├── apps/
│   ├── content-gen/              # Agent working directory
│   │   ├── backend/              # FastAPI backend (Port 4444)
│   │   │   ├── .env              # Backend-specific config
│   │   │   ├── .venv/            # Python virtual environment
│   │   │   ├── videos/           # Generated video storage
│   │   │   └── src/
│   │   ├── frontend/             # Vue.js frontend (Port 3333)
│   │   │   └── node_modules/
│   │   ├── agents/               # Agent session registries
│   │   │   ├── claude_code/      # Claude Code agent sessions
│   │   │   └── gemini/           # Gemini agent sessions
│   │   └── start.sh              # Convenience startup script
│   └── realtime-poc/
│       ├── big_three_realtime_agents.py  # Main orchestrator
│       ├── prompts/              # System prompts
│       └── output_logs/          # Voice agent logs & screenshots
└── DEPLOYMENT.md                 # This file
```

## Testing the Setup

### 1. Test Backend API
```bash
curl http://localhost:4444/health
```

Expected response:
```json
{"status": "healthy", "service": "content-gen-backend"}
```

### 2. Test Frontend
Open browser to: http://localhost:3333

### 3. Test Realtime Agent (Text Mode)
```bash
uv run apps/realtime-poc/big_three_realtime_agents.py --prompt "list all agents"
```

This should start the orchestrator and execute the command without requiring voice input.

## Common Issues & Solutions

### "Port already in use"
```bash
# Kill processes on ports
lsof -ti:4444 | xargs kill -9
lsof -ti:3333 | xargs kill -9
```

### "Module not found" errors
```bash
# Reinstall backend dependencies
cd apps/content-gen/backend
uv sync

# Reinstall frontend dependencies
cd ../frontend
npm install
```

### Playwright not working
```bash
# Playwright browsers are installed automatically when running realtime agent
# If issues occur, the script will handle installation on first run
```

### Audio issues (Voice mode)
- Ensure microphone permissions are granted to your terminal
- Check that portaudio is installed: `brew list portaudio`
- Test with text mode first: `--input text --output text`

### Architecture mismatch (Rosetta 2 on Apple Silicon)

**Problem**: Backend fails with `ImportError: dlopen ... incompatible architecture`

**Cause**: Python dependencies were installed for wrong architecture (x86_64 vs arm64)

**Solution**:
```bash
# Reinstall backend dependencies matching your shell architecture
cd apps/content-gen/backend
uv sync --reinstall

# For observability client, install correct rollup module
# If running under Rosetta 2 (x86_64):
npm install --prefix claude-code-hooks-multi-agent-observability/apps/client @rollup/rollup-darwin-x64

# Check your architecture
arch  # Shows i386 (Rosetta) or arm64 (native)
```

## Development Workflow

### Running All Services

For full development experience:

1. **Terminal 1**: Start content-gen services
   ```bash
   cd apps/content-gen && ./start.sh
   ```

2. **Terminal 2**: Start realtime agent
   ```bash
   uv run apps/realtime-poc/big_three_realtime_agents.py --voice
   ```

3. **Browser**: Open frontend at http://localhost:3333

### Agent Working Directory

By default, Claude Code agents work in `apps/content-gen/`. To change this:
```bash
# Edit .env
AGENT_WORKING_DIRECTORY=/path/to/your/project
```

## Multi-Agent Observability ✨

**Already configured and ready to use!**

Monitor all agent activities in real-time with the built-in observability dashboard:

```bash
# Quick start (from project root)
./start-observability.sh

# Or use the interactive launcher
./quick-start.sh
# Then select option 5: Multi-Agent Observability Dashboard
```

Open dashboard at: **http://localhost:5173**

**What You Get:**
- 🔧 Real-time event stream from all agents
- 🎨 AI-generated summaries for each event
- 📊 Live pulse chart with session tracking
- 💬 Full chat transcript viewer
- 🎯 Multi-criteria filtering (app, session, event type)
- 🌈 Session-based color coding

**Events Tracked:**
- PreToolUse, PostToolUse - Every tool execution
- UserPromptSubmit - Your prompts
- Notification - User interactions
- Stop - Response completions with chat history
- SessionStart/End - Session lifecycle
- And more!

For detailed setup and features, see **OBSERVABILITY.md**

## API Endpoints

### Content Generation Backend (Port 4444)

- `GET /health` - Health check
- `POST /api/v1/videos/generate` - Generate video with Sora
- `GET /api/v1/videos/{video_id}` - Get video status
- `GET /api/v1/videos/{video_id}/download` - Download video

### Frontend (Port 3333)

- Interactive UI for video generation
- Real-time status updates
- Video preview and download

## Cost Management

The project uses multiple AI services:
- OpenAI Realtime API (voice orchestration)
- Claude Code API (software development)
- Gemini API (browser automation)
- OpenAI Sora API (video generation)

Use the `--mini` flag with realtime agent for cost savings:
```bash
uv run apps/realtime-poc/big_three_realtime_agents.py --mini --voice
```

## Next Steps

1. **Test the content generation app**: Generate a video using the frontend
2. **Try voice mode**: Use realtime agent with `--voice` flag
3. **Create a Claude Code agent**: Ask the orchestrator to "create a claude code agent"
4. **Explore browser automation**: Ask for "create a gemini browser agent"

## Support

- For issues with the realtime agent: Check `apps/realtime-poc/output_logs/`
- For backend issues: Check `apps/content-gen/backend/logs/`
- For API errors: Verify API keys in `.env` files

## Built With

- OpenAI Realtime API & Sora API
- Claude Code (Anthropic)
- Gemini 2.5 Computer Use (Google)
- FastAPI (Backend)
- Vue.js + Vite (Frontend)
- Astral uv (Python package management)
- Playwright (Browser automation)

---

**Ready to deploy!** 🚀

Start with: `cd apps/content-gen && ./start.sh`
