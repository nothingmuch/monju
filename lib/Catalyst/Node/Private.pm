#!/usr/bin/perl

package Catalyst::Node::Private;
use Moose::Role;

use strict;
use warnings;

with "Monju::Node";

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Node::Private - A role that all private catalyst nodes do.

=head1 SYNOPSIS

	use Catalyst::Node::Private;

=head1 DESCRIPTION

This node family represents the internal, private dipsatch tree for Catalyst.

The private tree is what you can ->forward with - no remapping, regex or
anything - just trailing arguments.

=cut


