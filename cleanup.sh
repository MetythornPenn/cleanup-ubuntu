#!/bin/bash

# Colors for output
green='\e[32m'
red='\e[31m'
endColor='\e[0m'

echo -e "${green}Starting Full Advanced System Cleanup...${endColor}\n"

# 1. Clean APT Cache and Fix Broken Packages
echo "Cleaning APT cache and fixing broken packages..."
sudo apt clean && sudo apt autoclean && sudo apt autoremove -y
sudo dpkg --configure -a
sudo apt --fix-broken install

# 2. Clean Node.js (npm & yarn) Cache
echo "Cleaning Node.js (npm & yarn) cache..."
npm cache clean --force
yarn cache clean

# 3. Clean Miniconda Cache
echo "Cleaning Miniconda cache..."
conda clean --all -y

# 4. Clean Python Pip Cache
echo "Cleaning Python pip cache..."
pip cache purge

# 5. Clean Docker Cache and Unused Volumes
echo "Cleaning Docker cache, volumes, and networks..."
docker system prune -a --volumes -f

docker volume prune -f
docker network prune -f

echo "Restarting Docker service..."
sudo systemctl restart docker

# 6. Clean Telegram Cache
echo "Cleaning Telegram cache..."
rm -rf ~/.local/share/TelegramDesktop/tdata/cache/*

# 7. Clean Google Chrome and Chromium Cache
echo "Cleaning Google Chrome and Chromium cache..."
rm -rf ~/.cache/google-chrome/
rm -rf ~/.cache/chromium/

# 8. Clean Snap Cache
echo "Cleaning Snap cache..."
sudo rm -rf /var/lib/snapd/cache/*
sudo snap set system refresh.retain=2

# 9. Clean Flatpak and Orphan Packages
echo "Cleaning Flatpak cache and unused packages..."
flatpak uninstall --unused -y
flatpak repair

# 10. Clear Thumbnail and Icon Cache
echo "Cleaning thumbnail and icon cache..."
rm -rf ~/.cache/thumbnails/*
rm -rf ~/.icons

# 11. Clean Temporary Files and Cache
echo "Cleaning temporary files and system cache..."
sudo rm -rf /tmp/* /var/tmp/*
rm -rf ~/.cache/*

# 12. Clear Systemd Journals and Old Logs
echo "Vacuuming systemd journals and removing old logs..."
sudo journalctl --vacuum-time=1week
sudo find /var/log -type f -name "*.log" -mtime +7 -delete

# 13. Clean VS Code Cache and Extensions
echo "Cleaning VS Code cache and extensions..."
rm -rf ~/.config/Code/Cache/*
rm -rf ~/.vscode/extensions/*
rm -rf ~/.config/Code/CachedData/*

# 14. Clean Firefox and Brave Browser Cache
echo "Cleaning Firefox and Brave browser cache..."
rm -rf ~/.mozilla/firefox/*/cache2/*
rm -rf ~/.config/BraveSoftware/Brave-Browser/Default/Cache/*

# 15. Clean Bash and ZSH History
echo "Cleaning Bash and ZSH history..."
cat /dev/null > ~/.bash_history && history -c
cat /dev/null > ~/.zsh_history

# 16. Remove Large Unused Files
echo "Finding and removing large unused files..."
du -ah / 2>/dev/null | grep -E "[0-9]{3,}M" | sort -rh | head -n 30

# 17. Remove Orphaned Packages and Dependencies
echo "Removing orphaned packages..."
sudo apt autoremove --purge -y

# 18. Clean DeepFace Cache
echo "Cleaning DeepFace cache..."
rm -rf ~/.deepface

# 19. Clean Postman Cache
echo "Cleaning Postman cache..."
rm -rf ~/.config/Postman/cache
rm -rf ~/.config/Postman/logs

# 20. Empty Trash Bins
echo "Emptying user Trash bins..."
rm -rf ~/.local/share/Trash/*
sudo rm -rf /root/.local/share/Trash/*

# 21. Clean Go (golang) Cache
echo "Cleaning Go build cache..."
go clean -cache -modcache -testcache -fuzzcache

# Completion Message
echo -e "\n${green}Advanced System Cleanup Completed Successfully!${endColor}"
