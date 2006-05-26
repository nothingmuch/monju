#!/usr/bin/perl

package Monju::Dispatch;
use Moose::Role;

use strict;
use warnings;

requires "match";

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Dispatch - Generalized abstract nonsense for web applications.

=head1 SYNOPSIS

    package My::Dispatch;
    use Moose;

	with "Monju::Dispatch";

=head1 DESCRIPTION

The dispatch is an abstract entity which dictates the "how", the verb part, if
you will, of the dispatching process.

It is given a root L<Monju::Node> to start matching on. The node represents the
"what", vaguely noun of the dispatch (the request can also be seen as a noun,
but the dispatch encapsulates that).

Every family of L<Monju::Node> classes accepts a related family of
L<Monju::Dispatch> classes. The node, typically to be a tree containing other
nodes, encapsulates the traversal structure according to what was dictated by
the dispatch.

=head1 METHODS

=head2 match $node

Accept a L<Monju::Node>.

See also L<Monju::Node/match>.

=head1 SEE ALSO

http://en.wikipedia.org/wiki/Mathematical_jargon

=cut


