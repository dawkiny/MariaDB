#!/usr/bin/perl
use strict;
use warnings;

use Net::HandlerSocket;
my $update_args = { host => 'localhost', port => 9999 };
my $hsu = new Net::HandlerSocket($update_args);

my $resu = $hsu->open_index(2, 'test', 'hs_test', 'PRIMARY', 'givenname');
  die $hsu->get_error() if $resu != 0;

$resu = $hsu->execute_single(2, '=', [ '3' ],1,0, 'U', [ 'Jon' ]);
  die $hsu->get_error() if $resu->[0] != 0;
printf("Number of Updated Rows:\t%s\n",$resu->[1]);

$hsu->close();
