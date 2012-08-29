#!/usr/bin/env perl

use strict;
use warnings;

use Module::Load;
use YAML;

use lib qw(lib);
use Notifier;

my $config_yaml = $ARGV[0] || 'config.yaml';
my $conf = YAML::LoadFile($config_yaml);

my $notifier = Notifier->new($conf->{Notifier});

my @children;
foreach my $p (keys %{$conf->{Watcher}}) {
	my $module = "Watcher::$p";
	Module::Load::load $module;
	my $child = $module->new($notifier, $conf->{Watcher}{$p});
	$child->init;
	push @children, $child;
}

foreach my $c (@children) {
	$c->start;
}
