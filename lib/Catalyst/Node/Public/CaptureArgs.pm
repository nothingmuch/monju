#!/usr/bin/perl

package Catalyst::Node::Public::CaptureArgs;
use Moose;

has count => (
    isa => "Undef | Int",
    is  => "ro",
);

has child => (
    isa => "Catalyst::Node::Public",
    is  => "ro",
    required => 1,
);

sub match {
    my ( $self, $dispatch ) = @_;
    my @path_elements = $dispatch->path;

    my ( $captured, $remaining );

    if ( defined( my $count = $self->count ) ) {
        $captured = [ splice @path_elements, 0, $self->count ];
        $remaining = \@path_elements;
    } else {
        $captured = \@path_elements;
        $remaining = [];
    }

    my $match = $dispatch->match( $self->child, ({ path => $remaining }) ) || return;
    return $match->derive({ arguments => $captured });
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Node::Public::CaptureArgs - Argument capturing semantics

=head1 SYNOPSIS

	use Catalyst::Node::Public::CaptureArgs;

=head1 DESCRIPTION

Capture a certain number or all of the path elements at this point as
arguments, and invoke the nested L<Catalyst::Node::Public> with an empty path.

=cut


