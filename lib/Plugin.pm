package Plugin;

use strict;
use warnings;


sub set_dispatcher {
	my($this, $dispatcher, $media) = @_;
	$media = ref $media ? $media : [ $media || 'Echo' ];
	$this->{_plugin}{dispatcher} = $dispatcher;
	$this->{_plugin}{media} = $media;
}

sub send {
	my($this, $message) = @_;
	foreach my $m (@{$this->{_plugin}{media}}) {
		$this->{_plugin}{dispatcher}->send($m, $message);
	}
}

sub start {
	my $this = shift;
	my $child = (caller)[0];
	my $media = join ', ', @{$this->{_plugin}{media}};
	print "$child (via $media)\n";
}


1;
