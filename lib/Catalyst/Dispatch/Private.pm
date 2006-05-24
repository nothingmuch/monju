#!/usr/bin/perl

package Catalyst::Dispatch::Private;
use Moose::Role;

use strict;
use warnings;

has path => (
    isa => "ArrayRef",
    is  => "ro",
    auto_deref => 1,
    default    => sub { [] },
);

with qw/Monju::Dispatch::Path/;

has arguments => (
    isa => "ArrayRef",
    is  => "ro",
    auto_deref => 1,
    default    => sub { [] },
);

has context => (
    isa => "Catalyst::Context",
    is  => "ro",
    required => 1,
);

sub match {
    my ( $self, $node, $localize ) = @_;
    $localize ||= {};
    local @{ $self }{ keys %$localize } = values %$localize; # FIXME clone?
    $node->match( $self );
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Dispatch::Private - 

=head1 SYNOPSIS

	use Catalyst::Dispatch::Private;

=head1 DESCRIPTION

=cut


