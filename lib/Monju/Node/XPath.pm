#!/usr/bin/perl

package Monju::Node::XPath;
use Moose::Role;

use Monju::Node::XPath::DocRoot;

use Tree::XPathEngine;
use Tree::XPathEngine::Number;

with qw/
    Monju::Node::Named
    Monju::Node::HasParent
    Monju::Node::Collection::Ordered
/;

has '+parent_node' => (
    does => "Monju::Node::XPath",
);

requires "xpath_get_value";

requires "xpath_get_attributes";

sub xpath_string_value {
    my $self = shift;
    $self->xpath_get_value;
}

sub xpath_to_string {
    my $self = shift;
    sprintf '%s="%s"', $self->name, $self->xpath_string_value;
}

sub xpath_to_number {
    my $self = shift;
    Tree::XPathEngine::Number->new( $self->xpath_get_value );
}

sub xpath_get_name {
    my $self = shift;
    $self->name;
}

sub xpath_get_next_sibling {
    my $self = shift;
    $self->parent_node->get_next_sibling( $self );
}

sub xpath_get_previous_sibling {
    my $self = shift;
    $self->parent_node->get_previous_sibling( $self );
}

sub xpath_get_root_node {
    my $self = shift;
    Monju::Node::XPath::DocRoot->new( node => $self->find_root_node );
}

sub xpath_get_parent_node {
    my $self = shift;
    $self->parent_node;
}

sub xpath_get_child_nodes {
    my $self = shift;
    $self->child_list;
}

sub xpath_cmp {
    my ( $x, $y ) = @_;
    return 1 if $y->isa("Monju::Node::XPath::DocRoot");

    return 0 if $x == $y;

    my @x_path = $x->path_to_root_node;
    my @y_path = $y->path_to_root_node;

    while ( $x_path[-2] == $y_path[-2] ) {
        pop @x_path;
        pop @y_path;
    }

    $x_path[-1]->get_index_of_child( $x_path[-2] )
        <=>
    $y_path[-1]->get_index_of_child( $y_path[-2] )
}

sub xpath_is_element_node { return 1 }

sub xpath_is_document_node { return }

sub xpath_is_attribute_node { return }

sub xpath_is_text_node { return }


__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Node::XPath - Tree::XPathEngine support for Monju::Node hierarchies.

=head1 SYNOPSIS

	use Monju::Node::XPath;

=head1 DESCRIPTION

=cut


