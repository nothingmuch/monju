#!/usr/bin/perl

package Monju::Match::CollectedByPath;
use Moose;

use Scalar::Util qw/refaddr/;

with qw/Monju::Match/; # whatever that is

has sub_dispatches => (
    isa => "ArrayRef",
    is  => "ro",
    auto_deref => 1,
    required   => 1
);

has collected_matches => (
    isa => "HashRef",
    accessor => "_collected_matches",
    required => 1,
);

has match => ( # the original match
    is => "ro",
);

sub matches_for_dispatches {
    my $self = shift;
    @{ $self->_collected_matches }{ map { refaddr($_) } $self->sub_dispatches }; # ordered correctly
}

sub matches_for_dispatch {
    my ( $self, $dispatch ) = @_;
    @{ $self->_collected_matches->{ refaddr($dispatch) } };
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Match::CollectedByPath - 

=head1 SYNOPSIS

	use Monju::Match::CollectedByPath;

=head1 DESCRIPTION

=cut


