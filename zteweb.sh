sleep 12
/usr/sbin/uhttpd \
  -f \
  -p 0.0.0.0:8080 \
  -h /usr/zte_web/web \
  -x /cgi-bin \
  -u /ubus \
  -U /var/run/ubus/ubus.sock
