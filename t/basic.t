use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('App::VideoHost');
$t->get_ok('/')->status_is(200);

$t->get_ok('/video/a-very-small-video-indeed')
  ->status_is(200)
  ->content_type_is('video/mp4');

done_testing();
