# Audio Controls Guide - Big Three Super Agent

## Quick Reference

**Pause/Resume Audio Input: `Shift + Space`**

## Overview

When running the realtime agent in voice mode, you can control audio input with keyboard shortcuts. This is essential for:
- Preventing the agent from hearing background noise
- Having private conversations without the agent listening
- Controlling when you want the agent to respond

## Starting Voice Mode

```bash
# From project root
uv run apps/realtime-poc/big_three_realtime_agents.py --voice
```

Or use the quick start script:
```bash
./quick-start.sh
# Then select option 2 (Realtime Voice Agent - Voice Mode)
```

## Keyboard Controls

### Pause/Resume Toggle

**Shortcut**: `Shift + Space`

- Hold down the **Shift** key (left or right)
- Press **Space** while holding Shift
- The audio input will toggle between paused and live states

### Visual Feedback

When you toggle pause/resume, you'll see a status panel:

**Paused State:**
```
⏸️ PAUSED
```
- Color: Yellow
- Microphone is muted
- Agent will not hear you
- Audio input processing is stopped

**Live State:**
```
🎤 LIVE
```
- Color: Green
- Microphone is active
- Agent is listening
- Audio input is being sent to the agent

### Audio Feedback

The system plays soft beeps to confirm your action:

- **Higher pitch beep (520 Hz)**: Audio resumed - agent is now listening
- **Lower pitch beep (380 Hz)**: Audio paused - agent is muted

## Automatic Pause Behavior

The agent automatically manages audio input during conversations:

### Auto-Pause During Agent Speech
- **When**: Agent starts speaking
- **Why**: Prevents audio feedback and echo
- **Behavior**: Audio input is temporarily paused
- **Resume**: Automatically resumes when agent finishes speaking

### Manual vs Auto Pause

The system tracks two pause states:

1. **Manual Pause** (Shift + Space):
   - You control this explicitly
   - Overrides all other behavior
   - Stays paused until you unpause

2. **Auto Pause** (During agent speech):
   - System-controlled
   - Temporary during agent responses
   - Does not affect manual pause state

## Setup Requirements

### Mac Permissions

For keyboard controls to work, your terminal needs Input Monitoring permissions:

1. Open **System Settings**
2. Go to **Privacy & Security**
3. Click **Input Monitoring**
4. Add your Terminal app (Terminal.app, iTerm2, etc.)
5. Toggle the switch to enable

### Verification

When the agent starts, you should see:
```
Keyboard listener started (shift+space to pause/resume)
```

If you don't see this message, check:
- Terminal permissions (see above)
- Log files in `apps/realtime-poc/output_logs/`

## Troubleshooting

### Shift + Space Not Working

**Problem**: Pressing Shift + Space doesn't pause/resume audio

**Solutions**:

1. **Check permissions**:
   ```
   System Settings → Privacy & Security → Input Monitoring
   ```
   Ensure your terminal app is listed and enabled

2. **Restart the agent**:
   ```bash
   # Stop the agent (Ctrl+C)
   # Start it again
   uv run apps/realtime-poc/big_three_realtime_agents.py --voice
   ```

3. **Check logs**:
   ```bash
   tail -f apps/realtime-poc/output_logs/super_agent_*.log
   ```
   Look for keyboard listener errors

4. **Try different terminal**:
   - Some terminals may have better keyboard event support
   - Try Terminal.app, iTerm2, or another terminal emulator

### No Audio Feedback Beeps

**Problem**: No beep sound when toggling pause/resume

**Impact**: Visual feedback still works, just no audio confirmation

**Solutions**:
- Check system volume
- Beeps are soft by design, increase volume
- Look for visual panel feedback instead

### Keyboard Listener Won't Start

**Problem**: Log shows "Could not start keyboard listener"

**Solutions**:

1. **Install/reinstall pynput**:
   ```bash
   # The agent uses inline dependencies, so just re-run:
   uv run apps/realtime-poc/big_three_realtime_agents.py --voice
   ```

2. **Check Python version**:
   ```bash
   python3 --version
   # Should be 3.11 or higher
   ```

3. **Use text mode as fallback**:
   ```bash
   uv run apps/realtime-poc/big_three_realtime_agents.py --input text --output text
   ```

## Alternative Input Modes

If audio controls aren't working or you prefer typing:

