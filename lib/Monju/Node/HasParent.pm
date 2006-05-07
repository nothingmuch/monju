#!/usr/bin/perl

package Monju::Node::HasParent;
use Moose::Role;

use strict;
use warnings;

use Monju::Node::Collection;

has parent_node => (
    does => "Monju::Node::Collection",
    is   => "rw",
    weak => 1,
);

sub path_to_root_node {
    my $self = shift;
    
    if ( my $parent = $self->parent_node ) {
        return $self, $parent->path_to_root_node;
    } else {
        return $self;
    }
}

sub calculate_node_depth {
    my $self = shift;

    if ( my $parent = $self->parent_node ) {
        return 1 + $parent->calculate_node_depth;
    } else {
        return 0;
    }
}

sub find_root_node {
    my $self = shift;

    if ( my $parent = $self->parent_node ) {
        return $parent->find_root_node;
    } else {
        return $self;
    }
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Node::HasParent - A child node that knows who it's parent is.

=head1 SYNOPSIS

	use Monju::Node::HasParent;

=head1 DESCRIPTION

=cut


