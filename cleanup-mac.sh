#!/bin/bash

# Colors for output
green='\e[32m'
red='\e[31m'
endColor='\e[0m'

echo -e "${green}Starting Full Advanced System Cleanup...${endColor}\n"

# 1. Clean Homebrew Cache
echo "Cleaning Homebrew cache..."
brew cleanup -s
brew autoremove
brew doctor

# 2. Clean Node.js (npm & yarn) Cache
echo "Cleaning Node.js (npm & yarn) cache..."
npm cache clean --force
yarn cache clean

# 3. Clean Python Pip Cache
echo "Cleaning Python pip cache..."
pip cache purge

# 4. Clean Docker Cache and Unused Volumes
echo "Cleaning Docker cache, volumes, and networks..."
docker system prune -a --volumes -f
docker volume prune -f
docker network prune -f
echo "Restarting Docker service..."
brew services restart docker

# 5. Clean Telegram Cache
echo "Cleaning Telegram cache..."
rm -rf ~/Library/Application\ Support/Telegram/Telegram\ Desktop/tdata/cache/*

# 6. Clean Google Chrome and Chromium Cache
echo "Cleaning Google Chrome and Chromium cache..."
rm -rf ~/Library/Caches/Google/Chrome/*
rm -rf ~/Library/Caches/Chromium/*

# 7. Clean Temporary Files and Cache
echo "Cleaning temporary files and system cache..."
sudo rm -rf /private/var/tmp/* /tmp/*
rm -rf ~/Library/Caches/*

# 8. Clear System Logs and Old Logs
echo "Removing old system logs..."
sudo find /var/log -type f -name "*.log" -mtime +7 -delete

# 9. Clean VS Code Cache and Extensions
echo "Cleaning VS Code cache and extensions..."
rm -rf ~/Library/Application\ Support/Code/Cache/*
rm -rf ~/.vscode/extensions/*
rm -rf ~/Library/Application\ Support/Code/CachedData/*

# 10. Clean Firefox and Brave Browser Cache
echo "Cleaning Firefox and Brave browser cache..."
rm -rf ~/Library/Caches/Firefox/*
rm -rf ~/Library/Application\ Support/BraveSoftware/Brave-Browser/Default/Cache/*

# 11. Clean ZSH and Bash History
echo "Cleaning Bash and ZSH history..."
cat /dev/null > ~/.bash_history && history -c
cat /dev/null > ~/.zsh_history

# 12. Remove Large Unused Files
echo "Finding and removing large unused files..."
du -ah ~ 2>/dev/null | grep -E "[0-9]{3,}M" | sort -rh | head -n 30

# 13. Remove Orphaned Homebrew Packages
echo "Removing orphaned Homebrew packages..."
brew autoremove

# 14. Empty Trash Bins
echo "Emptying user Trash bins..."
rm -rf ~/.Trash/*
sudo rm -rf /Volumes/*/.Trashes

# 15. Clean Go (golang) Cache
echo "Cleaning Go build cache..."
go clean -cache -modcache -testcache -fuzzcache

# Completion Message
echo -e "\n${green}Advanced System Cleanup Completed Successfully!${endColor}"
