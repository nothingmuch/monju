#!/usr/bin/perl

package Monju::Node::Collection::Ordered;
use Moose::Role;

use strict;
use warnings;

with qw/
    Monju::Node::Collection
/;

requires 'get_children_by_index';

requires 'child_exists_by_index';

requires 'get_indices_of_children';

sub get_child_by_index {
    my ( $self, $child ) = @_;
    ($self->get_children_by_index( $child ))[0];
}

sub get_index_of_child {
    my ( $self, $child ) = @_;
    ($self->get_indices_of_children( $child ))[0];
}

sub last_child_index {
    my $self = shift;
    $self->child_count - 1;
}

sub get_previous_sibling {
    my ( $self, $child ) = @_;

    if ( my $index = $self->get_index_of_child( $child ) > 0 ) {
        return $self->get_child_by_index( $index - 1 );
    }

    return;
}

sub get_next_sibling {
    my ( $self, $child ) = @_;

    if ( my $index = $self->get_index_of_child( $child ) < last_child_index ) {
        return $self->get_child_by_index( $index + 1 );
    }

    return;
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Node::Collection::Ordered - An interface role for a node with an ordered
list of children.

=head1 SYNOPSIS

    package My::Node;
    use Moose;

	with "Monju::Node::Collection::Ordered";

=head1 DESCRIPTION

=cut


