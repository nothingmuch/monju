#!/usr/bin/perl

package Monju::Node::Collection::Hybrid::Mutable;
use Moose::Role;

use Monju::Node::Named;

use Carp qw/croak/;
use List::MoreUtils qw/any/;

with qw/
    Monju::Node::Collection::Hybrid
    Monju::Node::Collection::Named::Mutable
    Monju::Node::Collection::Ordered::Mutable
/;

has '+child_hash' => (
    default  => sub { {} },
    required => 0,
);

sub set_child_by_name {
    my ( $self, $name, $child ) = @_;

    if ( $self->child_exists_by_name( $name ) ) {
        $self->child_hash->{$name} = $child;
    } else {
        $self->child_hash->{$name} = $child;
        push @{ $self->child_names }, $name;
    }

    $self->attach_child_nodes( $child );
}

sub splice_children {
    my ( $self, $from, $to, @replacements ) = @_;

    foreach my $child ( @replacements ) {
        croak "Child nodes inserted by splicing must know their own name"
            unless eval { $child->does("Monju::Node::Named") };
    };

    my @names = map { $_->name } @replacements;

    my @delete = splice( @{ $self->child_names }, $from, $to, @names );

    my @spliced_out = delete @{ $self->child_hash }{ @delete };

    $self->detach_child_nodes( @spliced_out );
    $self->attach_child_nodes( @replacements );

    @{ $self->child_hash }{ @names } = @replacements;

    @spliced_out;
}

sub remove_children_by_name {
    my ( $self, @names ) = @_;
    
    my @deleted = delete @{ $self->child_hash }{ @names };
    $self->detach_child_nodes( @deleted );
   
    @{ $self->child_names } = grep {
        my $existing = $_;
        not any { $_ eq $existing } @names;
    } @{ $self->child_names };

    @deleted;
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Node::Collection::Hybrid::Mutable - Adds a write-api to the Hybrid collection.

=head1 SYNOPSIS

    package My::Node;
	use Moose;

    with "Monju::Node::Collection::Hybrid::Mutable";
    
=head1 DESCRIPTION

This role assimilates L<Monju::Node::Collection::Hybrid>, and adds writability
to it.

=cut


