#!/usr/bin/perl

package Monju::Dispatch::CollectByPath;
use Moose::Role;

use Scalar::Util qw/refaddr/;

with qw/Monju::Dispatch::FindByPath/;

has sub_dispatches => (
    isa => "ArrayRef",
    is  => "ro",
    auto_dereef => 1,
    required    => 1,
);

has collected_matches => (
    isa => "HashRef",
    accessor => "_collected_matches",
    lazy     => 1,
    default  => sub { { map { refaddr($_) => [] } $_[0]->sub_dispatches } },
);

around match => sub {
    my $next = shift;
    my ( $self, $node ) = @_;

    my $matches = $self->_collected_matches;
    my %matches;
    @matches{ keys %$matches } = map { [ @{ $matches->{$_} } ] } keys %$matches;

    local $self->{collected_matches} = \%matches_copy; # FIXME nasty

    foreach my $d ( $self->sub_dispatches ) {
        push @{ $matches{ refaddr($d) } }, $d->match( $node ) || undef;
    }

    my $match = $self->$next( $node );

    # wrap the result with whatever we collected unless it's already wrapped
    if ( eval { $match->isa("Monju::Node") } ) {
        return Monju::Match::CollectedByPath->new(
            match => $match, 
            sub_dispatches => scalar( $self->sub_dispatches ),
            collected_matches => \%matches,
        );
    } else {
        return $match;
    }
};

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Dispatch::CollectByPath - 

=head1 SYNOPSIS

	use Monju::Dispatch::CollectByPath;

=head1 DESCRIPTION

=cut


