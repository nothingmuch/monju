#!/usr/bin/perl

package Catalyst::Node::Private::Action;
use Moose;

use strict;
use warnings;

with "Catalyst::Node::Private";

has code => (
    isa => "CodeRef",
    is  => "ro", 
);

has component => (
    isa => "Catalyst::Component::Controller",
    is  => "ro",
);

sub match {
    my ( $self, $dispatch ) = @_;
    my @arguments = ( @{ $dispatch->path }, @{ $dispatch->arguments } );
    $dispatch->execute( $self, { arguments => \@arguments });
}

sub execute {
    my ( $self, $c, @args ) = @_;
    my $code = $self->code;
    $self->component->$code( $c, @args );
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Node::Private::Action - 

=head1 SYNOPSIS

	use Catalyst::Node::Private::Action;

=head1 DESCRIPTION

=cut


