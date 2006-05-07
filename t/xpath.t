#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';

{
    package My::Monju::Xpath::Minimal;
    use Moose;

    use Tree::XPathEngine;

    with $_ for qw/
        Monju::Node::Collection::Hybrid::Mutable
        Monju::Node::XPath
    /;

    BEGIN {
        has name => (
            isa => "Str",
            is  => "rw",
        )
    };

    sub xpath_get_value { "the_value" };

    sub xpath_get_attributes { }

}

my $xp = Tree::XPathEngine->new();

sub node ($;@) {
    my $node = My::Monju::Xpath::Minimal->new( name => shift, child_hash => {} );
    $node->push_children( @_ );
    return $node;
}

my $foo = node 'foo';
my $bar = node 'bar';
my $root = node root => $foo, $bar;

# abs paths
foreach my $cxt ( $root, $foo, $bar ) {
    is( ($xp->findnodes("/", $cxt))[0]->node, $root, "docroot from " . $cxt->name);
    is_deeply( [ $xp->findnodes("/root", $cxt) ], [ $root] , "root from " . $cxt->name);
    is_deeply( [ $xp->findnodes("/root/foo", $cxt) ], [ $foo ], "foo from " . $cxt->name);
    is_deeply( [ $xp->findnodes("/root/bar", $cxt) ], [ $bar ], "bar from " . $cxt->name);
}

# to parent
foreach my $cxt ( $foo, $bar ) {
    is_deeply( [ $xp->findnodes("..", $cxt) ], [ $root ] , "root from " . $cxt->name);
    is_deeply( [ $xp->findnodes("../foo", $cxt) ], [ $foo ] , "foo from " . $cxt->name);
    is_deeply( [ $xp->findnodes("../bar", $cxt) ], [ $bar ] , "bar from " . $cxt->name);
}

# etc
