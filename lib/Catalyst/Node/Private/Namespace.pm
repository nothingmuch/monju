#!/usr/bin/perl

package Catalyst::Node::Private::Namespace;
use Moose;

sub BUILD { # FIXME SkipBuild
    my ( $self, @args ) = @_;

    $self->Monju::Node::Collection::Hybrid::BUILD( @args );
}

with qw/
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

Catalyst::Node::Private::Namespace - 

=head1 SYNOPSIS

	use Catalyst::Node::Private::Namespace;

=head1 DESCRIPTION

=cut


