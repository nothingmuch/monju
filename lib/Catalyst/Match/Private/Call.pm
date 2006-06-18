#!/usr/bin/perl

package Catalyst::Match::Private::Call;
use Moose;

use strict;
use warnings;

use Context::Handle qw/context_sensitive/;

with "Catalyst::Match::Private";

sub execute {
    my $self = shift;

    my $node = $self->node;

    $self->stack_enter( $node ); # push stack, timing info

    my $rv = eval {
        context_sensitive {
            $node->execute( $self->context, $self->arguments )
        }
    };

    $self->stack_leave( $node, $rv ); # pop stack, timing info

    $self->record_error( $@, $node ) if $@;

    $rv->return;
}

sub stack_enter {
    my ( $self, $node ) = @_;
    $self->context->stack_enter( $node );
}

sub stack_leave {
    my ( $self, $node, $rv ) = @_;
    $self->context->stack_enter( $node, $rv );
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

Catalyst::Match::Private::Call - Base class for Catalyst action invocation thunks.

=head1 SYNOPSIS

	use Catalyst::Match::Private::Call;

=head1 DESCRIPTION

=cut


