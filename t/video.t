use Test::More;
use Test::Exception;
use File::Temp qw/tempdir/;
use File::Spec;
use File::Copy qw/copy/;

use_ok('App::VideoHost::Video');

my $video;

$video = App::VideoHost::Video->new(directory => "/tmp/does/not/exist/$$");
throws_ok { $video->check }
          qr/directory does not exist/, 'no directory';

$dir = tempdir( CLEANUP => 1 );
$video = App::VideoHost::Video->new(directory => $dir);
throws_ok { $video->check }
          qr/video does not exist/, 'empty directory';

$dir = tempdir( CLEANUP => 1 );
open my $fh, ">", File::Spec->catdir($dir, 'video.mp4');
$video = App::VideoHost::Video->new(directory => $dir);
throws_ok { $video->check }
          qr/video is empty/, 'empty video file';

$dir = tempdir( CLEANUP => 1 );
copy( File::Spec->catdir(qw/t testdata video_1 video.mp4/),
      File::Spec->catdir($dir, 'video.mp4'));
$video = App::VideoHost::Video->new(directory => $dir);
throws_ok { $video->check }
          qr/metadata file does not exist/, 'no metadata';




done_testing();
