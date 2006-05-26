#!/usr/bin/perl

package Catalyst::Dispatch::Private::Forward;

use strict;
use warnings;

extends "Catalyst::Dispatch::Private::Call";

around execute => sub {
    my $next = shift;
    my ( $self, @args ) = @_;

    my $state = $self->$next( @args );
    $self->context->state( $state );
    return $state;
}

sub record_error {
    my ( $self, $error, $node ) = @_;
    $self->context->error( $error );
    # no die
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Dispatch::Private::Forward - 

=head1 SYNOPSIS

	use Catalyst::Dispatch::Private::Forward;

=head1 DESCRIPTION

=cut


