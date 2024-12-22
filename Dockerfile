FROM alpine:3
RUN apk --no-cache add make \
&& apk --no-cache add gcc \
&& apk --no-cache add musl-dev \
&& apk --no-cache add unixodbc-dev \
&& apk --no-cache add perl \
&& apk --no-cache add perl-dev \
&& apk --no-cache add perl-app-cpanminus \
&& apk --no-cache add perl-app-cpm \
&& apk --no-cache add perl-b-cow \
&& cpanm URI \
&& cpanm Net::HTTP \
&& cpanm IO::HTML \
&& cpanm Encode::Locale \
&& cpanm HTTP::Date \
&& cpanm LWP::MediaTypes \
&& apk --no-cache add perl-clone \
&& cpanm HTTP::Request \
&& cpanm HTML::Tagset \
&& cpanm HTML::HeadParser \
&& cpanm File::Listing \
&& cpanm HTTP::Cookies \
&& cpanm WWW::RobotRules \
&& cpanm Try::Tiny \
&& cpanm Test::Fatal \
&& apk --no-cache add perl-module-build-tiny \
&& apk --no-cache add perl-http-daemon \
&& cpanm HTTP::Negotiate \
&& cpanm Test::RequiresInternet \
&& cpanm LWP::UserAgent \
&& cpanm Mozilla::CA \
&& cpanm Net::SSLeay \
&& apk --no-cache add perl-lwp-protocol-https \
&& cpanm Algorithm::Diff \
&& cpanm Spiffy \
&& cpanm Text::Diff \
&& apk --no-cache add perl-test-base \
&& apk --no-cache add perl-test-yaml \
&& apk --no-cache add perl-yaml \
&& apk --no-cache add perl-xml-namespacesupport \
&& apk --no-cache add perl-xml-sax-base \
&& apk --no-cache add perl-xml-sax \
&& apk --no-cache add perl-xml-libxml \
&& apk --no-cache add perl-test-warnings \
&& apk --no-cache add perl-exporter-tiny \
&& apk --no-cache add perl-xml-parser \
&& apk --no-cache add perl-sub-uplevel \
&& apk --no-cache add perl-task-weaken \
&& apk --no-cache add perl-mime-types \
&& cpanm XML::SAX::Expat \
&& apk --no-cache add perl-xml-simple \
&& cpanm XSLoader \
&& cpanm List::MoreUtils \
&& cpanm JSON \
&& apk --no-cache add perl-json-xs \
&& cpanm REST::Client \
&& cpanm Net::OAuth2 \
&& apk --no-cache add perl-data-uuid \
&& cpanm Text::CSV \
&& cpanm Text::CSV_XS \
&& cpanm XML::LibXML::PrettyPrint \
&& cpanm JSON::PP \
&& apk --no-cache add perl-dbi \
&& apk --no-cache add perl-dbd-pg \
&& apk --no-cache add perl-dbd-csv \
&& apk --no-cache add perl-dbd-mysql \
&& apk --no-cache add perl-dbd-sqlite \
&& apk --no-cache add perl-dbd-odbc \
&& apk --no-cache add perl-text-soundex \
&& apk --no-cache add perl-sql-statement \
&& apk --no-cache add perl-class-inspector \
&& apk --no-cache add perl-test-warn \
&& apk --no-cache add perl-uri-encode \
&& apk --no-cache add perl-log-log4perl \
&& cpanm IO::SessionData \
&& apk --no-cache add perl-test-requires \
&& cpanm XML::Parser::Lite --force \
&& cpanm SOAP::Lite \
&& cpanm ServiceNow::SOAP \
&& cpanm Clone::Choose \
&& cpanm Hash::Merge \
&& cpanm URI::Escape \
&& cpanm Time::HiRes \
&& cpanm Time::Local \
&& cpanm Storable \
&& cpanm Compress::Zlib \
&& cpanm Text::Balanced \
&& cpanm Text::Banner \
&& cpanm REST::Client \
&& apk --no-cache add libx11-dev \
&& apk --no-cache add libpng-dev \
&& cpanm YAML::XS \
&& cpanm Net::Daemon \
&& cpanm RPC::PlClient \
&& cpanm Net::Azure::StorageClient::Blob \
    && apk del gcc \
    && apk del musl-dev \
	&& apk cache clean \
	&& rm -fr ./cpanm /root/.cpanm \
	&& rm -fr ~/.cpan/build \
    && rm -rf /var/cache/apk/* \
	&& rm -rf /tmp/* /var/tmp/* \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -f /etc/ssh/ssh_host_*

RUN apk --no-cache add bash
RUN mkdir /home/user
WORKDIR /home/user
RUN adduser -D user -s /bin/bash -u 1000 && chown user:user /home/user -R
USER user
COPY test.pl .


# sed -Ez 's/\\[\r,\n]+\s*&&/\nRUN /mg' Dockerfile   | docker build -t test  -

