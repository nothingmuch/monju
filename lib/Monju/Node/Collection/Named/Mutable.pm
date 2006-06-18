#!/usr/bin/perl

package Monju::Node::Collection::Named::Mutable;
use Moose::Role;

with "Monju::Node::Collection::Named";

requires 'remove_children_by_name';

requires 'set_child_by_name';

sub add_named_children {
    my ( $self, @children ) = @_;
    $self->set_child_by_name( $_->name, $_) for @children;
}

sub remove_named_children {
    my ( $self, @children ) = @_;
    $self->remove_children_by_name( map { $_->name } @children );
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Node::Collection::Named::Mutable - An interface role with a write api
for name-keyed collections.

=head1 SYNOPSIS

	use Monju::Node::Collection::Named::Mutable;

=head1 DESCRIPTION

=cut


