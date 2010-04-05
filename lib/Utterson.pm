package Utterson;

use strict;
use warnings;
our $VERSION = '0.01';

use base 'Mojo::Base';
use Utterson::Config;
use Utterson::Modification;
use Mojo::Loader;
use Mojo::ByteStream;
use File::Spec::Functions;
use File::Path; 
use Mojo::Template;
use Encode;

__PACKAGE__->attr(plugins => sub{{}});

sub new {
    my $self = shift->SUPER::new(@_);
    $self->plugin('hatena');
    return $self;
}

sub generate {
    my $self = shift;
    my $conf_path = shift;

    my $conf = Utterson::Config->new;
    $conf->load($conf_path);

    my $layouts_dir = catdir($FindBin::Bin, 'layouts');
    my $layouts = catdir($layouts_dir, 'default');

    my $source_dir = catdir($FindBin::Bin, $conf->{source});
    opendir(my $dh, $source_dir) || die "can't open dir";
    my @sources = grep { /^\./ !~ $_ && -f catdir($source_dir, $_) } readdir($dh);

    my $output_dir = catdir($FindBin::Bin, $conf->{destination});

    my $modif = Utterson::Modification->new;
    my @files;
    foreach my $source (@sources) {
        print "[source]$source\n";
        my ($file, $date, $ft) = split /\./, $source;
        my @dates = split '-', $date;
        mkpath catdir($output_dir, @dates);
        push @files, catdir(@dates, $file);

        open my $fh, '<', catdir($source_dir, $source);
        my $string = join "", <$fh>;
        unless ($modif->is_modification(
            $source, -s catdir($source_dir, $source), $string)){
            print "[pass]$source\n";
            next;
        }

        print "[output]".catdir($output_dir, @dates, "${file}.html")."\n";
        my $args = {
            layouts => $layouts,
            output => catdir($output_dir, @dates, "${file}.html"),
            string => $string,
        };
        unless (exists $self->plugins->{$ft}) {
            print "$ft doesn't exist.";
            next;
        }
        $self->plugins->{$ft}->($self, $args);
    }

    my $mt = Mojo::Template->new;
    my $menu = catdir($layouts_dir, 'menu');
    $mt->render_file_to_file($menu, catdir($output_dir, "menu.html"), @files);

    $modif->dump_hash;
}

sub plugin {
    my $self = shift;
    my $module = shift;

    my $fullname = 'Utterson::Plugin::' . Mojo::ByteStream->new($module)->camelize;
    my $e = Mojo::Loader->new->load($fullname);
    warn $e->message if ref $e;
    $fullname->new->register($self);
}

sub add_handler {
    my $self = shift;
    my ($name, $cb) = @_;
    $self->plugins({%{$self->plugins}, $name => $cb});
}

1;
__END__

=encoding utf-8

=for stopwords

=head1 NAME

Utterson -

=head1 SYNOPSIS

  use Utterson;

=head1 DESCRIPTION

Utterson is

=head1 AUTHOR

Kazuhiro Shibuya E<lt>stevenlabs at gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2010- Kazuhiro Shibuya

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
