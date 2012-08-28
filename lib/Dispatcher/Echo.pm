package Dispatcher::Echo;

use strict;
use warnings;
use 5.010;

sub new {
	my $class = shift;
	$class = ref $class || $class;
	return bless {}, $class;
}

sub send {
	my($this, $message) = @_;
	say $message;
}


1;
