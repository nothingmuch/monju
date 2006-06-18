#!/usr/bin/perl

package Catalyst::Node::Workflow::Transition;
use Moose;

extends qw/Catalyst::Node::Private::Action/;

sub match { goto &Catalyst::Node::Private::Action::match }

with qw/
    Monju::Node::Workflow::Transition

    Class::Workflow::Transition::Deterministic
    Class::Workflow::Transition::Strict
    Class::Workflow::Transition::Validate::Simple
/;

use tt;
[% FOREACH def IN [
    { type => "get", args => '@args' },
    { type => "set", args => '$instance' }
] %]
sub [% def.type %]_instance {
    my ( $self, $c, [% def.args %] ) = @_;

    if ( ( my $component = $self->component )->can("[% def.type %]_workflow_instance") ) {
        return $component->[% def.type %]_workflow_instance( $self, $c, [% def.args %] );
    } elsif ( $c->can("[% def.type %]_workflow_instance") ) {
        return $c->[% def.type %]_workflow_instance( $self, [% def.args %] );
    } elsif ( exists $c->stash->{workflow_instance} ) {
        return $c->stash->{workflow_instance}[% IF def.type == "set" %] = [% def.args %][% END %];
    } else {
        return $self->cannot_get_instance( $c, [% def.args %] );
    }
}
[% END %]
no tt;

sub cannot_get_instance {
    my ( $self, $c, @args ) = @_;
    die "Can't locate workflow instance";
}

sub cannot_set_instance {
    my ( $self, $c, $instance ) = @_;
    die "Don't know how to save new workflow instance";
}

sub apply_body {
    my ( $self, $instance, $c, @args ) = @_;
    $self->Catalyst::Node::Private::Action::execute( $c, $instance, @args );
}

sub execute {
    my ( $self, $c, @args ) = @_;

    my $instance = $self->get_instance( $c, @args );

    my ( $new_instance, @rv ) = $self->apply( $instance, $c, @args );

    $self->set_instance( $c, $new_instance );

    return ( wantarray ? @rv : $rv[0] );
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Catalyst::Node::Workflow::Transition - Private actions which are also workflow
transitions.

=head1 SYNOPSIS

	use Catalyst::Node::Workflow::Transition;

=head1 DESCRIPTION

This class could have been named
L<Catalyst::Node::Private::Action::Workflow::Transition> but that would have
been too much ;-)

This is a drop in replacement for L<Catalyst::Node::Private::Action>, that has
validation and state transfer "built in".

=cut


