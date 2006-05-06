#!/usr/bin/perl

package Catalyst::Dispatch::Public::HTTPRequest;
use Moose;

use strict;
use warnings;

with $_ for qw/
    Monju::Dispatch::Path
    Monju::Dispatch::Localize
/;

# FIXME override path here, make sure it points to URI, etc


__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Dispatch::Public::HTTPRequest - 

=head1 SYNOPSIS

	use Catalyst::Dispatch::Public::HTTPRequest;

=head1 DESCRIPTION

=cut


