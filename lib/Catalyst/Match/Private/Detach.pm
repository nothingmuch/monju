#!/usr/bin/perl

package Catalyst::Match::Private::Detach;

use strict;
use warnings;

extends "Catalyst::Match::Private::Forward";

after execute => sub {
    die $Catalyst::DETACH;
};

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Match::Private::Detach - Catalyst detach-to-action thunk.

=head1 SYNOPSIS

	use Catalyst::Match::Private::Detach;

=head1 DESCRIPTION

=cut


