package Notifier;

use strict;
use warnings;
use 5.010;

use Carp;
use Module::Load;

sub new {
	my($class, $arg) = @_;
	$class = ref $class || $class;
	my %notifier;
	foreach my $media ('Echo', keys $arg) {
		my $module = __PACKAGE__. "::$media";
		Module::Load::load $module;
		$notifier{$media} = $module->new($arg->{$media});
	}
	return bless \%notifier, $class;
}

sub send {
	my($this, $media, $message) = @_;
	return $this->{$media}->send($message);
}


1;
