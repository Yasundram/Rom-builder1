# download

df -h
free -h
nproc
cat /etc/os*
env

url=https://gdrive.peersalik16.workers.dev/0:/ccache/ccache-ci2/ccache.tar.gz

cd /tmp
time aria2c $url -x16 -s50
time tar xf ccache.tar.gz
rm -rf ccache.tar.gz

sudo dd if=/dev/zero of=/swapfile bs=32,768 count=33,554,432
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo /swapfile swap swap defaults 0 0 > /etc/fstab
sudo swapon --show

# monitor

export CCACHE_DIR=/tmp/ccache
sleep 2m

while :
do
ccache -s
echo ''
top -b -i -n 1
sleep 1m
done

# upload

cd /tmp

com ()
{
    tar --use-compress-program="pigz -k -$2 " -cf $1.tar.gz $1
}

time com ccache 1

mkdir -p ~/.config/rclone
echo "$rclone_config" > ~/.config/rclone/rclone.conf
time rclone copy ccache.tar.gz aosp:ccache/ccache-ci2 -P
