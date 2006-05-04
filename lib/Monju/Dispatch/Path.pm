#!/usr/bin/perl

package Monju::Dispatch::Path;
use Moose::Role;

use strict;
use warnings;

with "Monju::Dispatch";

has path => (
    isa => "ArrayRef",
    is  => "ro",
    default => sub { [] },
);

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Dispatch::WithPath - Path oriented dispatching

=head1 SYNOPSIS

	use Monju::Dispatch::WithPath;

=head1 DESCRIPTION

=cut


