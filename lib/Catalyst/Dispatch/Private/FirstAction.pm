#!/usr/bin/perl

package Catalyst::Dispatch::Private::FirstAction;
use Moose;

use strict;
use warnings;

use aliased "Catalyst::Match::Private::Call";
use aliased "Catalyst::Match::Private::FirstAction";

use Context::Handle qw/context_sensitive/;

extends "Catalyst::Dispatch::Private";

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

before match => sub { # FIXME replace with CollectByPath role
    my ( $self, $node ) = @_;

    if ( $node->isa("Catalyst::Node::Private::Controller") ) {
        foreach my $name ( qw/begin auto end/ ) {
            my $action = $node->get_child_by_name($name) || next;
            my $method = "${name}_actions";
            push @{ $self->$method }, $action;
        }
    }
};

sub match_object_class {
    return FirstAction;
}

around create_match_object => sub {
    my $next = shift;
    my ( $self, @args ) = @_;

    my $begin = ( $self->begin_actions )[-1];
    my $auto  = $self->auto_actions;
    my $end   = ( $self->end_actions )[-1];

    $self->$next(
        @args, 
        begin_action => $begin,
        auto_actions => $auto,
        end_action   => $end,
    );
};

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Dispatch::Private::FirstAction - Dispatch on the "found" action, before all forwards

=head1 SYNOPSIS

	use Catalyst::Dispatch::Private::FirstAction;

=head1 DESCRIPTION

=cut


