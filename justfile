down service: 
  cd {{service}} && docker compose down

up service: 
  cd {{service}} && docker compose up -d

setup-auto-update:
    #!/usr/bin/env bash
    set -e
    UPDATE_SCRIPT_ABS="$(pwd)/scripts/auto-update.sh"
    CRON_LOG="/var/log/auto-update.log"
    CRON_CMD="0 */6 * * * $UPDATE_SCRIPT_ABS >> $CRON_LOG 2>&1"
    chmod +x scripts/auto-update.sh
    echo "✓ Made auto-update.sh executable"
    sudo touch "$CRON_LOG" 2>/dev/null || echo "Note: Could not create $CRON_LOG, you may need to run: sudo touch $CRON_LOG"
    if crontab -l 2>/dev/null | grep -qF "$UPDATE_SCRIPT_ABS"; then
        echo "✓ Cron job already exists"
    else
        (crontab -l 2>/dev/null; echo ""; echo "# Auto-update Docker containers every 6 hours"; echo "$CRON_CMD") | crontab -
        echo "✓ Added cron job (runs every 6 hours)"
        echo "  To view: crontab -l"
        echo "  To edit: crontab -e"
        echo "  Logs: tail -f $CRON_LOG"
    fi
