FROM ubuntu:20.04

MAINTAINER "Joshua Snider" <jsnider@mtu.edu>

EXPOSE 783

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y spamass-milter pyzor razor libmail-dkim-perl rsyslog

RUN echo tinyhippo.ninja > /etc/mailname

RUN adduser --shell /bin/false --home /var/lib/spamassassin \
    --disabled-password --disabled-login --gecos "" spamd
RUN usermod -a -G spamd spamass-milter

RUN echo 'loadplugin Mail::SpamAssassin::Plugin::TextCat' >> /etc/spamassassin/init.pre

RUN sed -i '/^#####.*/a bayes_path \/var\/lib\/spamassassin\/.spamassassin\/bayes' /etc/spamassassin/local.cf && \
    sed -i '/^bayes_path.*/a bayes_file_mode 0777' /etc/spamassassin/local.cf && \
    sed -i '/^bayes_file_mode.*/a ok_languages en\nok_locales en' /etc/spamassassin/local.cf && \
    sed -i '/^ok_locales en$/a razor_config /var/lib/spamassassin/.razor/razor-agent.conf' /etc/spamassassin/local.cf && \
    sed -i '/^razor_config.*/a pyzor_options --homedir /var/lib/spamassassin/.pyzor' /etc/spamassassin/local.cf

RUN sa-update

RUN mkdir /var/lib/spamassassin/.razor
RUN mkdir /var/lib/spamassassin/.pyzor

RUN razor-admin -home=/var/lib/spamassassin/.razor -register
RUN razor-admin -home=/var/lib/spamassassin/.razor -create
RUN razor-admin -home=/var/lib/spamassassin/.razor -discover
RUN echo 'razorhome = /var/lib/spamassassin/.razor' >> /var/lib/spamassassin/.razor/razor-agent.conf

RUN chown -R spamd:spamd /var/lib/spamassassin

RUN touch /var/log/spamd.log
RUN chown syslog:adm /var/log/spamd.log

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
