package Utterson::Modification;

use strict;
use warnings;
use base "Mojo::Base";
use Digest::SHA1 qw(sha1_hex);
use File::Spec::Functions;
use Data::Dumper;

__PACKAGE__->attr(object_dir => catdir('.', '.utterson'));
__PACKAGE__->attr(object_path => catdir('.', '.utterson', 'object'));
__PACKAGE__->attr(object_map => sub { {} });

sub new {
    my $class = shift;
    my $self = $class->SUPER::new;

    if (-f $self->object_path) {
        open my $fh, '<', $self->object_path;
        my $exists = eval(<$fh>);
        die "restore failed. $@" if $@;
        $self->object_map($exists);
    }
    else {
        mkdir $self->object_dir unless -d $self->object_dir;
    }

    return $self;
}

sub is_modification {
    my $self = shift;
    my ($fullname, $filesize, $data) = @_;

    my $hash;
    $hash = $self->_get_sha1($filesize, $data);
    if (exists $self->object_map->{$fullname}) {
        if ($self->object_map->{$fullname} eq $hash) {
            return 0;
        }
    }
    $self->object_map->{$fullname} = $hash;
    return 1;
}

sub dump_hash {
    my $self = shift;
    open my $fh, '>', $self->object_path;
    local $Data::Dumper::Purity = 1;
    local $Data::Dumper::Terse = 1;
    local $Data::Dumper::Indent = 0;
    print $fh Dumper $self->object_map;
}

sub _get_sha1 {
    my $self = shift;
    my ($filesize, $data) = @_;
    return sha1_hex('blob'.$filesize.$data);
}

1;
