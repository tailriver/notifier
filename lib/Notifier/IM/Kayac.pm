package Notifier::IM::Kayac;

use strict;
use warnings;

use Carp;
use HTTP::Tiny;

sub new {
	my($class, $q) = @_;
	$class = ref $class || $class;
	croak 'username is required' if !$q->{username};
	return bless $q, $class;
}

sub send {
	my($this, $message) = @_;
	HTTP::Tiny->new->post_form(
		'http://im.kayac.com/api/post/'. $this->{username},
		{ message => $message }
	);
}


1;
