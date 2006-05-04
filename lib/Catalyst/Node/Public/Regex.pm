#!/usr/bin/perl

package Catalyst::Node::Public::Regex;
use Moose;

use strict;
use warnings;

extends "Catalyst::Node::Public";

has children => (
    isa     => "ArrayRef",
    is      => "ro",       # you edit the ref
    default => sub { [] }, # FIXME shared defaults
);

sub match {
    my ( $self, $dispatch ) = @_;
    $self->try_path_parts( $dispatch, [ $self->split_path( $dispatch->path ) ], [] );
}

sub try_path_parts {
    # this is a greedy backtracker (or rather retrier)
    my ( $self, $dispatch, $path, $tail ) = @_;

    {
        if ( my $match = $self->try_match( $dispatch, \@path, \@tail ) ) {
            return $match;
        }

        return unless @$path;

        unshift @$tail, pop @$path;
        redo; # almost recursive ;-)
    }
}

sub try_path {
    my ( $self, $dispatch, $path, $tail ) = @_;

    my $path_string = $self->join_path( @$path );

    foreach my $child ( @{ $self->children } ) {
        my ( $pattern, $node ) = @$child;

        # $node is likely a Catpure

        if ( my @captures = ( $path_string =~ $pattern ) ) {
            if ( my $match = $dispatch->match( $node, path => $tail ) ) { # localize the path to what we couldn't match
                # return a composite match
                return $dispatch->found(
                    node     => $self,
                    captures => \@captures,
                    path     => $path,
                    submatch => $match,
                );
            );


            push {
                captures => \@captures,
                match => $
        }

    return $dispatch->select(
        map { $dispatch->dispatch( $_->[1] ) }
            grep { $self->match( $dispatch, $_->[0] ) }
                @{ $self->children }
    );
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Node::Public::Regex - 

=head1 SYNOPSIS

	use Catalyst::Node::Public::Regex;

=head1 DESCRIPTION

=cut


