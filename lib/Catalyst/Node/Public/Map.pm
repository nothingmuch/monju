#!/usr/bin/perl

package Catalyst::Node::Public::Map;
use Moose;

use strict;
use warnings;

with "Monju::Node::Map";

around get_child => sub { # implement '' key for index/default etc
    my $next = shift;
    my ( $self, $dispatch, $path ) = @_;

    $self->$next( $dispatch, $path ) || $self->$next($dispatch, ['']);
};

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Node::Public::Map - L<Monju::Node::Map> tailored for catalyst

=head1 SYNOPSIS

	use Catalyst::Node::Public::Map;

=head1 DESCRIPTION

This L<Monju::Node::Map> consumer will also try to find a child name '', to
implement C<index> and/or C<default>.

=cut


