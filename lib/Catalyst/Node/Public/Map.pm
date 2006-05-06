#!/usr/bin/perl

package Catalyst::Node::Public::Map;
use Moose;

use strict;
use warnings;

with $_ for qw/
    Monju::Node::Collection::Hybrid
    Monju::Node::Map
    Catalyst::Node::Public
/;

around get_child_for_path => sub { # implement '' key for index/default etc
    my $next = shift;
    my ( $self, $dispatch, @path ) = @_;

    if ( my @match = $self->$next( $dispatch, @path ) ) {
        return @match;
    } else {
        my @res = $self->$next($dispatch, '', @path);
        return @res;
    }
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


