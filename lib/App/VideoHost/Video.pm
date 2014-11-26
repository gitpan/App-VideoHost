package App::VideoHost::Video;
{
  $App::VideoHost::Video::VERSION = '0.143303'; # TRIAL
}

use Moose;
use File::Spec;
use Carp qw/croak confess/;

has 'directory' => (is => 'rw');

sub check {
  my $self = shift;
  die "no directory set\n"         unless $self->directory;
  die "directory does not exist\n" unless -d $self->directory;

  die "video does not exist\n"     unless -f $self->path_to('video');
  die "video is empty\n"           unless ! -z $self->path_to('video');

  die "poster exists but is empty\n" if (-e $self->path_to('poster') && -z $self->path_to('poster'));

  die "tracks file exists but is empty\n" if (-e $self->path_to('tracks') && -z $self->path_to('tracks'));

  die "metadata file does not exist\n"  unless (-e $self->path_to('metadata'));
  die "metadata file is empty\n"        if (-z $self->path_to('metadata'));

  return 1;
}

sub has_tracks { return -e shift->path_to('tracks') }
sub has_poster { return -e shift->path_to('poster') }

sub short_name { my $title = shift->metadata('title'); $title = lc($title); $title =~ s/\W/-/g; $title =~ s/\-+$//g; return $title };
sub id         { shift->short_name }

sub title { my $title = shift->metadata('title'); croak "no title" unless $title; return $title; }

sub file  { return shift->path_to('video') }
sub poster { return shift->path_to('poster') }
sub tracks { return shift->path_to('tracks') }

sub metadata {
  my $self = shift;
  my $key  = shift;

  open my $fh, "<", $self->path_to('metadata');
  while (my $line = <$fh>) {
    chomp $line;
    my ($k, $v) = ($line =~ /^(\w+)\s*:\s*(.*?)$/);
    next unless $k;
    if ($k eq $key) { return $v }
  }
  return;
}

sub path_to {
  my $self = shift;
  my $item = shift;
  confess "what do you mean to look for the path to?" unless $item;
  my $dir = $self->directory;

  if ($item eq 'video') {
    return File::Spec->catdir( $dir, 'video.mp4' );
  }
  elsif ($item eq 'tracks') {
    return File::Spec->catdir( $dir, 'tracks.vtt' );
  }
  elsif ($item eq 'poster') {
    return File::Spec->catdir( $dir, 'poster.jpg');
  }
  elsif ($item eq 'metadata') {
    return File::Spec->catdir( $dir, 'metadata.txt');
  }

  croak "do not know how to get path_to a $item";
}

1;
