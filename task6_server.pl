#!/usr/bin/perl
#Perl assignment task 6 UDP SNTP server.
#submitted By: hara12


use strict;
use warnings;
use IO::Socket::INET;

my ($socket,$data,$peerAddr,$peerPort);
$socket = new IO::Socket::INET (
LocalPort => '123',
Proto => 'udp',
) or die "ERROR! Could not create socket. \n";

while(1)
{
print "waiting for new request .... \n";
print"\n";
$socket->recv(my $data,1024);
my $time0 = time();
#unpacking template and string into variables
my @re = unpack ("N12", $data);
# get the IP and port number of client
$peerAddr = $socket->peerhost();
$peerPort = $socket->peerport();
print "Request sent from address : $peerAddr using port number: $peerPort \n";

my $timeStamp = time();
#seconds since 1st January 1900
my $time_sec=2208988800;
my $time = $timeStamp + $time_sec;
#In unicast mode, the Originate Timestamp field is copied unchanged from the Transmit Timestamp field of the request. It is important that this field be copied intact, as a NTP client uses it to check for replays.(RFC 1769)
#unicast message header set to zero except first octet.LV=0,version=4,mode=4(server)
my $time_sent = pack ("I N N N N N N N N N N N",044,$re[1] ,$re[2],$re[3],$re[4],$re[5],0,0,0,0,$time,0);
$socket->send($time_sent); 
}

$socket->close();



