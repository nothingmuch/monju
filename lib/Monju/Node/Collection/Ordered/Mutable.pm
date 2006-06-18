#!/usr/bin/perl

package Monju::Node::Collection::Ordered::Mutable;
use Moose::Role;

with "Monju::Node::Collection::Ordered";

requires 'splice_children';

sub remove_children_by_indices {
    my ( $self, @indices ) = @_;
    # splice out from end to begining in order to not recalculate indices
    $self->remove_child_by_index( $_ ) for sort { $b <=> $a } @indices;
}

sub remove_child_by_index {
    my ( $self, $index ) = @_;
    $self->splice_children( $index, 1 );
}

sub set_child_by_index {
    my ( $self, $index, $child ) = @_;
    $self->splice_children( $index, 1, $child );
}

sub push_children {
    my ( $self, @children ) = @_;
    $self->splice_children( $self->child_count, 0, @children );
}

sub unshift_children {
    my ( $self, @children ) = @_;
    $self->splice_children( 0, 0, @children );
}

sub pop_child {
    my $self = shift;
    ($self->splice_children( -1, 1 ))[0];
}

sub shift_child {
    my $self = shift;
    ($self->splice_children( 0, 1 ))[0];
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Node::Collection::Ordered::Mutable - An interface role with a write-api
for ordered collections.

=head1 SYNOPSIS

    package My::Node;
    use Moose;

	with "Monju::Node::Collection::Ordered::Mutable";

=head1 DESCRIPTION

=cut


