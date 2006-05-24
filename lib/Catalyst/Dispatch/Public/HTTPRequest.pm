#!/usr/bin/perl

package Catalyst::Dispatch::Public::HTTPRequest;
use Moose;

use strict;
use warnings;

with qw/
    Monju::Dispatch::Path
    Monju::Dispatch::Localize
/;

has path => ( # FIXME this should be a delegate of URI
    isa => "ArrayRef",
    is  => "ro",
    auto_deref => 1,
    default    => sub { [] },
);



__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Dispatch::Public::HTTPRequest - 

=head1 SYNOPSIS

	use Catalyst::Dispatch::Public::HTTPRequest;

=head1 DESCRIPTION

=cut


