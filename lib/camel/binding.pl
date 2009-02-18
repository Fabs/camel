use YAML;
require 'spec/subroutines.pl';
sub run{
	my ($file, $routine) = @_;
	open(YAMLFILE,'>subroutines.yaml');
	print YAMLFILE Dump(&$routine());
	close(YAMLFILE);
}

run(@ARGV[0],@ARGV[1])
