package Dispatcher::IM::Kayac;

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
	my $username = $this->{username};
	my $response = HTTP::Tiny->new->post_form(
		"http://im.kayac.com/api/post/$username",
		{ message => $message }
	);
}


1;
