#!/bin/bash

_term() {
  echo "Caught SIGTERM; stopping spamass-milter and spamassassin"
  /etc/init.d/spamass-milter stop
  kill -15 $(cat /var/run/spamd.pid)
}

trap _term SIGTERM

sed -i 's/^module(load="imklog/#module(load="imklog/' /etc/rsyslog.conf
rsyslogd
source /etc/default/spamassassin && /usr/sbin/spamd -d --pidfile=/var/run/spamd.pid $OPTIONS
/etc/init.d/spamass-milter start

tail -f /var/log/spamd.log & wait ${!}
