#!/usr/bin/perl

package Catalyst::Node::Public;
use Moose::Role;

use strict;
use warnings;

with "Monju::Node";

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Node::Public - A role that all public catalyst nodes do.

=head1 SYNOPSIS

	use Catalyst::Node::Public;

=head1 DESCRIPTION

This is "the" dispatch tree for Catalyst - the private tree is represented by
nodes with variying behavior (some are key maps L<Catalyst::Public::Node::Map>,
some are regexes L<catalyst::Public::Node::Regex>, etc), and also encapsulates
the semantics of argument gobbling, etc.

=cut


