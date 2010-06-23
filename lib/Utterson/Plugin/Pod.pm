package Utterson::Plugin::Pod;

use strict;
use warnings;
use base 'Mojo::Base';
use Pod::Simple::HTML;
use Mojo::Template;

sub register {
    my ($self, $app) = @_;

    $app->add_handler(
        'pod' => sub {
            my ($self, $args) = @_;
            my $parser = Pod::Simple::HTML->new;
            my $formated;
            $parser->output_string(\$formated);
            my $mt = Mojo::Template->new;

            $parser->no_whining(1);
            $parser->bare_output(1);
            $parser->parse_string_document($args->{string});
            $mt->render_file_to_file(
                $args->{layouts},
                $args->{output},
                Encode::decode('utf-8', $formated),
            );
            return $formated;
        }
    );
}

1;
