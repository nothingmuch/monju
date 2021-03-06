#!/usr/bin/perl

package Catalyst::Node::Private::Action;
use Moose;

with "Catalyst::Node::Private";

has name => (
    isa => "Str",
    is  => "ro",
);

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
    my @arguments = ( $dispatch->path, $dispatch->arguments );
    $dispatch->match( $self, { path => [], arguments => \@arguments });
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


