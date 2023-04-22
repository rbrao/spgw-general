#!/usr/bin/env perl
use strict;
use Data::Random qw(:all);
use Getopt::Long;
use JSON;

our $min_datetime = '2023-01-01';
our @severity = qw(WARNING INFO CRITICAL);
our @eventType = qw(CREATE);
our @eventStatus = qw(OPEN);
our @eventSource = qw(Solarwinds Nagios Zabbix Site24x7 PRTG Elasticsearch Logstash Datadog Splunk Dynatrace NewRelic);
our @eventGroups = qw(DB Linux Windows Network App1 App2 App3 Svc1 Svc2 Svc3 Storage Vmware AWS GCP Azure);

our ($verbose, $usage, $url, $count);
our $curlCommand = "/usr/bin/curl -ks ";
our $curlOptions = "--json ";
GetOptions ( 'v|verbose' => \$verbose, 'h|help' => \$usage, 'url:s' => \$url, 'count:s' => \$count );
do { print "USAGE: $0 -url <url of event sources handler> -count <#of events to generate>\n"; exit(0) } if ( (defined $usage) || (not defined $url) || (not defined $count) );

for ( my $i=0; $i<$count; $i++) {
	randomEvent();
}

sub randomEvent {
	my $rand_ts = rand_datetime(min => $min_datetime, max => 'now');
	my @entity = rand_words(size => 1);
	my $rand_severity = rand_enum(set => \@severity);
	my $rand_eventType = rand_enum(set => \@eventType);
	my @alertSummary = rand_words(min => 2, max => 8);
	my @alertNotes = rand_words(min => 10, max => 25);
	my $rand_eventSource = rand_enum(set => \@eventSource);
	my @serviceName = rand_words(min => 1, max => 3);
	my $eventID = rand_chars(set => 'alphanumeric', min => 12, max => 16);
	my $rand_eventGroups = rand_enum(set => \@eventGroups);
	my $rand_eventStatus = rand_enum(set => \@eventStatus);

	my $json_string = JSON->new->utf8->encode( {
		firstTime => $rand_ts,
		entity => join(' ', @entity),
		severity => $rand_severity,
		eventType => $rand_eventType,
		alertSummary => join(' ', @alertSummary),
		alertNotes => join(' ', @alertNotes),
		eventSource => $rand_eventSource,
		serviceName => join(' ', @serviceName),
		eventID => $eventID,
		eventGroups => $rand_eventGroups,
		eventStatus => $rand_eventStatus
	} );
	print "{\"event\"\: $json_string }\n" if (defined $verbose);
	my $out = qx($curlCommand $curlOptions '{"event": $json_string }' $url 2>/dev/null);	chomp($out);
	print "$out\n";
}

__END__
#curl -ks --json '{"event": {"firstTime":"2023-04-21 04:04:04", "entity":"newTest", "severity":"WARNING", "eventType":"CREATE","alertSummary":"http alert","alertNotes":"something","eventSource":"Solarwinds","serviceName":"network service","eventID":"iu82jdsd822dksd","eventGroups":"OS","eventStatus":"OPEN"}}' https://43.205.54.81/events.json
#Backup routines
use Data::GUID qw(guid_string);
my @temp = localtime(time);
my $ts = sprintf ( "%04d-%02d-%02d %02d:%02d:%02d", $temp[5]+1900,$temp[4]+1,$temp[3],$temp[2],$temp[1],$temp[0]);
my $eventID = guid_string();
