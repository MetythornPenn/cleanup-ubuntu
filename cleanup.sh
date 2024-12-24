#!/bin/bash

# Colors for output
green='\e[32m'
red='\e[31m'
endColor='\e[0m'

echo -e "${green}Starting Full System Cleanup...${endColor}\n"

# 1. Clean APT Cache
echo "Cleaning APT cache..."
sudo apt clean && sudo apt autoclean && sudo apt autoremove -y

# 2. Clean Node.js (npm & yarn) Cache
echo "Cleaning Node.js (npm & yarn) cache..."
npm cache clean --force
yarn cache clean

# 3. Clean Miniconda Cache
echo "Cleaning Miniconda cache..."
conda clean --all -y

# 4. Clean Python pip Cache
echo "Cleaning Python pip cache..."
pip cache purge

# 5. Clean Docker Cache
echo "Cleaning Docker cache (containers, images, volumes)..."
docker system prune -a --volumes -f

# 6. Clean Telegram Cache
echo "Cleaning Telegram cache..."
rm -rf ~/.local/share/TelegramDesktop/tdata/cache/*

# 7. Clean Google Chrome Cache
echo "Cleaning Google Chrome cache..."
rm -rf ~/.cache/google-chrome/

# 8. Clean Snap Cache
echo "Cleaning Snap cache..."
sudo du -sh /var/lib/snapd/cache/
sudo rm -rf /var/lib/snapd/cache/*

# 9. Clean Flatpak Cache
echo "Cleaning Flatpak cache..."
flatpak uninstall --unused -y

# 10. Clear Thumbnail Cache
echo "Cleaning thumbnail cache..."
rm -rf ~/.cache/thumbnails/*

# 11. Clean Temporary Files
echo "Cleaning temporary files..."
sudo rm -rf /tmp/* /var/tmp/*

# 12. Clear Systemd Journals
echo "Vacuuming systemd journals..."
sudo journalctl --vacuum-time=2weeks

# 13. Clean VS Code Cache
echo "Cleaning VS Code cache..."
rm -rf ~/.config/Code/Cache/*
rm -rf ~/.vscode/extensions/*
rm -rf ~/.config/Code/CachedData/*

# 14. Clean Firefox Cache
echo "Cleaning Firefox cache..."
rm -rf ~/.mozilla/firefox/*/cache2/*

# 15. Clean Bash History
echo "Cleaning Bash history..."
cat /dev/null > ~/.bash_history && history -c

# 16. Disk Space Analysis (Largest Files)
echo "Finding large files (over 500MB)..."
du -ah / 2>/dev/null | grep -E "[0-9]{3,}M" | sort -rh | head -n 20

# 17. Clear System Logs (Older than 30 days)
echo "Cleaning logs older than 30 days..."
sudo find /var/log -type f -name "*.log" -mtime +30 -delete

# 18. Clean Orphan Packages
echo "Cleaning orphan packages..."
sudo apt autoremove --purge -y

# Completion Message
echo -e "\n${green}System cleanup completed successfully!${endColor}"


