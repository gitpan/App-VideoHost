package App::VideoHost;
{
  $App::VideoHost::VERSION = '0.143310'; # TRIAL
}

use Mojo::Base 'Mojolicious';
use App::VideoHost::Video::Storage;

use File::Basename 'dirname';
use File::Spec::Functions 'catdir';

# ABSTRACT: Filesystem based personal video hosting


# This method will run once at server start
sub startup {
  my $self = shift;

  # Switch to installable home directory
  $self->home->parse(catdir(dirname(__FILE__), 'VideoHost'));

  # Switch to installable "public" directory
  $self->static->paths->[0] = $self->home->rel_dir('public');

  # Switch to installable "templates" directory
  $self->renderer->paths->[0] = $self->home->rel_dir('templates');

  # Load config
  $self->plugin('Config');

  # configure logging
  if ($self->config->{log}->{path}) {
    $self->log(Mojo::Log->new(path => $self->config->{log}->{path}, level => $self->config->{log}->{level} || 'info'));
  }

  # Router
  my $r = $self->routes;

  # Set namespace, to support older Mojolicious versions where this was
  # not the default
  $r->namespaces(['App::VideoHost::Controller']);

  # Normal route to controller
  $r->get('/')->to('root#index');
  $r->get('/video/:short_name')->to('root#video_stream')->name('video');
  $r->get('/poster/:short_name')->to('root#poster')->name('poster');
  $r->get('/tracks/:short_name')->to('root#tracks')->name('tracks');

  $self->helper(videos => sub {
    my $self = shift;
    state $videos = App::VideoHost::Video::Storage->new(directory => $self->config->{ video_directory }); 
    return $videos;
  });


}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::VideoHost - Filesystem based personal video hosting

=head1 VERSION

version 0.143310

=head1 SYNOPSIS

Just drop videos and text files containing the metadata into a directory of
your choice, then:

     cp lib/VideoHost/video_host.conf $SOMEDIR/video_host.conf
     edit $SOMEDIR/video_host.conf
     MOJO_CONFIG=$SOMEDIR/video_host.conf hypnotoad `which video_host`

=head1 AUTHOR

Justin Hawkins <justin@eatmorecode.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Justin Hawkins.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
