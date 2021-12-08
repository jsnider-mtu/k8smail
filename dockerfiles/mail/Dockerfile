FROM ubuntu:20.04

MAINTAINER "Joshua Snider" <jsnider@mtu.edu>

EXPOSE 25
EXPOSE 143
EXPOSE 587
EXPOSE 993
EXPOSE 4190

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y mail-stack-delivery postfix dovecot-imapd

RUN touch /var/log/mail.log
RUN chmod 666 /var/log/mail.log
RUN touch /etc/ssl/private/chain2021.pem
RUN touch /etc/ssl/private/tinyhippo.ninja.2021.key

RUN echo tinyhippo.ninja > /etc/mailname

RUN groupadd -g 5000 vmail
RUN useradd -g vmail -u 5000 vmail -d /var/mail/vmail -m
RUN usermod -aG dovecot vmail

RUN postfix upgrade-configuration

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
