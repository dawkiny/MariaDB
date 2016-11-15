#!/usr/bin/perl
use strict;
use warnings;

use Net::HandlerSocket;
my $write_args = { host => 'localhost', port => 9999 };
my $hsw = new Net::HandlerSocket($write_args);

my $resw = $hsw->open_index(1, 'test', 'hs_test', 'PRIMARY', 'id,givenname,surname');
  die $hsw->get_error() if $resw != 0;

$resw = $hsw->execute_single(1, '+', [ '7', 'Sylvester', 'McCoy' ],0,0);
  die $hsw->get_error() if $resw->[0] != 0;

$resw = $hsw->execute_single(1, '+', [ '8', 'Paul', 'McGann' ],0,0);
  die $hsw->get_error() if $resw->[0] != 0;

$hsw->close(); 
