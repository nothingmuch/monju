#!/usr/bin/perl

package Catalyst::Dispatch::Private::Call;
use Moose;

use strict;
use warnings;

use Context::Handle qw/context_sensitive/;

with "Catalyst::Dispatch::Private";

sub execute {
    my ( $self, $node ) = @_;

    my $c = $self->context;

    $c->enter( $node ); # push stack, timing info

    my $rv = eval {
        context_sensitive {
            $node->execute( $c, $self->arguments )
        }
    };

    $c->leave( $node, $rv ); # pop stack, timing info

    $self->record_error( $@, $node ) if $@;

    $rv->return;
}

sub record_error {
    my ( $self, $error, $node ) = @_;
    $self->context->error( $error );
    die $error
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Dispatch::Private::Call - Base class for Catalyst action invocations.

=head1 SYNOPSIS

	use Catalyst::Dispatch::Private::Call;

=head1 DESCRIPTION

=cut


