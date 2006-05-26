#!/usr/bin/perl

package Catalyst::Match::Public;
use Moose::Role;

use strict;
use warnings;

requires "derive";

requires "execute";

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Match::Public - A successful match on the public tree.

=head1 SYNOPSIS

	use Catalyst::Match::Public;

=head1 DESCRIPTION

When the public dispatcher is matched against
L<Catalyst::Dispatch::Public::HTTPRequest> it should return a
L<Catalyst::Match::Public> object.

The default, Match::Native, corresponds with a private action in the private
tree. Match::Native->execute encapsulates L<Catalyst>'s C<handle_request>
function.

Nested frameworks should return something that does
the C<Catalyst::Match::Public> role to be invokable from L<Catalyst>
applications.

In the event that no match is found it is assumed that there is no applicable
resource.

=head1 METHODS

=over 4

=item derive

When a match is returned from within a sub node, the parent node may inform the
Match of additional fields that it has collected for it.

The match can ignore or assimilate this information (for example - additional
arguments, the matched path, regex node captures, etc).

=item execute %params

This method encapsulates handle_request.

It receives the engine-level request object that the
L<Catalyst::Dispatch::Public::HTTPRequest> object was constructed with, and the
application (anything really). In the Native request the application is what
contains the dispatch trees and facilitates the construction of $c, etc.

=back

=cut


