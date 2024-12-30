# Bash script to automate Clear Cache Ubuntu & Mac

```bash
# running script on ubuntu
make clean-linux

# run script on mac 
make clean-mac 

```


**Create a Cron Job**
```bash 
# open crontab
contab -e

# add a new cron job 
0 1 * * 0 /path/to/cleanup.sh # Run script every Sunday at 1 AM

# verify crontab
crontab -l

# restart cron
sudo systemctl restart cron
# or 
sudo systemctl start cron

# check logs
cat /var/log/syslog | grep cron

```