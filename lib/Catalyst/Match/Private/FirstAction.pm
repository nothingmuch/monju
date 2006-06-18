#!/usr/bin/perl

package Catalyst::Match::Private::FirstAction;
use Moose;

extends "Catalyst::Match::Private::Call";

use aliased "Catalyst::Match::Private::Call";

use Context::Handle qw/context_sensitive/;


has begin_action => (
    isa => "Catalyst::Node::Private",
    is  => "ro",
);

has auto_actions => (
    isa => "ArrayRef",
    is  => "ro",
    auto_deref => 1,
    default    => sub { [] },
);

has end_action => (
    isa => "Catalyst::Node::Private",
    is  => "ro",
);

around execute => sub { # this is like _DISPATCH in Catalyst::Base
    my $next = shift;
    my ( $self, $action ) = @_;

    # this is how the auto/end/begin actions will get invoked
    # maybe it should really be $c->forwad( $auto ), $c->forward( $begin->[-1] ) etc

    $self->execute_pre_action || return;

    # invoke the action itself
    my $rv = context_sensitive { $self->$next( $action ) };

    $self->execute_post_action;

    $rv->return;
};

sub execute_pre_action {
    my $self = shift;

    $self->execute_begin;

    return $self->execute_auto;
}

sub execute_post_action {
    my $self = shift;

    $self->execute_end;
}

sub call {
    my ( $self, $node, @args ) = @_;

    Call->new(
        node      => $node,
        arguments => \@args,
        context   => $self->context,
    )->execute();
}

sub execute_begin {
    my ( $self ) = @_;
    $self->call( $self->begin_action || return );
}

sub execute_auto {
    my ( $self ) = @_;

    foreach my $auto ( $self->auto_actions ) {
        return unless $self->call( $auto );
    }

    return 1;
}

sub execute_end {
    my ( $self ) = @_;
    $self->call( $self->end_action || return );
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Match::Private::FirstAction - A thunk for the forward to the first
action (begin, autos, end).

=head1 SYNOPSIS

	use Catalyst::Match::Private::FirstAction;

=head1 DESCRIPTION

=cut


