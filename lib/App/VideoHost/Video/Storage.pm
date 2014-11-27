package App::VideoHost::Video::Storage;
{
  $App::VideoHost::Video::Storage::VERSION = '0.143310'; # TRIAL
}

# ABSTRACT: Manage a list of L<App::VideoHost::Video>s

use Moose;
use File::Spec;

use App::VideoHost::Video;

use Carp qw/croak/;

has 'directory' => ( is => 'rw' );

sub check_errors {
  my $self = shift;

  my @errors;
  foreach my $video ($self->list) {
    eval 
      { $video->check; 1; }
    or do {
      my $error = $@;
      chomp $error;
      push @errors, $video->directory . ": $error";
    }
  }
  return @errors;
}

sub video_dirs {
  my $self = shift;
  my $dir  = $self->directory;

  croak "no directory provided" unless $dir;
  croak "directory $dir does not exist" unless -d $self->directory;

  my @potential_dirs = glob File::Spec->catdir($dir, "*");
  my @dirs;
  foreach (@potential_dirs) {
    next if /^\./;
    next if ! -d;
    push @dirs, $_;
  }
   
  return @dirs;
}

sub list {
  my $self = shift;
  return reverse sort { $a->metadata('date') cmp $b->metadata('date') }
          map { App::VideoHost::Video->new(directory => $_) }
          $self->video_dirs;
}

sub find_by_short_name {
  my $self  = shift;
  my $title = shift;
  foreach ($self->list) {
    if ($title eq $_->short_name) {
      return $_;
    }
  }
  return;

}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::VideoHost::Video::Storage - Manage a list of L<App::VideoHost::Video>s

=head1 VERSION

version 0.143310

=head1 AUTHOR

Justin Hawkins <justin@eatmorecode.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Justin Hawkins.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
