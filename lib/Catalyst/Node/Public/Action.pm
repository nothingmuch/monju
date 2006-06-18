#!/usr/bin/perl

package Catalyst::Node::Public::Action;
use Moose;

use strict;
use warnings;

with "Catalyst::Node::Public";

use Catalyst::Match::Public::Action;

has private_action_path => (
    isa => "ArrayRef",
    is  => "ro",
);

sub match {
    my ( $self, $dispatch ) = @_;

    return unless scalar(@{ $dispatch->path }) == 0; # we only match when the path is empty

    Catalyst::Match::Public::Action->new(
        private_action_path => $self->private_action_path,
    );
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Node::Public::Action - An end point in the public dispatch tree, that matches an action

=head1 SYNOPSIS

	use Catalyst::Node::Public::Action;

=head1 DESCRIPTION

This is the only point in the L<Catalyst::Node::Public> tree that actually
matches - the leaf, if you will.

It returns a L<Catalyst::Node::Public::Match::Action> object that contains a
private action path.

The parent nodes are responsible for filling in all other information.

=cut


