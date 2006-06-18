#!/usr/bin/perl

package Moose::Meta::Role::SkipBuild;
use Moose;

use Moose::Role ();

use Context::Handle qw/context_sensitive/;

sub import {
    my ( $class, @import ) = @_;

    no strict 'refs';
    my $meta = __PACKAGE__->new( role_name => scalar caller );
    *{ caller() . "::meta" } = sub { $meta };

    shift @_;
    unshift @_, "Moose::Role";
    goto \&Moose::Role::import;
}

extends qw/Moose::Meta::Role/;

around _check_required_methods => sub {
    my $next = shift;
    my ( $self, @args ) = @_;

    my $rv = context_sensitive { eval { $self->$next( @args ) } };
    die $@ if $@ and $@ !~ /BUILD/;
    $rv->return;
};

__PACKAGE__;

__END__

=pod

=head1 NAME

Moose::Meta::Role::SkipBuild - 

=head1 SYNOPSIS

	use Moose::Meta::Role::SkipBuild;

=head1 DESCRIPTION

=cut


