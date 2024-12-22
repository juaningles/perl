#!/usr/depot/perl/bin/perl

use URI;
use Net::HTTP;
use IO::HTML;
use Encode::Locale;
use HTTP::Date;
use LWP::MediaTypes;
use HTTP::Request;
use HTML::Tagset;
use HTML::HeadParser;
use File::Listing;
use HTTP::Cookies;
use WWW::RobotRules;
use Try::Tiny;
use Test::Fatal;
use HTTP::Daemon;
use HTTP::Negotiate;
use Test::RequiresInternet;
use LWP::UserAgent;
use Mozilla::CA;
use Net::SSLeay;
use IO::Socket::SSL;
use LWP::Protocol::https;
use Algorithm::Diff;
use Spiffy;
use Text::Diff;
use Test::Base;
use Test::YAML;
use YAML;
use XML::NamespaceSupport;
use XML::SAX::Base;
use XML::SAX;
use XML::LibXML;
use Test::Warnings;
use Exporter::Tiny;
use XML::Parser;
use Sub::Uplevel;
use Task::Weaken;
use MIME::Types;
use XML::SAX::Expat;
use XML::Simple;
use XSLoader;
use List::MoreUtils;
use JSON;
use REST::Client;
use Net::OAuth2;
use Data::UUID;
use Text::CSV;
use Text::CSV_XS;
use XML::LibXML::PrettyPrint;
#use JSON::PP;
use JSON;
use DBI;
use DBD::Pg;
use DBD::mysql;
# -> use DBD::ODBC;

use Clone;
use Text::Soundex;
use SQL::Statement;
use DBD::CSV;

use Class::Inspector;
use Test::Warn;
use IO::SessionData;
use Test::Requires;
use XML::Parser::Lite;
use SOAP::Lite;
use ServiceNow::SOAP;

use Storable qw( retrieve nstore );
use Compress::Zlib qw ( compress uncompress );

use Test::Warn;

use Text::Balanced qw(extract_bracketed);
use Text::Banner;
use Text::CSV;
use Text::CSV_XS;

#use Tk;

use Time::HiRes qw( time);
use Time::Local;

use URI::Escape;


use XML::Simple;
#use YAML::XS;
use POSIX qw(strftime);

use REST::Client;

use XML::Parser::Lite;

use JSON::XS;
use YAML::XS;
use URI::Encode;
use JSON::MaybeXS;
use Log::Log4perl;


print "Test of perl libraries was successful\n"
