#!/usr/bin/perl

package Monju::Dispatch::Path::String;
use Moose::Role;

with "Monju::Dispatch::Path";

requires "split_path";

requires "join_path";

requires "path_string";

sub path {
    my $self = shift;
    $self->split_path( $self->path_string );
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Dispatch::Path::String - String based paths.

=head1 SYNOPSIS

	use Monju::Dispatch::Path::String;

=head1 DESCRIPTION

=cut


