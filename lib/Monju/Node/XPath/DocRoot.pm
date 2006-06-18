#!/usr/bin/perl

package Monju::Node::XPath::DocRoot;
use Moose;

has node => (
    isa => "Monju::Node::XPath",
    is  => "ro",
    required => 1,
);

sub xpath_get_child_nodes   { return ( $_[0]->node ); }
sub xpath_get_attributes    { return []  }
sub xpath_is_document_node  { return 1   }
sub xpath_is_element_node   { return 0   }
sub xpath_is_attribute_node { return 0   }

sub xpath_cmp { return -1 } # the root is before all other nodes

__PACKAGE__;

__END__

=pod

=head1 NAME

Monju::Node::XPath::DocRoot - Please XPath by giving it a document object.

=head1 SYNOPSIS

	use Monju::Node::XPath::DocRoot;

=head1 DESCRIPTION

=cut


