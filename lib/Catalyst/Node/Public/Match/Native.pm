#!/usr/bin/perl

package Catalyst::Node::Public::Match::Native;
use Moose;

use strict;
use warnings;

use Scalar::Util qw/reftype/;
use Catalyst::Dispatch::Public::Action;

with "Catalyst::Node::Public::Match";

# this is the path to the private action that should be invoked
has private_action_path => (
    isa => "ArrayRef",
    is  => "ro",
    required => 1,
);


# this is meta data collected while traversing the public dispatch tree
has captures => (
    isa => "ArrayRef",
    is  => "ro",
    default => sub { [] },
);

has matched_path => (
    isa => "String",
    is  => "ro",
);

has arguments => (
    isa => "ArrayRef",
    is  => "ro",
    default => sub { [] },
);

# .... more attrs you find in Catalyst::Request


sub execute {
    my ( $self, %params ) = @_;

    my $catalyst_req = $self->make_request( %params );
    my $context = $self->make_context( %params, request => $catalyst_req );

    my $d = Catalyst::Dispatch::Public::Action->new(
        context   => $context,
        path      => $self->private_action_path,
        arguments => $self->arguments,
        # ....
    );

    my $rv = $d->match( $params{application}->private_dispatcher );

    my $res = $context->response;
    $res->return_value( $rv );

    return $res;
}

sub derive {
    my ( $self, $additional ) = @_;
    $self->meta->clone_instance( $self, %{ $self->merge_keys($additional) } );
}

sub merge_keys {
    my ( $self, $additional ) = @_;

    return { map {
        $_ => $self->merge_key( $_, $additional->{$_}, $self->$_ );
    } keys %$additional };
}

sub merge_key { # a bit like a multimethod
    my ( $self, $name, $new, $old ) = @_;
    return $new || $old; # FIXME this sucks right now, should have a policy per key
    # arguments: concatenate, [ @$new, @$old ],
    # captures: concatenat, [ $new, @$old ], # nested array refs?
    # path, match: $new || $old
}

sub make_request {
    my ( $self, %params ) = @_;
    my $creq = Test::MockObject->new;

    $creq->set_always( engine_req => $params{request} ); # creq has engine_req as it's delegate, actually
}

sub make_context {
    my ( $self, %params ) = @_;
    # $params{application} will help us construct these objects - they are Catalyst level stuff, not Isotope level stuff
    my $c = Test::MockObject::Extends->new("Catalyst::Context");
    
    $c->set_always( request => $params{request} );

    my $res = Test::MockObject->new;
    my $rv_closure_var;
    $res->mock( return_value => sub { shift; $rv_closure_var = shift if @_; $rv_closure_var } );

    $c->set_always( response => $res );

    $c;
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Node::Public::Match::Native - A native 

=head1 SYNOPSIS

	use Catalyst::Node::Public::Match::Native;

=head1 DESCRIPTION

This L<Catalyst::Node::Public::Match> object represents a successfully located
resource within the Catalyst public dispatcher.

It encapsulates all the meta data that will be later be made available using
L<Catalyst::Request> (regex captures, trailing arguments, etc).

It also contains the path of the private action that should be invoked to
implement this match.

=head1 METHODS

=over 4

=item derive $hashref

Add new keys. This merges data into the match object.

Currently it masks the old data, but in the future it should concatenate
argument lists, etc.

=item execute $engine_req, %params

This method encapsulates the handle_request cycle in Catalyst 5.6x.

By the time we're here we're sure that what the request wanted was indeed a
catalyst action (as opposed to a static file, nested request, etc)

What this does is

=over 4

=back

=item construct the context object

The request object is constructed based on the engine request somewhere in @args, and the data we've collected in $self

=item Create the Dispatch::Public::Action, with the context in place

=item ->match the dispatch on the private dispatch tree

The private dispatch tree is provided by $params{application}

=item return the Catalyst::Response object from the context object

=back

=head1 TODO

This uses Test::MockObject to fake some stuff. That ought to go, by
implementing something like Catalyst::Application, which helps  construct the
various objects.

=cut


