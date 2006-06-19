#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::MockObject;
use Test::MockObject::Extends;

use aliased "Catalyst::Node::Private::Namespace";
use aliased "Catalyst::Node::Private::Action";

use aliased "Catalyst::Dispatch::Public::HTTPRequest";
use aliased "Catalyst::Node::Public::Map";
use aliased "Catalyst::Node::Public::Action" => "PublicAction";
use aliased "Catalyst::Node::Public::CaptureArgs";;

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

my $controller = Namespace->new(
    component => $comp,
    child_hash => { foo => $foo, bar => $bar },
);


my $public_foo = CaptureArgs->new(
    count => undef, # capture any number
    child => PublicAction->new(
        private_action_path => ["foo"],
    ),
);

my $public_bar = CaptureArgs->new(
    count => undef, # capture any number
    child => PublicAction->new(
        private_action_path => ["bar"],
    ),
);

my $root_ns = Map->new(
    child_hash => { "" => $public_foo, bar => $public_bar },
);

my $get_index = HTTPRequest->new(
    # .... this is pretty vague, it should contain everything an Isotope::Request has
    # and in addition consume roles like Monju::Dispatch::Path, Monju::Dispatch::Localized, etc
    # providing DWIM methods that map to the request itself.
    path => ["la"],
);

my $match = $get_index->match( $root_ns );

isa_ok( $match, "Catalyst::Match::Public::Action" );

is_deeply( $match->private_action_path, ["foo"] );

my $req = Test::MockObject->new; # "engine" level request object
my $app = Test::MockObject->new; # context factory

$app->set_always( private_dispatcher => $controller );

my $res = $match->execute( requrest => $req, application => $app ); # presumably this would get anything else the engine has to offer

my $rv = $res->return_value;
is( @$rv, 4, "four elements in rv");
is( $rv->[0], "foo", "correct action invoked" );
is( $rv->[1], $comp, "on correct component" );
isa_ok( $rv->[2], "Catalyst::Context" );
is( $rv->[3], "la", "argument swallowed" );
