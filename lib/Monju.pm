#!/usr/bin/perl

package Monju;

use strict;
use warnings;



__PACKAGE__;

__END__

=pod

=head1 NAME

Monju - Web application dispatcher toolkit.

=head1 DESCRIPTION

Monju is a toolkit for writing web application dispatchers and other related
things.

It provides two features:

=head2 A role based protocol

Monju imposes a very general, potentially purely functional protocol for
dispatching stuff.

It revolves around two roles, L<Monju::Dispatch> and L<Monju::Node>, both of
which only have a single method: C<match>.

This protocol has been optimized for polymorphism, in the hopes of enabling
pluggability down to the lowest levels.

=head2 Reusable code

Monju also ships with lots of reusable code.

This code library is split into combinators (nesting, alternative lists, etc),
containers (mappings, regular expression dispatch, path operations) and
standalone components (drop in solutions).

These parts a wide spectrum, from completely generic to web-programming
specific.

=head1 CODE LIBRARY

=head2 Combinators

These roles are completely generic, their to ease traversal style disptach.

=head3 Monju::Node::Try

The Try combinator is like a boolean OR operation, returning the first
successful match from an ordered set of nodes.

=head3 Monju::Dispatch::Localize

Localization support for dispatchers is crucial for proper nesting - it allows
containing nodes to alter the view their children are receiving.

=head2 Containers

Containers are more aware of the dispatch and their children, providing
implemtations to common dispatcher patterns.

=head3 Monju::Dispatch::Path

=head3 Monju::Node::Map

=head3 Monju::Node::Regex

Path based dispatch introduces the notion of a hierarchy in which there are named
children.

The Regex and Map containers send localized dispatches to their children, based
on the path they receive.

=head2 Conponents

These stand alone components can be used to provide certain types of services
for your web application.

=head1 DESIGN

The dispatching process is assumed to be generally like a referntially
transparent recursive call graph, traversing downwards till the target node
returns a successful match.

This design is heavily influenced by functional programming styles, and that
topic is essentially required background.

=head1 ETYMOLOGY

Monju is named for the Japanese fast breeder nuclear reactor. This is both
consistent with other Catalyst spinoff names (L<Isotope>, L<Reaction>,
L<Catalyst::Enzyme>).

The name also has an underlying metaphor: fast breeder reactors need only
consume a small portion of Pu-239 to "start up", after which they enrich U-238
into Pu-239 by themselves, creating more fuel than there was to begin with.

We hope that Monju (the module) will similarly perpetuate into a platform that
will allow web frameworks to intermix, resulting in more "energy" than it
actually came with.

Within the context of Budhism, Manjushri, is a bodhisattva. In Japanese his
name is Monju, and he has a nuclear reactor named after him. However, Monju
represets concepts far more novel than Monju the module hopes to attain =).

As a side note, Monju (the reactor) is neither very successful or popular.
Hopefully this module will not meet the same fate.

=head1 SEE ALSO

L<Catalyst>, L<Jifty>, L<http://en.wikipedia.org/wiki/Monju>, 

=cut


