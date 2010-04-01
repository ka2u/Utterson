package Hyde::Config;

use strict;
use warnings;
use base 'Mojo::Base';
use YAML::Tiny;
use File::Spec::Functions;
use Data::Dumper;

__PACKAGE__->attr([qw/destination source permalink/]);
__PACKAGE__->attr(pretty => "/:year/:month/:day/:title/index.html");
__PACKAGE__->attr(date => "/:year/:month/:day/:title.html");

sub load {
    my ($self, $path) = @_;

    my $conf = YAML::Tiny->read($path)->[0];
    $self->destination($conf->{destination} || catdir(".","site"));
    Carp::croak("site destination not found.")
        unless -d $self->destination; 

    $self->source($conf->{source} || catdir(".","posts"));
    Carp::croak("source directory not found.")
        unless -d $self->source; 

    
    #$self->permalink($conf->{parmalink});
}

sub _parse_parmalink {
    my $self = shift;
    my $format = shift;

    if ($format eq 'pretty') {
        $self->permalink($self->pretty);
    }
    elsif ($format eq 'date') {
        $self->permalink($self->date);
    }
    else {
        $self->permalink($format);
    }
}

1;

=pod
destination
source
parmalink
=cut

