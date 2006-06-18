#!/usr/bin/perl

package Catalyst::Match::Private;
use Moose::Role;

#use overload '&{}' => "codify";

sub codify {
    my $self = shift;
    return sub { $self->execute(@_) };
}

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

has node => (
    isa => "Catalyst::Node::Private",
    is  => "ro",
    required => 1,
);

requires "execute";

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Match::Private - 

=head1 SYNOPSIS

	use Catalyst::Match::Private;

=head1 DESCRIPTION

=cut


