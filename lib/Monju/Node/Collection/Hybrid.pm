#!/usr/bin/perl

package Monju::Node::Collection::Hybrid;
use Moose::Role;

use strict;
use warnings;

use Carp qw/croak/;

# FIXME this should be handled by role composition
sub child_names {}
sub child_hash {};

has child_hash => (
    isa => "HashRef",
    is  => "ro",
    auto_deref => 1,
    required   => 1,
);

has child_names => (
    isa => "ArrayRef",
    is  => "ro",
    auto_deref => 1,
);

with $_ for qw/
    Monju::Node::Collection::Named
    Monju::Node::Collection::Ordered
/;

sub BUILD {
    my ( $self, @whatever ) = @_;

    if ( !ref($self->child_names) ) {
        $self->{child_names} = [ sort keys %{ $self->child_hash } ];
    } else {
        my @names = sort $self->child_names;
        my @de_facto = sort keys %{ $self->child_hash };
        unless ( @names == @de_facto and "@names" eq "@de_facto" ) {
            croak "The list of child names must match the list of child_hash keys";
        }
    }
}

sub child_list {
    my $self = shift;
    $self->get_children_by_name( $self->child_names );
}

sub child_count {
    my $self = shift;
    scalar @{ $self->child_names };
}

sub get_children_by_index {
    my ( $self, @indices ) = @_;
    no warnings 'uninitialized'; # allow undef indexes
    $self->get_children_by_name( @{ $self->child_names }[@indices] );
}

sub get_children_by_name {
    my ( $self, @names ) = @_;
    no warnings 'uninitialized'; # allow undef indexes
    @{ $self->child_hash }{ @names };
}

sub child_exists_by_name {
    my ( $self, $name ) = @_;
    exists $self->child_hash->{$name};
}

sub child_exists_by_index {
    my ( $self, $index ) = @_;
    exists $self->child_names->[$index];
}

sub get_names_of_children {
    my ( $self, @children ) = @_;

    my @names;
    my $hash = $self->child_hash;

    child: foreach my $child ( @children ) {
        foreach my $name ( keys %$hash ) {
            if ( $hash->{$name} == $child ) {
                push @names, $name;
                next child;
            }
        }

        push @names, undef;
    }

    return ( wantarray ? @names : $names[0] );
}

sub get_indices_of_children {
    my ( $self, @children ) = @_;

    my @indices;
    my @child_list = $self->child_list;

    child: foreach my $child ( @children ) {
        for ( my $i = 0; $i < @child_list; $i++ ) {
            if ( $child_list[$i] == $child ) {
                push @indices, $i;
                next child;
            }
        }

        push @indices, undef;
    }

    return ( wantarray ? @indices : $indices[0] );
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Node::Collection::Hybrid - Named and Ordered at the same time

=head1 SYNOPSIS

	use Monju::Node::Collection::Hybrid;

=head1 DESCRIPTION

This differs from Collection::Named and Collection::Ordered in that it's practical.

=cut


