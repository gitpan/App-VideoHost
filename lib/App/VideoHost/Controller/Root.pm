package App::VideoHost::Controller::Root;
{
  $App::VideoHost::Controller::Root::VERSION = '0.143303'; # TRIAL
}

use Mojo::Base 'Mojolicious::Controller';
use Mojolicious::Static;

# This action will render a template
sub index {
  my $self = shift;

  $self->render();
}

sub video_stream {
  my $self = shift;
  my $name = $self->param('short_name');
  my $video = $self->videos->find_by_short_name($name);
  return $self->render_not_found unless $video;

  my $static = Mojolicious::Static->new( paths => [ $video->directory ] );
  $self->res->headers->content_disposition(qq{'attatchment; filename="video.mp4"'});
  $static->serve($self, 'video.mp4');
  $self->rendered();
}

sub poster {
  my $self = shift;
  my $name = $self->param('short_name');
  my $video = $self->videos->find_by_short_name($name);
  return $self->render_not_found unless $video;
  return $self->render_not_found unless $video->has_poster;

  my $static = Mojolicious::Static->new( paths => [ $video->directory ] );
  $self->res->headers->content_disposition(qq{'attatchment; filename="poster.jpg"'});

  $static->serve($self, 'poster.jpg');
  $self->rendered();
}

sub tracks {
  my $self = shift;
  my $name = $self->param('short_name');
  my $video = $self->videos->find_by_short_name($name);
  return $self->render_not_found unless $video;
  return $self->render_not_found unless $video->has_tracks;

  my $static = Mojolicious::Static->new( paths => [ $video->directory ] );
  $self->res->headers->content_disposition(qq{'attatchment; filename="captions.vtt"'});

  $static->serve($self, 'tracks.vtt');
  $self->rendered();
}

1;
