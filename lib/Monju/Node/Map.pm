#!/usr/bin/perl

package Monju::Node::Map;
use Moose::Role;

use strict;
use warnings;

has children => (
    isa => "HashRef",
    is  => "ro",
    default => sub { {} },
);

has children => (
    isa => "HashRef",
    is  => "ro",
    default => sub { {} },
);

sub match {
    my ( $self, $dispatch ) = @_; # assumes Monju::Dispatch::Localize
    my @path = @{ $dispatch->path };

    my $child = $self->get_child( $dispatch, \@path );
    return unless $child;

    $dispatch->match( $child, { path => \@path });
}

sub get_child {
    my ( $self, $dispatch, $path ) = @_;
    

    no warnings "uninitialized";
    my $child = $self->children->{ $path->[0] };
    return unless $child;

    pop @$path;
    return $child;
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Node::Map - 

=head1 SYNOPSIS

	use Monju::Node::Map;

=head1 DESCRIPTION

=cut


