package Hyde;

use strict;
use warnings;
our $VERSION = '0.01';

use File::Spec::Functions;
use Mojo::Template;
use Text::Xatena;
use Encode;

sub generate {
    my $layouts_dir = catdir($FindBin::Bin, '..', 'layouts');
    my $layouts = catdir($layouts_dir, 'default');

    my $source_dir = catdir($FindBin::Bin, '..', 'posts');
    opendir(my $dh, $source_dir) || die "can't open dir";
    my @sources = grep { /^\./ !~ $_ && -f catdir($source_dir, $_) } readdir($dh);

    my $output_dir = catdir($FindBin::Bin, '..', 'site');

    my $xatena = Text::Xatena->new;
    my $mt = Mojo::Template->new;

    my $menu = catdir($layouts_dir, 'menu');
    $mt->render_file_to_file($menu, catdir($output_dir, "menu.html"), @sources);
    foreach my $source (@sources) {
        print "[source]$source\n";
        open my $fh, '<', catdir($source_dir, $source);
        my $string = join "", <$fh>;
        my $formated = $xatena->format($string);
        print "[output]".catdir($output_dir, "$source.html")."\n";
        $mt->render_file_to_file(
            $layouts,
            catdir($output_dir, "$source.html"),
            Encode::decode('utf-8', $formated));
    }

}


1;
__END__

=encoding utf-8

=for stopwords

=head1 NAME

Hyde -

=head1 SYNOPSIS

  use Hyde;

=head1 DESCRIPTION

Hyde is

=head1 AUTHOR

Kazuhiro Shibuya E<lt>stevenlabs at gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2010- Kazuhiro Shibuya

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
