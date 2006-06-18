#!/usr/bin/perl

package Catalyst::Match;
use Moose::Role;

#use overload '&{}' => "codify";

sub codify {
    my $self = shift;
    return sub { $self->execute(@_) };
}

requires "execute";

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Match - Results from dispatch trees.

=head1 SYNOPSIS

	use Catalyst::Match;

=head1 DESCRIPTION

This is not a useful class per see, but within the scope of L<Catalyst>'s
dispatch trees, all result objects from standard dispatches
(L<Catalyst::Dispatch::Public>, L<Catalyst::Dispatch::Private>) are match
objects, which means that they respond to the C<execute> method.

Match objects are like thunks. They encapsulate all the parameters of an
invocation, like a fully curried function, and are thus useful both for action
execution, and for deferred actions (such as currying, continuation emulation,
etc).

=cut


