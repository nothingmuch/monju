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
    my ( $self, $req, $app, @extra ) = @_;

    # this method encapsulates the handle_request cycle in Catalyst 5.6x
    # FIXME

    # by the time we're here we're sure that what the request wanted was indeed a catalyst action (as opposed to a static file, nested request, etc)
    # what's left to do is:
    # * construct the context object
    # ** The request object is constructed based on the engine request somewhere in @args, and the data we've collected in $self
    # * Create the Dispatch::Public::Action, with the context in place
    # * ->match the dispatch on the private dispatch tree
    # * return the result object from the context object

    my $catalyst_req = $self->make_request( $req, $app );
    my $context = $self->make_context( $catalyst_req, $app );

    my $d = Catalyst::Dispatch::Public::Action->new(
        context   => $context,
        path      => $self->private_action_path,
        arguments => $self->arguments,
        # ....
    );

    my $rv = $d->match( $app->private_dispatcher );

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
    my ( $self, $req ) = @_;
    my $creq = Test::MockObject->new;

    $creq->set_always( engine_req => $req ); # creq has engine_req as it's delegate, actually
}

sub make_context {
    my ( $self, $req, $app ) = @_;
    # the $app will help us construct these objects - they are Catalyst level stuff, not Isotope level stuff
    my $c = Test::MockObject::Extends->new("Catalyst::Context");
    
    $c->set_always( request => $req );

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

Catalyst::Node::Public::Match::Native - 

=head1 SYNOPSIS

	use Catalyst::Node::Public::Match::Native;

=head1 DESCRIPTION

=cut


