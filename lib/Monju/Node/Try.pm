#!/usr/bin/perl

package Monju::Node::Try;
use Moose;

use strict;
use warnings;

with qw/
    Monju::Node
    Monju::Node::Collection::Ordered
/;

has children => (
    isa => "ArrayRef",
    is  => "ro",
);

sub match {
    my ( $self, $dispatch ) = @_;
    foreach my $child ( $self->child_list ) {
        my $res = $dispatch->match( $child ) || next;
        return $res;
    }

    return;
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Node::Try - A behavioral node role to return the first match from an
ordered collection of child nodes.

=head1 SYNOPSIS

	use Monju::Node::Try;

=head1 DESCRIPTION

=cut


