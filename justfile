down service: 
  cd {{service}} && docker compose down

up service: 
  cd {{service}} && docker compose up -d

setup-auto-update:
  #!/usr/bin/env bash
  set -e
  # Justfile recipes run from the directory containing the justfile
  REPO_ROOT="$(pwd)"
  UPDATE_SCRIPT_ABS="$REPO_ROOT/scripts/auto-update.sh"
  CRON_LOG="/var/log/auto-update.log"
  CRON_CMD="0 */6 * * * $UPDATE_SCRIPT_ABS >> $CRON_LOG 2>&1"
  
  if [ ! -f "$UPDATE_SCRIPT_ABS" ]; then
      echo "Error: Could not find $UPDATE_SCRIPT_ABS"
      echo "Current directory: $REPO_ROOT"
      exit 1
  fi
  
  chmod +x "$UPDATE_SCRIPT_ABS"
  echo "✓ Made auto-update.sh executable"
  
  sudo touch "$CRON_LOG" 2>/dev/null || echo "Note: Could not create $CRON_LOG, you may need to run: sudo touch $CRON_LOG"
  
  if crontab -l 2>/dev/null | grep -qF "$UPDATE_SCRIPT_ABS"; then
      echo "✓ Cron job already exists"
  else
      (crontab -l 2>/dev/null; echo ""; echo "# Auto-update Docker containers every 6 hours"; echo "$CRON_CMD") | crontab -
      echo "✓ Added cron job (runs every 6 hours)"
      echo "  Script: $UPDATE_SCRIPT_ABS"
      echo "  To view: crontab -l"
      echo "  To edit: crontab -e"
      echo "  Logs: tail -f $CRON_LOG"
  fi
