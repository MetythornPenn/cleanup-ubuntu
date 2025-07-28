#!/bin/bash

# Colors for output
green='\e[32m'
red='\e[31m'
yellow='\e[33m'
endColor='\e[0m'

echo -e "${green}Starting Full Advanced System Cleanup...${endColor}\n"

# 1. Clean APT Cache and Fix Broken Packages
echo "Cleaning APT cache and fixing broken packages..."
sudo apt clean && sudo apt autoclean && sudo apt autoremove -y
sudo dpkg --configure -a
sudo apt --fix-broken install

# 2. Clean Node.js (npm, yarn, pnpm) Cache
echo "Cleaning Node.js package manager caches..."
npm cache clean --force 2>/dev/null || echo "npm not found, skipping..."
yarn cache clean 2>/dev/null || echo "yarn not found, skipping..."
pnpm store prune 2>/dev/null || echo "pnpm not found, skipping..."

# 3. Clean Python Environment Caches
echo "Cleaning Python environment and package caches..."
# Conda/Miniconda
conda clean --all -y 2>/dev/null || echo "conda not found, skipping..."
# Pip
pip cache purge 2>/dev/null || echo "pip cache purge failed, skipping..."
# UV (modern Python package manager)
uv cache clean 2>/dev/null || echo "uv not found, skipping..."
# Poetry
poetry cache clear . --all 2>/dev/null || echo "poetry not found, skipping..."
# Pipenv
rm -rf ~/.cache/pipenv 2>/dev/null || echo "pipenv cache not found, skipping..."

# 4. Clean Machine Learning Framework Caches
echo "Cleaning ML framework caches..."
# Hugging Face transformers and datasets
rm -rf ~/.cache/huggingface/ 2>/dev/null || echo "Hugging Face cache not found, skipping..."
# PyTorch
rm -rf ~/.cache/torch/ 2>/dev/null || echo "PyTorch cache not found, skipping..."
# TensorFlow
rm -rf ~/.cache/tensorflow/ 2>/dev/null || echo "TensorFlow cache not found, skipping..."

# 5. Clean Development Tool Caches
echo "Cleaning development tool caches..."
# Rust Cargo
cargo clean 2>/dev/null || echo "cargo not found, skipping..."
rm -rf ~/.cargo/registry/cache/ 2>/dev/null || echo "Cargo cache not found, skipping..."
# Go
go clean -cache -modcache -testcache -fuzzcache 2>/dev/null || echo "go not found, skipping..."
# Gradle
rm -rf ~/.gradle/caches/ 2>/dev/null || echo "Gradle cache not found, skipping..."
# Maven
rm -rf ~/.m2/repository/ 2>/dev/null || echo "Maven cache not found, skipping..."

# 6. Clean Jupyter and IPython Caches
echo "Cleaning Jupyter and IPython caches..."
rm -rf ~/.cache/jupyter/ 2>/dev/null || echo "Jupyter cache not found, skipping..."
rm -rf ~/.ipython/profile_default/history.sqlite 2>/dev/null || echo "IPython history not found, skipping..."
jupyter --paths 2>/dev/null && jupyter cache clear 2>/dev/null || echo "Jupyter not found, skipping cache clear..."

# 7. Clean Docker Cache and Unused Volumes
echo "Cleaning Docker cache, volumes, and networks..."
if command -v docker >/dev/null 2>&1; then
    docker system prune -a --volumes -f
    docker volume prune -f
    docker network prune -f
    echo "Restarting Docker service..."
    sudo systemctl restart docker
else
    echo "Docker not found, skipping..."
fi

