#!/usr/bin/perl

package Monju::Node::Map;
use Moose::Role;

use strict;
use warnings;

with $_ for qw/
    Monju::Node
    Monju::Node::Collection::Named
/;

sub match {
    my ( $self, $dispatch ) = @_; # assumes Monju::Dispatch::Localize
    my @path = @{ $dispatch->path };

    ( my($child), @path ) = $self->get_child_for_path( $dispatch, @path );

    return unless $child;

    $dispatch->match( $child, { path => \@path });
}

sub get_child_for_path {
    my ( $self, $dispatch, @path ) = @_;

    my $name = shift @path;
    
    if ( my $child = $self->get_children_by_name( $name ) ) {
        return ( $child, @path );
    }

    return;
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Node::Map - redirect L<Monju::Dispatch::Path> to nested path elements.

=head1 SYNOPSIS

	use Monju::Node::Map;

=head1 DESCRIPTION

This L<Monju::Node> is of the concrete variety - it can receive any
L<Monju::Dispatch> that C<does> L<Monju::Dispatch::Path> and also C<does>
L<Monju::Dispatch::Localize>.

It contains a registry of child nodes, mapped by name, and it will match the
first element of the path to a child, and continue dispatch over there.

=head1 METHODS

=head2 match $dispatch

When receiving a dispatch of the correct type, this node will look at the first
element of C<< $dispatch->path >> and try to find a child by that name.

If a child is found, it will be passed to the dispatch with a localized path
that does not include the head.

=cut


