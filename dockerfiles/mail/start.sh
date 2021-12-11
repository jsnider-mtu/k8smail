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

mkdir /etc/dovecot/sieve-after

for x in $(ls /etc/dovecot/sieve-after-config); do
  sievec /etc/dovecot/sieve-after-config/${x} /etc/dovecot/sieve-after/${x}.svbin
  chmod 644 /etc/dovecot/sieve-after/${x}.svbin
  cp /etc/dovecot/sieve-after-config/${x} /etc/dovecot/sieve-after/${x}.sieve
done

/usr/sbin/postfix start
/usr/sbin/dovecot

tail -f /var/log/mail.log & wait ${!}
