#!/bin/bash

# ============================================================
# Headless Desktop - Startup Script
# ============================================================
# Starts VNC server and noVNC web client
# ============================================================

LOG="/tmp/desktop.log"
> "$LOG"  # Clear log file

# ============================================================
# Configuration
# ============================================================
VNC_PORT=5901
NOVNC_PORT=6901
DISPLAY_NUM=1
RESOLUTION=${SCREEN_RESOLUTION:-1280x720}
DEPTH=24

echo ""
echo "  ╔══════════════════════════════════════════════╗"
echo "  ║                 Headless                     ║"
echo "  ╚══════════════════════════════════════════════╝"
echo ""

# ============================================================
# Step 1: Start VNC Server
# ============================================================
echo "  [1/3] Starting VNC server ..."
mkdir -p ~/.vnc
echo "${VNC_PW:-password}" | vncpasswd -f > ~/.vnc/passwd 2>>"$LOG"
chmod 600 ~/.vnc/passwd

# Clean up existing VNC locks
vncserver -kill :$DISPLAY_NUM 2>/dev/null || true
rm -rf /tmp/.X11-unix/X$DISPLAY_NUM
rm -rf /tmp/.X$DISPLAY_NUM-lock

vncserver :$DISPLAY_NUM -geometry $RESOLUTION -depth $DEPTH -rfbport $VNC_PORT -localhost no >>"$LOG" 2>&1
export DISPLAY=:$DISPLAY_NUM

# Wait for X server
for i in {1..10}; do
    if xset q > /dev/null 2>&1; then
        break
    fi
    sleep 1
done
echo "  [1/3] ✔  VNC server started (port $VNC_PORT)"

# ============================================================
# Step 2: Start Desktop Environment
# ============================================================
echo "  [2/3] Starting desktop environment ..."
openbox >>"$LOG" 2>&1 &
tint2 >>"$LOG" 2>&1 &
sleep 1
echo "  [2/3] ✔  Desktop environment started"

# ============================================================
# Step 3: Start noVNC
# ============================================================
echo "  [3/3] Starting noVNC web client ..."
/opt/noVNC/utils/novnc_proxy --vnc localhost:$VNC_PORT --listen $NOVNC_PORT --web /opt/noVNC >>"$LOG" 2>&1 &
sleep 1
echo "  [3/3] ✔  noVNC started (port $NOVNC_PORT)"

# ============================================================
# Ready!
# ============================================================
echo ""
echo "  ╔══════════════════════════════════════════════╗"
echo "  ║              ✔  Ready!                       ║"
echo "  ╠══════════════════════════════════════════════╣"
echo "  ║  VNC:   localhost:$VNC_PORT                       ║"
echo "  ║  Web:   http://localhost:$NOVNC_PORT/vnc.html       ║"
echo "  ║  Pass:  ${VNC_PW:-password}                      ║"
echo "  ╠══════════════════════════════════════════════╣"
echo "  ║  Logs:  $LOG                        ║"
echo "  ╚══════════════════════════════════════════════╝"
echo ""
echo "  Press Ctrl-C to stop the container."
echo ""

# ============================================================
# Keep container alive
# ============================================================
wait