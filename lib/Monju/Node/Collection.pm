#!/usr/bin/perl

package Monju::Node::Collection;
use Moose::Role;

use strict;
use warnings;

requires 'child_list';

requires 'child_count';

sub BUILD {
    my $self = shift;
    $self->attach_child_nodes( $self->child_list );
}

sub attach_child_nodes {
    my ( $self, @children ) = @_;
    $_->parent( $self ) for grep { blessed($_) && $_->does("Monju::Node::HasParent") } @children;
}

sub detach_child_nodes {
    my ( $self, @children ) = @_;
    $_->parent( undef ) for grep { blessed($_) && $_->does("Monju::Node::HasParent") } @children;
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Node::Collection - 

=head1 SYNOPSIS

	use Monju::Node::Collection;

=head1 DESCRIPTION

=cut


