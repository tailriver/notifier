package Plugin::Filesys::Notify;

use strict;
use warnings;
use 5.010;

use parent qw(Plugin);

use AnyEvent;
use AnyEvent::Filesys::Notify;


my $default_interval = 2.0;
my $default_filter   = sub { shift !~ /\.(DS_Store|swp|tmp)$/ };

sub new {
	my($class, $dispatcher, $arg) = @_;
	$class = ref $class || $class;
	my $self = bless {
		watch      => $arg->{watch},
		cv         => AnyEvent->condvar,
		queue      => [],
		idle       => undef,
	}, $class;
	$self->set_dispatcher($dispatcher, $arg->{media});
	return $self;
}

sub init {
	my $this = shift;

	foreach my $w (@{$this->{watch}}) {
		foreach my $dir (@{$w->{dirs}}) {
			$dir =~ s/~/$ENV{HOME}/g;
		}
		$w->{interval} ||= $default_interval;
		$w->{filter}   ||= $default_filter;
		$w->{cb}       ||= sub {
			my (@events) = @_;
			$this->{idle} ||= AnyEvent->idle(
				cb => sub {
					my $e = shift @{$this->{queue}};
					$this->send( join(',', $e->{name}, $e->{type}, $e->{path}) );

					undef $this->{idle} unless @{$this->{queue}};
				}
			);
			foreach my $e (@events) {
				my $path = $e->path;
				foreach my $dir (@{$w->{dirs}}) {
					$path =~ s/^$dir//i;
				}
				$path =~ "/$path" if $path !~ /^\//;
				push $this->{queue}, {
					name => $w->{name},
					type => $e->type, 
					path => $path
				};
			}
		};
		$w->{'AnyEvent::Filesys::Notify'} = AnyEvent::Filesys::Notify->new(%$w);
	}
}

sub start {
	my $this = shift;
	$this->SUPER::start;
	$this->{cv}->recv;
}


1;
