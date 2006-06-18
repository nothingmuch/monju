#!/usr/bin/perl

package Catalyst::Match::Private::Benchmarked;
use Moose::Role;

use Time::HiRes ();

has start_time => (
    isa => "ArrayRef",
    is  => "rw",
);

has end_time => (
    isa => "ArrayRef",
    is  => "rw",
);

sub now {
    return [ Time::HiRes::gettimeofday ];
}

sub duration {
    my $self = shift;
    return Time::HiRes::tv_interval( $self->start_time, $self->end_time );
}

after stack_enter => sub {
    $self->start_time( $self->now );
};

before stack_leave => sub {
    $self->end_time( $self->now );
};

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Match::Private::Benchmarked - 

=head1 SYNOPSIS

	use Catalyst::Match::Private::Benchmarked;

=head1 DESCRIPTION

=cut