# 8. Clean Browser Caches
echo "Cleaning browser caches..."
# Google Chrome and Chromium
rm -rf ~/.cache/google-chrome/ 2>/dev/null || echo "Chrome cache not found, skipping..."
rm -rf ~/.cache/chromium/ 2>/dev/null || echo "Chromium cache not found, skipping..."
# Firefox
rm -rf ~/.mozilla/firefox/*/cache2/* 2>/dev/null || echo "Firefox cache not found, skipping..."
# Brave Browser
rm -rf ~/.config/BraveSoftware/Brave-Browser/Default/Cache/* 2>/dev/null || echo "Brave cache not found, skipping..."

# 9. Clean Gaming and Entertainment Caches
echo "Cleaning gaming and entertainment caches..."
# Steam
rm -rf ~/.steam/steam/logs/* 2>/dev/null || echo "Steam logs not found, skipping..."
rm -rf ~/.local/share/Steam/logs/* 2>/dev/null || echo "Steam local logs not found, skipping..."
# WINE
rm -rf ~/.wine/drive_c/windows/Temp/* 2>/dev/null || echo "WINE temp not found, skipping..."

# 10. Clean Communication App Caches
echo "Cleaning communication app caches..."
# Telegram
rm -rf ~/.local/share/TelegramDesktop/tdata/cache/* 2>/dev/null || echo "Telegram cache not found, skipping..."
# Discord
rm -rf ~/.config/discord/Cache/* 2>/dev/null || echo "Discord cache not found, skipping..."
rm -rf ~/.config/discord/GPUCache/* 2>/dev/null || echo "Discord GPU cache not found, skipping..."

# 11. Clean Package Manager Caches
echo "Cleaning package manager caches..."
# Snap
sudo rm -rf /var/lib/snapd/cache/* 2>/dev/null || echo "Snap cache not found, skipping..."
sudo snap set system refresh.retain=2 2>/dev/null || echo "Snap not found, skipping..."
# Flatpak
flatpak uninstall --unused -y 2>/dev/null || echo "Flatpak not found, skipping..."
flatpak repair 2>/dev/null || echo "Flatpak repair failed, skipping..."

# 12. Clean System Caches and Thumbnails
echo "Cleaning system caches and thumbnails..."
# Thumbnail cache
rm -rf ~/.cache/thumbnails/* 2>/dev/null || echo "Thumbnail cache not found, skipping..."
# Icon cache
rm -rf ~/.cache/icon-theme.cache 2>/dev/null || echo "Icon cache not found, skipping..."
# Font cache
fc-cache -f -v 2>/dev/null || echo "Font cache refresh failed, skipping..."

# 13. Clean Development IDE Caches
echo "Cleaning IDE caches..."
# VS Code (commented out by default to preserve extensions and settings)
# rm -rf ~/.config/Code/Cache/* 2>/dev/null || echo "VS Code cache not found, skipping..."
# rm -rf ~/.config/Code/CachedData/* 2>/dev/null || echo "VS Code cached data not found, skipping..."
echo "Skipping VS Code cleanup (uncomment in script to enable)..."

# IntelliJ IDEA
rm -rf ~/.cache/JetBrains/ 2>/dev/null || echo "JetBrains cache not found, skipping..."

# 14. Clean Postman Cache
echo "Cleaning Postman cache..."
rm -rf ~/.config/Postman/cache 2>/dev/null || echo "Postman cache not found, skipping..."
rm -rf ~/.config/Postman/logs 2>/dev/null || echo "Postman logs not found, skipping..."

# 15. Clean DeepFace and other AI model caches
echo "Cleaning AI model caches..."
rm -rf ~/.deepface 2>/dev/null || echo "DeepFace cache not found, skipping..."

# 16. Clean Temporary Files and General Cache
echo "Cleaning temporary files and general system cache..."
sudo rm -rf /tmp/* /var/tmp/* 2>/dev/null || echo "Some temp files couldn't be removed (in use)..."
rm -rf ~/.cache/* 2>/dev/null || echo "Some user cache files couldn't be removed (in use)..."

# 17. Clear System Logs
echo "Cleaning system logs..."
sudo journalctl --vacuum-time=1week
sudo find /var/log -type f -name "*.log" -mtime +7 -delete 2>/dev/null || echo "Some log files couldn't be deleted..."

# 18. Clean Shell History
echo "Cleaning shell history..."
cat /dev/null > ~/.bash_history && history -c 2>/dev/null || echo "Bash history cleanup failed..."
cat /dev/null > ~/.zsh_history 2>/dev/null || echo "Zsh history not found or cleanup failed..."

# 19. Empty Trash Bins
echo "Emptying trash bins..."
rm -rf ~/.local/share/Trash/* 2>/dev/null || echo "User trash not found or couldn't be emptied..."
sudo rm -rf /root/.local/share/Trash/* 2>/dev/null || echo "Root trash not found or couldn't be emptied..."

# 20. Remove Orphaned Packages and Dependencies
echo "Removing orphaned packages..."
sudo apt autoremove --purge -y

# 21. Display Disk Usage Information
echo -e "\n${yellow}Current disk usage summary:${endColor}"
df -h / | grep -E '^/dev/' || df -h /

echo -e "\n${yellow}Large cache directories that might need manual attention:${endColor}"
du -sh ~/.cache/* 2>/dev/null | sort -rh | head -10 || echo "No large cache directories found"

# 22. Final System Information
echo -e "\n${yellow}Memory usage:${endColor}"
free -h

# Completion Message
echo -e "\n${green}Enhanced System Cleanup Completed Successfully!${endColor}"
echo -e "${green}Recommended: Reboot your system to ensure all changes take effect.${endColor}"