### Text Input, Voice Output
```bash
uv run apps/realtime-poc/big_three_realtime_agents.py --input text --output audio
```
- Type your messages
- Agent responds with voice
- No need for pause controls

### Text Input and Output
```bash
uv run apps/realtime-poc/big_three_realtime_agents.py --input text --output text
```
- Type your messages
- Agent responds with text
- No audio handling needed

### Auto-Prompt Mode (Testing)
```bash
uv run apps/realtime-poc/big_three_realtime_agents.py --prompt "list all agents"
```
- Sends a single prompt automatically
- No interactive input needed
- Useful for testing and automation

## Implementation Details

For developers and advanced users:

### Code Location
File: `apps/realtime-poc/big_three_realtime_agents.py`

### Key Components

**State Variables** (Line 1601-1602):
```python
self.audio_paused = False  # Manual pause via shift+space
self.auto_paused_for_response = False  # Auto-pause during agent speech
```

**Keyboard Handler** (Line 1781-1810):
```python
def _on_key_press(self, key):
    """Handle key press to toggle audio pause (shift+space)."""
    # Tracks shift key state
    # Toggles audio_paused when space pressed with shift held
    # Plays beep and shows visual feedback
```

**Keyboard Listener** (Line 1820-1833):
```python
def _start_keyboard_listener(self):
    """Start keyboard listener for shift+space toggle."""
    self.keyboard_listener = keyboard.Listener(
        on_press=self._on_key_press,
        on_release=self._on_key_release
    )
```

**Audio Capture Loop** (Line 2312-2314):
```python
# Skip audio capture when paused (manual or auto)
if self.audio_paused or self.auto_paused_for_response:
    time.sleep(0.1)
    continue
```

### Dependencies

The keyboard control requires:
- `pynput` - For keyboard event handling
- Automatically installed via inline script dependencies

## Best Practices

### When to Pause

1. **Before speaking privately**: Pause before discussing sensitive information
2. **During background noise**: Pause when there's loud ambient noise
3. **When thinking**: Pause to prevent the agent from hearing thinking-out-loud
4. **During phone calls**: Pause to take phone calls without the agent listening

### When to Stay Live

1. **During active conversation**: Keep live for natural back-and-forth dialogue
2. **When giving commands**: Keep live to issue multiple commands in sequence
3. **During demos**: Keep live to show continuous interaction

### Audio Etiquette

- **Wait for visual feedback**: Ensure you see the pause/resume status before speaking
- **Listen for beeps**: Audio confirmation helps prevent mistakes
- **Check logs**: If unsure, check logs to verify pause state
- **Test first**: Practice pausing/resuming before important sessions

## Command Summary

### Start Voice Mode
```bash
uv run apps/realtime-poc/big_three_realtime_agents.py --voice
```

### Keyboard Controls
- **Pause/Resume**: `Shift + Space`
- **Exit Agent**: `Ctrl + C`

### Alternative Modes
```bash
# Text input, voice output
uv run apps/realtime-poc/big_three_realtime_agents.py --input text --output audio

# Text only mode
uv run apps/realtime-poc/big_three_realtime_agents.py --input text --output text

# Mini model (cheaper/faster)
uv run apps/realtime-poc/big_three_realtime_agents.py --mini --voice

# Auto-prompt testing
uv run apps/realtime-poc/big_three_realtime_agents.py --prompt "your command here"
```

## Support

### Log Files
```bash
# View agent logs
tail -f apps/realtime-poc/output_logs/super_agent_*.log

# View all logs
ls -lah apps/realtime-poc/output_logs/
```

### Common Log Messages

**Success**:
```
Keyboard listener started (shift+space to pause/resume)
Audio input PAUSED
Audio input LIVE
```

**Warnings**:
```
Could not start keyboard listener: [error details]
Error handling shift+space: [error details]
```

### Getting Help

1. Check this guide first
2. Review `DEPLOYMENT.md` for general setup issues
3. Check logs in `apps/realtime-poc/output_logs/`
4. Verify permissions in System Settings
5. Try alternative input modes as fallback

## Additional Resources

- **Main README**: `README.md` - Project overview and architecture
- **Deployment Guide**: `DEPLOYMENT.md` - Complete setup and deployment instructions
- **Quick Start**: `quick-start.sh` - Interactive startup script

---

**Happy voice controlling!** 🎤 Press `Shift + Space` to pause/resume anytime.
