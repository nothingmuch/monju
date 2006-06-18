#!/usr/bin/perl

package Catalyst::Match::Private::Forward;

use strict;
use warnings;

extends "Catalyst::Match::Private::Call";

around execute => sub {
    my $next = shift;
    my ( $self, @args ) = @_;

    my $state = $self->$next( @args ); # always scalar context
    $self->context->state( $state ); # rv always recorded
    return $state;
}

sub record_error {
    my ( $self, $error, $node ) = @_;
    $self->context->error( $error );

    # no die, unless it's a detach
    die $error if $error == $Catalyst::DETACH;
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Match::Private::Forward - Catalyst forward-to-action thunk.

=head1 SYNOPSIS

	use Catalyst::Match::Private::Forward;

=head1 DESCRIPTION

=cut


