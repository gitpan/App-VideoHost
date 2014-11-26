package App::VideoHost;
{
  $App::VideoHost::VERSION = '0.143303'; # TRIAL
}

use Mojo::Base 'Mojolicious';
use App::VideoHost::Video::Storage;

use File::Basename 'dirname';
use File::Spec::Functions 'catdir';

=head1 NAME

App::VideoHost - filesystem based personal video hosting

=cut

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
