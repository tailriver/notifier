#!/usr/bin/env perl

use strict;
use warnings;

use Module::Load;
use YAML;

use lib qw(lib);
use Dispatcher;

my $config_yaml = $ARGV[0] || 'config.yaml';
my $conf = YAML::LoadFile($config_yaml);

my $dispatcher = Dispatcher->new($conf->{dispatcher});

my @children;
foreach my $p (keys %{$conf->{plugin}}) {
	my $module = "Plugin::$p";
	Module::Load::load $module;
	my $child = $module->new($dispatcher, $conf->{plugin}{$p});
	$child->init;
	push @children, $child;
}

foreach my $c (@children) {
	$c->start;
}
