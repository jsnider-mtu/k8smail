#!/bin/bash

_term() {
  echo "Caught SIGTERM; stopping opendkim"
  kill -15 $(ps uax|grep opendkim|grep -v grep|awk '{print $2}')
}

trap _term SIGTERM

cp /etc/opendkim/secretmail /etc/opendkim/mail
chown opendkim:opendkim /etc/opendkim/mail
chmod 600 /etc/opendkim/mail
sed -i 's/^module(load="imklog/#module(load="imklog/' /etc/rsyslog.conf
rsyslogd
/usr/sbin/opendkim -x /etc/opendkim.conf -u opendkim -P /run/opendkim/opendkim.pid -p inet:8892

tail -f /var/log/mail.log & wait ${!}
