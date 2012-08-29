package Watcher;

use strict;
use warnings;

my $PACKAGE = __PACKAGE__;

sub set_notifier {
	my($this, $notifier, $media) = @_;
	$media = ref $media ? $media : [ $media || 'Echo' ];
	$this->{$PACKAGE}{notifier} = $notifier;
	$this->{$PACKAGE}{media} = $media;
}

sub send {
	my($this, $message) = @_;
	foreach my $m (@{$this->{$PACKAGE}{media}}) {
		$this->{$PACKAGE}{notifier}->send($m, $message);
	}
}

sub start {
	my $this = shift;
	my $child = (caller)[0];
	my $media = join ', ', @{$this->{$PACKAGE}{media}};
	print "$child (via $media)\n";
}


1;
