class Sprockets::Locator;

use Sprockets;
use Sprockets::File;

has %.paths;

method find-file($name, $ext) {
	my sub rm-trail($str) {
		$str.subst(/\/$/, '');
	}
	my $prefix = (my $p = %prefixes{get-type-for-ext($ext)}) ?? "/$p" !! "";

	for %.paths.kv -> $, $ (:@directories, :%prefixes) {
		for @directories {
			my $dir = "{.&rm-trail}{rm-trail $prefix}/";
			for dir $dir {
				next if .IO.d; # TODO go deeper §§

				my ($f, $fext) = split-name-and-extension($_.Str.substr($dir.chars));
				return $_ if $f eq $name and $fext eq $ext;
			}
		}
	}
}

sub get-type-for-ext($ext) {
	given $ext {
		return 'img' when 'png' | 'gif' | 'jpg' | 'jpeg';

		return 'font' when 'otf' | 'ttf';
	}
	return $ext;
}
