#!/usr/bin/perl

package Monju::Node::Collection::Named;
use Moose::Role;

use strict;
use warnings;

with $_ for qw/
    Monju::Node::Collection
/;

requires 'child_hash';

requires 'child_names'; # must be the same order as child_list in Ordered collection

requires 'get_children_by_name';

requires 'child_exists_by_name';

requires 'get_names_of_children';

sub get_child_by_name {
    my ( $self, $name ) = @_;
    ( $self->get_children_by_name( $name ) )[0];
}   

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Node::Collection::Named - An interface role for a node with named children.

=head1 SYNOPSIS

    package My::Node;
    use Moose;

	with "Monju::Node::Collection::Named";

=head1 DESCRIPTION

=cut


