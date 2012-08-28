package Dispatcher;

use strict;
use warnings;
use 5.010;

use Carp;
use Module::Load;

sub new {
	my($class, $arg) = @_;
	$class = ref $class || $class;
	my %dispatcher;
	foreach my $media (keys $arg) {
		my $module = "Dispatcher::$media";
		Module::Load::load $module;
		$dispatcher{$media} = $module->new($arg->{$media});
	}
	return bless \%dispatcher, $class;
}

sub send {
	my($this, $media, $message) = @_;
	return $this->{$media}->send($message);
}


1;
