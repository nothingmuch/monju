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

Monju, named for the Japanese fast breeder reactor, is a toolkit for writing
web application dispatchers and other related things.

It provides two features:

=head2 A protocol

Monju imposes a very general, potentially purely functional protocol for
dispatching things.

It revolves around two roles, L<Monju::Dispatch> and L<Monju::Node>, both of
which only have a single method: C<match>.

=head2 Reusable code

Monju also ships with reusable code that follows the above mentioned protocol.

This code library is split into combinators (nesting, alternative lists, etc),
containers (file system like mappings, regular expression dispatch, argument
collecting) and standalone components (static file dispatcher, example
dispatcher). These cover a wide spectrum, from being completely generic to
HTTP/web application specific.

=cut


