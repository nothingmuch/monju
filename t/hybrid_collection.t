#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Exception;

{
    package My::Lovely::Node;
    use Moose;

    ::lives_ok {
        with "Monju::Node::Collection::Hybrid";
    } "load hybrid";

    package My::Lovely::Mutable::Node;
    use Moose;

    ::lives_ok {
        with "Monju::Node::Collection::Hybrid::Mutable";
    } "load hybrid::mutable";

    package My::Lovely::Named;
    use Moose;

    sub name {}; # FIXME this should be handled by role composition

    has name => (
        isa => "Str",
        is  => "ro",
        required => 1,
    );

    ::lives_ok {
        with "Monju::Node::Named";
    } "load named role";

    package My::Lovely::Unbastard;
    use Moose;

    with "Monju::Node::HasParent";
}

my $r = "My::Lovely::Node";
my $m = "My::Lovely::Mutable::Node";

can_ok( $r, "new" );
can_ok( $m, "new" );

dies_ok { $r->new } "immutable requires initial hash";

dies_ok { $r->new( child_hash => { foo => 1 }, child_names => [] ) } "child_names must match child_hash";

{ local $TODO = "+attr/required not working";
lives_ok { $m->new } "no required params for mutable";
};

foreach my $class ( $r, $m ) {
    isa_ok( my $node = $class->new( child_hash => { foo => 1, bar => 2 } ), $class );

    can_ok( $node, "child_names" );
    is_deeply( [ $node->child_names ], [ qw/bar foo/ ], "names are queryable" );

    can_ok( $node, "child_list" );
    is_deeply( [ $node->child_list ], [ 2, 1 ], "child list in correct order" );

    can_ok( $node, "child_exists_by_name" );
    ok( $node->child_exists_by_name('foo'), "exists by name" );
    ok( !$node->child_exists_by_name('moose'), "!exists by name" );

    can_ok( $node, "get_children_by_name" );
    is( $node->get_children_by_name('foo'), 1, "get child by name");
    is( $node->get_children_by_name('kjghat'), undef, 'get child by name (!exists)');

    is_deeply( [ $node->get_children_by_name(qw/foo bar/) ], [ 1, 2 ], "get_children_by_name");

    can_ok( $node, "get_names_of_children" );
    is_deeply( [ $node->get_names_of_children( 1, 2, 2, 1 ) ], [ qw/foo bar bar foo/ ], "get names" );

    can_ok( $node, "get_indices_of_children" );
    is_deeply( [ $node->get_indices_of_children( 1, 2, 2, 1 ) ], [ 1, 0, 0, 1 ], "get indices" );

    can_ok( $node, "child_exists_by_index" );
    # FIXME - the child_names default not being triggered by mutable *REALLY* sucks
    ok( eval { $node->child_exists_by_index( 1 ) }, "exists by index" );
    ok( !eval { $node->child_exists_by_index( 4 ) }, "!exists by index" );
}

my $node = $m->new(
    child_hash => {
        moose => 1,
        elk => 2,
        dingbat => 3,
   },
   child_names => [ qw/elk moose dingbat/ ],
);

isa_ok( $node, $m );

is_deeply( [ $node->child_names ], [qw/elk moose dingbat/], "child names when specified manually");
is_deeply( [ $node->child_list ], [ 2, 1, 3 ], "child list matches");

is( $node->get_indices_of_children(3), 2, "index of dingbat");

can_ok( $node, "remove_children_by_name" );
$node->remove_children_by_name(qw/elk moose/);

is( $node->get_indices_of_children(3), 0, "index of dingbat");

is_deeply( [ $node->child_names ], ["dingbat"], "one child remains");
is_deeply( [ $node->child_list ], [3], "list matches" );


dies_ok {
    $node->push_children( "la" );
} "Can't push non node item";

dies_ok {
    $node->push_children( $r->new(child_hash => {}) );
} "Can't push unnamed node";

my $foo;
lives_ok {
    $node->push_children( $foo = My::Lovely::Named->new( name => "foo" ) );
} "named nodes are OK";

is_deeply( [ $node->child_names ], [qw/dingbat foo/], "foo appended to name list");
is_deeply( [ $node->child_list ], [ 3, $foo ], "foo in child_list too");

is( $node->get_names_of_children($foo), "foo", "name of foo" );
is( $node->get_indices_of_children($foo), 1, "index of foo" );

can_ok( $node, "set_child_by_name" );
$node->set_child_by_name( bar => 4 );
$node->set_child_by_name( baz => 5 );

is_deeply( [ $node->child_names ], [ qw/dingbat foo bar baz/ ], "all names are in place" );
is_deeply( [ $node->child_list ], [ 3, $foo, 4, 5 ], "child list matches" );

$node->set_child_by_name( bar => 6 );

is_deeply( [ $node->child_names ], [ qw/dingbat foo bar baz/ ], "all names are in place" );
is_deeply( [ $node->child_list ], [ 3, $foo, 6, 5 ], "child list matches" );

can_ok( $node, "shift_child" );

is( $node->shift_child, 3, "shift" );

can_ok( $node, "child_count" );
is( $node->child_count, 3, "got 3 kids" );

is_deeply( [ $node->child_names ], [ qw/foo bar baz/ ], "all names are in place" );
is_deeply( [ $node->child_list ], [ $foo, 6, 5 ], "child list matches" );

can_ok( $node, "pop_child" );

is( $node->pop_child, 5, "pop" );

is_deeply( [ $node->child_names ], [ qw/foo bar/ ], "all names are in place" );
is_deeply( [ $node->child_list ], [ $foo, 6 ], "child list matches" );

can_ok( $node, "unshift_children" );
$node->unshift_children( My::Lovely::Named->new(name => "disco"), My::Lovely::Named->new(name => "dancing") );

is_deeply( [ $node->child_names ], [ qw/disco dancing foo bar/ ], "all names are in place" );

can_ok( $node, "remove_children_by_indices" );
$node->remove_children_by_indices( 1, 2 );
is_deeply( [ $node->child_names ], [ qw/disco bar/ ], "all names are in place" );

my ( $has_parent_1, $has_parent_2 ) = map { My::Lovely::Unbastard->new } 1 .. 2;

$node->set_child_by_name( "thingy" => $has_parent_1 );

is( $has_parent_1->parent_node, $node, "parent associated" );
is( $has_parent_2->parent_node, undef, "parent not associated" );

$node->remove_children_by_name( qw/thingy/ );

is( $has_parent_1->parent_node, undef, "parent not associated" );
