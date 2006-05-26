#!/usr/bin/perl

package Catalyst::Dispatch::Public::HTTPRequest;
use Moose;

use strict;
use warnings;

sub path {} # FIXME role composition

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

sub match {
    my ( $self, $node ) = @_;
    $node->match( $self );
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Dispatch::Public::HTTPRequest - 

=head1 SYNOPSIS

	use Catalyst::Dispatch::Public::HTTPRequest;

=head1 DESCRIPTION

=cut


