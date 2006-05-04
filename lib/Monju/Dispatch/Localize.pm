#!/usr/bin/perl

package Monju::Dispatch::Localize;
use Moose::Role;

use strict;
use warnings;
no warnings "uninitialized";

with "Monju::Dispatch";

use Scalar::Util qw/reftype/;

around qw/execute match/ => sub {
    my $next = shift;
    my ( $self, @args ) = @_;
    
    if ( reftype( my $localize = $args[-1] ) eq "HASH" ) {
        pop @args;
        local @{ $self }{keys %$localize} = values %$localize;
        # $self = $self->meta->clone_instance( $self, %$localize );
        $self->$next( @args );
    } else {
        $self->$next( @args );
    }
};

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Dispatch::Localize - 

=head1 SYNOPSIS

	use Monju::Dispatch::Localize;

=head1 DESCRIPTION

=cut


