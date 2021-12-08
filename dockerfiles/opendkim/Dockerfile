FROM ubuntu:20.04

MAINTAINER "Joshua Snider" <jsnider@mtu.edu>

EXPOSE 8892

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y opendkim opendkim-tools rsyslog

RUN mkdir /etc/opendkim
RUN chown opendkim:opendkim /etc/opendkim

RUN echo 'mail.tinyhippo.ninja mail.tinyhippo.ninja:mail:/etc/opendkim/mail' > /etc/opendkim/KeyTable
RUN echo '*@tinyhippo.ninja mail.tinyhippo.ninja' > /etc/opendkim/SigningTable
RUN echo '127.0.0.1' > /etc/opendkim/TrustedHosts

RUN chown -R opendkim:opendkim /etc/opendkim

RUN sed -i 's/^Socket/#Socket/;s/^UserID/#UserID/' /etc/opendkim.conf

RUN echo 'Canonicalization        relaxed/relaxed' >> /etc/opendkim.conf
RUN echo 'ExternalIgnoreList      refile:/etc/opendkim/TrustedHosts' >> /etc/opendkim.conf
RUN echo 'InternalHosts           refile:/etc/opendkim/TrustedHosts' >> /etc/opendkim.conf
RUN echo 'KeyTable                refile:/etc/opendkim/KeyTable' >> /etc/opendkim.conf
RUN echo 'SigningTable            refile:/etc/opendkim/SigningTable' >> /etc/opendkim.conf
RUN echo 'LogWhy                  Yes' >> /etc/opendkim.conf
RUN echo 'Socket                  inet:8892' >> /etc/opendkim.conf
RUN echo 'SyslogSuccess           Yes' >> /etc/opendkim.conf
RUN echo 'TemporaryDirectory      /var/tmp' >> /etc/opendkim.conf
RUN echo 'UserID                  opendkim:opendkim' >> /etc/opendkim.conf

RUN echo tinyhippo.ninja > /etc/mailname

RUN touch /var/log/mail.log
RUN chown syslog:adm /var/log/mail.log

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
