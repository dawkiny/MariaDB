#!/usr/bin/perl
use strict;
use warnings;

use Net::HandlerSocket;
my $delete_args = { host => 'localhost', port => 9999 };
my $hsd = new Net::HandlerSocket($delete_args);

my $resd = $hsd->open_index(3, 'test', 'hs_test', 'PRIMARY', 'id,givenname,surname');
  die $hsd->get_error() if $resd != 0;

$resd = $hsd->execute_single(3, '+', [ '101', 'Junk', 'Entry' ],1,0);
  die $hsd->get_error() if $resd->[0] != 0;

$resd = $hsd->execute_single(3, '+', [ '102', 'Junk', 'Entry' ],1,0);
  die $hsd->get_error() if $resd->[0] != 0;

$resd = $hsd->execute_single(3, '+', [ '103', 'Junk', 'Entry' ],1,0);
  die $hsd->get_error() if $resd->[0] != 0;

$resd = $hsd->execute_single(3, '>', [ '100' ],10,0, 'D');
  die $hsd->get_error() if $resd->[0] != 0;

printf("Number of Deleted Rows:\t%s\n",$resd->[1]);

$hsd->close();
