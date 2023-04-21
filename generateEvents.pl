#!/usr/bin/env perl
#curl -ks --json '{"event": {"firstTime":"2023-04-21 04:04:04", "entity":"newTest", "severity":"WARNING", "eventType":"CREATE","alertSummary":"http alert","alertNotes":"something","eventSource":"Solarwinds","serviceName":"network service","eventID":"iu82jdsd822dksd","eventGroups":"OS","eventStatus":"OPEN"}}' https://43.205.54.81/events.json
use strict;
use Data::GUID qw(guid_string);
use Data::Random qw(:all);

my @severity = qw(WARNING INFO CRITICAL);
my @eventType = qw(CREATE);
my @eventStatus = qw(OPEN);
my @alertSummary;
my @alertNotes;
my @eventSource = qw(Solarwinds Nagios Zabbix Site24x7 PRTG Elasticsearch Logstash Datadog Splunk Dynatrace NewRelic);
my @serviceName;
my @eventGroups = qw(DB Linux Windows Network App1 App2 App3 Svc1 Svc2 Svc3 Storage Vmware AWS GCP Azure);

my $rand_ts = rand_datetime(min => '2023-01-01', max => 'now');
my @entity = rand_words(size=>1);
my @rand_severity = rand_set(set => \@severity, size => 1);
my $eventID = rand_chars(set => 'alphanumeric', min => 12, max => 16);
my @alertSummary = rand_words(min => 2, max => 8);
my @alertNotes = rand_words(min => 10, max => 25);
my @rand_eventSource = rand_set(set => \@eventSource, size => 1);
my @serviceName = rand_words(min => 1, max => 3);
my @rand_eventGroups = rand_set(set => \@eventGroups, size => 1);

print "firstTime: $rand_ts \
entity: @entity \
severity: @rand_severity \
eventType: @eventType \
alertSummary: @alertSummary \
alertNotes: @alertNotes \
eventSource: @rand_eventSource \
serviceName: @serviceName \
eventID: $eventID \
eventGroups: @rand_eventGroups \
eventStatus: @eventStatus \
";

__END__
#Backup routines
my @temp = localtime(time);
my $ts = sprintf ( "%04d-%02d-%02d %02d:%02d:%02d", $temp[5]+1900,$temp[4]+1,$temp[3],$temp[2],$temp[1],$temp[0]);
my $eventID = guid_string();
