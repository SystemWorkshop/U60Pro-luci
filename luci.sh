sleep 10
rpcd -s /var/run/ubus/ubus.sock &

killall uhttpd 2>/dev/null

/usr/sbin/uhttpd \
  -p 0.0.0.0:80 \
  -h /www \
  -u /ubus \
  -U /var/run/ubus/ubus.sock \
  -o /cgi-bin/luci \
  -O /usr/share/ucode/luci/uhttpd.uc \
  -n 3 \
  -N 100
