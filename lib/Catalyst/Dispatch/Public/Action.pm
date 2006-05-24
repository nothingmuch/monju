#!/usr/bin/perl

package Catalyst::Dispatch::Public::Action;
use Moose;

use strict;
use warnings;

use aliased "Catalyst::Dispatch::Private::Call";

use Context::Handle qw/context_sensitive/;

extends "Catalyst::Dispatch::Private::Call"; # it actually acts on the private tree

has begin_actions => (
    isa => "ArrayRef",
    is  => "ro",
    auto_deref => 1,
    default    => sub { [] },
);

has auto_actions => (
    isa => "ArrayRef",
    is  => "ro",
    auto_deref => 1,
    default    => sub { [] },
);

has end_actions => (
    isa => "ArrayRef",
    is  => "ro",
    auto_deref => 1,
    default    => sub { [] },
);

sub match {
    my ( $self, $node ) = @_;
    if ( $node->isa("Catalyst::Node::Private::Controller") ) {
        foreach my $name ( qw/begin auto end/ ) {
            my $action = $node->get_child_by_name($name) || next;
            my $method = "${name}_actions";
            push @{ $self->$method }, $action;
        }
    }

    $node->match( $self );
}

around execute => sub { # this is like _DISPATCH in Catalyst::Base
    my $next = shift;
    my ( $self, $action ) = @_;

    # this is how the auto/end/begin actions will get invoked
    # maybe it should really be $c->forwad( $auto ), $c->forward( $begin->[-1] ) etc
    my $call = Call->new(
        context => $self->context,
        arguments => [ ],
    );

    $self->execute_begin( $call );
    $self->execute_auto( $call ) || return;

    # invoke the action itself
    my $rv = context_sensitive { $self->$next( $action ) };

    $self->execute_end( $call );

    $rv->return;
};

sub execute_begin {
    my ( $self, $call ) = @_;
    $call->execute( $self->begin_actions->[-1] || return );
}

sub execute_auto {
    my ( $self, $call ) = @_;

    foreach my $auto ( $self->auto_actions ) {
        return unless $call->execute( $auto );
    }

    return 1;
}


sub execute_end {
    my ( $self, $call ) = @_;
    $call->execute( $self->end_actions->[-1] || return );
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Dispatch::Public::Action - Dispatch on the "found" action, before all forwards

=head1 SYNOPSIS

	use Catalyst::Dispatch::Public::Action;

=head1 DESCRIPTION

=cut


