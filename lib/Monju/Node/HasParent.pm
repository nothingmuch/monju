#!/usr/bin/perl

package Monju::Node::HasParent;
use Moose::Role;

use strict;
use warnings;

use Monju::Node::Collection;

has parent => (
    does => "Monju::Node::Collection",
    is   => "rw",
    weak => 1,
);  

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Node::HasParent - A child node that knows who it's parent is.

=head1 SYNOPSIS

	use Monju::Node::HasParent;

=head1 DESCRIPTION

=cut


