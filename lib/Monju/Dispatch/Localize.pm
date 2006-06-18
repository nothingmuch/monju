#!/usr/bin/perl

package Monju::Dispatch::Localize;
use Moose::Role;

no warnings "uninitialized";

with "Monju::Dispatch";

use Scalar::Util qw/reftype blessed/;

around qw/match/ => sub {
    my $next = shift;
    my ( $self, @args ) = @_;

    my ( $localized, @spliced_args ) = $self->localize( @args );
    $localized->$next( @args );
};

sub localize {
    my ( $self, @args ) = @_;
    
    if ( !blessed($args[-1]) and reftype( my $localize = $args[-1] ) eq "HASH" ) {
        pop @args;
        return ($self->meta->clone_instance( $self, %$localize ), @args);
    }

    return ($self, @args);
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Dispatch::Localize - 

=head1 SYNOPSIS

	use Monju::Dispatch::Localize;

=head1 DESCRIPTION

=cut


