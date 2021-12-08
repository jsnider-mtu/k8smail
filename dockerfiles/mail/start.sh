#!/bin/bash

_term() {
  echo "Caught SIGTERM; stopping postfix and dovecot"
  /usr/sbin/postfix stop
  /usr/bin/doveadm stop
}

trap _term SIGTERM

postmap /etc/postfix/canonical
postmap /etc/postfix/virtual
postmap /etc/postfix/virtual-mailbox-domains
postmap /etc/postfix/virtual-mailbox-users

for x in services localtime resolv.conf hosts nsswitch.conf; do
  cp /etc/${x} /var/spool/postfix/etc/
done

/usr/sbin/postfix start
/usr/sbin/dovecot

tail -f /var/log/mail.log & wait ${!}
