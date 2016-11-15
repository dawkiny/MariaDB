#!/usr/bin/perl
use strict; 
use warnings; 

use Net::HandlerSocket; 
my $read_args = { host => 'localhost', port => 9998 }; 
my $hs = new Net::HandlerSocket($read_args); 

my $res = $hs->open_index(0, 'test', 'hs_test', 'PRIMARY', 'id,givenname,surname'); 
  die $hs->get_error() if $res != 0; 

my $pk = 1; 

$res = $hs->execute_single(0, '=', [ "$pk" ], 10, 0); 
  die $hs->get_error() if $res->[0] != 0; 
shift(@$res); 

while ( $res->[0] ) { 
  printf("%s\t%s\t%s\n",$res->[0],$res->[1],$res->[2]); 
  $pk++; 
  $res = $hs->execute_single(0, '=', [ "$pk" ], 20, 0); 
    die $hs->get_error() if $res->[0] != 0; 
  shift(@$res); 
} 

$hs->close();
