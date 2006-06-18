#!/usr/bin/perl

package Catalyst::Dispatch::Private;
use Moose;

use strict;
use warnings;

use Catalyst::Match::Private::Call;

sub path {}; # FIXME role composition

has path => (
    isa => "ArrayRef",
    is  => "ro",
    auto_deref => 1,
    default    => sub { [] },
);

with qw/Monju::Dispatch::Path/;

has arguments => (
    isa => "ArrayRef",
    is  => "ro",
    auto_deref => 1,
    default    => sub { [] },
);

has context => (
    isa => "Catalyst::Context",
    is  => "ro",
    required => 1,
);

has match_object_class => (
    isa => "Str",
    is  => "ro",
    default => "Catalyst::Match::Private::Call",
);

sub create_match_object {
    my ( $self, $node, %attrs ) = @_;

    return $self->match_object_class->new(
        arguments => scalar($self->arguments),
        context   => $self->context,
        %attrs,
        node      => $node,
    );
}

sub match {
    my ( $self, $node, $localize ) = @_;
    $localize ||= {};
    local @{ $self }{ keys %$localize } = values %$localize; # FIXME clone?

    if ( @{ $self->path } == 0 ) {
        return $self->create_match_object( $node );
    } else {
        $node->match( $self );
    }
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Dispatch::Private - 

=head1 SYNOPSIS

	use Catalyst::Dispatch::Private;

=head1 DESCRIPTION

=cut


