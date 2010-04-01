package Utterson::Plugin::Hatena;

use strict;
use warnings;
use base 'Mojo::Base';
use Text::Xatena;
use Mojo::Template;

sub register {
    my ($self, $app) = @_;

    $app->add_handler(
        'hatena' => sub {
            my ($self, $args) = @_;
            my $xatena = Text::Xatena->new;
            my $mt = Mojo::Template->new;

            my $formated = $xatena->format($args->{string});
            $mt->render_file_to_file(
                $args->{layouts},
                $args->{output},
                Encode::decode('utf-8', $formated),
            );
        }
    );
}

1;
