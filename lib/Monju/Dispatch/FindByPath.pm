#!/usr/bin/perl

package Monju::Dispatch::FindByPath;
use Moose::Role;

with qw/
    Monju::Dispatch::Path
    Monju::Dispatch::Localize
/;

sub match {
    my ( $self, $node ) = @_;

    if ( scalar(@{ $self->path }) == 0 ) {
        return $node;
    } else {
        return $node->match( $self );
    }
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Dispatch::FindByPath - 

=head1 SYNOPSIS

	use Monju::Dispatch::FindByPath;

=head1 DESCRIPTION

=cut


