#!/usr/bin/perl

package Monju::Node;
use Moose::Role;

requires "match";

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Node - Generalized abstract nonsense for web applications.

=head1 SYNOPSIS

    package My::Node;
    use Moose;

	with "Monju::Node";

=head1 DESCRIPTION

The node is an abstract item, roughly coinciding with the nouns of the dispatch
- what can you find in the app.

It receives a dispatch and either returns a result, or passes the dispatch down
to something else.

=head1 METHODS

=head2 match $dispatch

Accept a L<Monju::Dispatch>

=cut


