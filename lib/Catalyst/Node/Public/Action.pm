#!/usr/bin/perl

package Catalyst::Node::Public::Action;
use Moose;

use strict;
use warnings;

with "Catalyst::Node::Public";

use aliased "Catalyst::Node::Public::Match::Native";

has private_action_path => (
    isa => "ArrayRef",
    is  => "ro",
);

sub match {
    my ( $self, $dispatch ) = @_;
    
    Native->new(
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

=cut


