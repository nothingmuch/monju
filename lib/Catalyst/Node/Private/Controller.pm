#!/usr/bin/perl

package Catalyst::Node::Private::Controller;
use Moose;

use strict;
use warnings;

with $_ for qw/
    Monju::Node::Collection::Hybrid
    Monju::Node::Map
    Catalyst::Node::Private
/;

has component => (
    isa => "Catalyst::Component::Controller",
    is => "ro",
);

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Node::Private::Controller - 

=head1 SYNOPSIS

	use Catalyst::Node::Private::Controller;

=head1 DESCRIPTION

=cut


