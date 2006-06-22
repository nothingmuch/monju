#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

BEGIN {
    plan skip_all => "This test requires Class::Workflow" unless eval { require Class::Workflow };

    plan 'no_plan';
}

use Test::MockObject;
use Test::Exception;

use Catalyst::Dispatch::Private;
use ok "Catalyst::Node::Workflow::Transition";

my $w = Class::Workflow->new(
    transition_class => "Catalyst::Node::Workflow::Transition",
);

{
    package Catalyst::Component::Controller;
    use Moose;
    # empty

    package MyController;
    use Moose;

    sub accept {
        my ( $self, $c, $instance, @args ) = @_;
        return ( {}, "MyController::accept" );
    }

    extends "Catalyst::Component::Controller";
}

my $comp = MyController->new;

$w->transition(
    name => "accept",
    code => \&MyController::accept,
    component => $comp,
    to_state  => $w->state("open"),
);

$w->state(
    name        => "new",
    transitions => [qw/accept/],
);

$w->initial_state( "new" );

isa_ok( $w->transition("accept"), "Catalyst::Node::Private::Action" );

my $c = Test::MockObject->new();
$c->set_isa("Catalyst::Context");
$c->set_bound( get_workflow_instance => \( my $current_instance ) );
$c->mock( set_workflow_instance => sub { $current_instance = pop } );

$c->mock($_ => sub { }) for qw/error stack_enter stack_leave/;

$c->set_always( stash => \( my %stash ) );

my $instance = $w->new_instance();

$current_instance = $instance;

my $thunk = Catalyst::Dispatch::Private->new(
    path => [],
    context => $c,
)->match( $w->transition("accept") );

isa_ok( $thunk, "Catalyst::Match::Private::Call" );

is( $instance->state, $w->state("new"), "state is new" );

my $rv;
lives_ok { $rv = $thunk->execute } "execute transition";

my $new_instance = $current_instance;

is( $rv, "MyController::accept", "rv from action is returned" );

ok( $new_instance, "a new instance was set" );
isnt( $new_instance, $instance, "instances are the same" );
is( $new_instance->prev, $instance, "prev of new is old" );
is( $new_instance->state, $w->state("open"), "state changed" );

throws_ok { $thunk->execute } qr/not in.*current state/, "can't execute transition when not in the right state";



