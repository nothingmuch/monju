#!/usr/bin/perl

package Monju::Node::Collection::Ordered;
use Moose::Role;

use strict;
use warnings;

requires 'child_list';

requires 'child_count';

requires 'get_children_by_index';

requires 'child_exists_by_index';

requires 'get_indices_of_children';

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Node::Collection::Ordered - An interface role for a node with an ordered
list of children.

=head1 SYNOPSIS

    package My::Node;
    use Moose;

	with "Monju::Node::Collection::Ordered";

=head1 DESCRIPTION

=cut


