#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';

use Test::MockObject::Extends;

use aliased "Catalyst::Node::Private::Controller";
use aliased "Catalyst::Node::Private::Action";
use Catalyst::Dispatch::Private;

{
    package Catalyst::Context;
    use Moose;
    # empty

    package Catalyst::Component::Controller;
    use Moose;
    # empty

    package My::Lovely::Controller;
    use Moose;
    extends "Catalyst::Component::Controller";

    sub foo { return [ foo => @_ ] }

    sub bar { return [ bar => @_ ] }
}
my $comp = My::Lovely::Controller->new();# instances, not classes ;-)


my $foo = Action->new(
    code => $comp->can("foo"),
    component => $comp,
);

my $bar = Action->new(
    code => $comp->can("bar"),
    component => $comp,
);

my $controller = Controller->new(
    component => $comp,
    child_hash => { foo => $foo, bar => $bar },
);

isa_ok( $controller, Controller );
isa_ok( $controller->get_child_by_name("foo"), Action );
is( $controller->get_child_by_name("foo"), $foo, "foo action is correct" );

my $c = Test::MockObject::Extends->new("Catalyst::Context");

$c->mock( enter => sub { } );
$c->mock( leave => sub { } );
$c->mock( error => sub { } );

my $call_foo = Catalyst::Dispatch::Private->new(
    path => [ "foo" ],
    context => $c,
);

my $call_bar = Catalyst::Dispatch::Private->new(
    path => [ "bar" ],
    context => $c,
);

my $call_args = Catalyst::Dispatch::Private->new(
    path => [qw/foo bar gorch/],
    context => $c,
);

is_deeply( $call_foo->match( $controller )->execute,  [ foo => $comp, $c ], "dispatch foo", );
is_deeply( $call_bar->match( $controller )->execute,  [ bar => $comp, $c ], "dispatch bar" );
is_deeply( $call_args->match( $controller )->execute, [ foo => $comp, $c, qw/bar gorch/ ], "dispatch with args" );

