#!/usr/bin/perl

package Monju::Node::Workflow::Transition;
use Moose::Role;

with qw/
    Monju::Node
    Class::Workflow::Transition
/;

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Node::Workflow::Transition - A node that is also a
L<Class::Workflow::Transition>.

=head1 SYNOPSIS

    package MyNode;
    use Moose;

	with qw/Monju::Node::Workflow::Transition/

=head1 DESCRIPTION

=head1 SEE ALSO

L<Catalyst::Node::Workflow::Transition> - catalyst actions as transitions.

=cut

