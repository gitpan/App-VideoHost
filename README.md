VideoHost - filesystem based personal video hosting
===================================================

You want to host your own videos online to share with friends. You don't want
to install a lot of dependancies, manage a database or install new modules on
your web server.

You do want to be able to add videos by dropping them into a file tree, and
give people a URL to look at your videos with no complications.

You want this.

Setting up
----------

A perlbrew setup is recommended!

    $ git clone https://github.com/EatMoreCode/video_host.git
    $ cd video_host
    $ perl Makefile.PL
    $ make
    $ make test
    $ make install

CPAN coming soon!

Running
-------

There are many ways to deploy Mojolicious apps. Suggested reading:
http://mojolicio.us/perldoc/Mojolicious/Guides/Cookbook#DEPLOYMENT

    $ cp lib/VideoHost/video_host.conf SOMEDIR/video_host.conf
    $ edit SOMEDIR/video_host.conf
    $ MOJO_CONFIG=SOMEDIR/video_host.conf hypnotoad `which video_host`

Open your browser and enjoy.

What? I don't want to install things! I just want to kick the tires!
--------------------------------------------------------------------

Gotcha. Try this:

    $ git clone https://github.com/EatMoreCode/video_host.git
    $ cd video_host
    $ morbo script/video_host --listen http://\*:2345

Hit `http://localhost:2345` and kick the tires (well, tire).

To play some more, add your own videos under t/testdata (see the next
section).

OK, how do I add videos?
------------------------

Under your `video_directory` path (in the config) you need to have:

* one directory per video (name is unimportant - make it meaningful to you)
* one video file inside that directory called `video.mp4`
* one metadata file called `metadata.txt`
* (optional) a file called `poster.jpg` - an image shown before the video is loaded
* (optional) a webvtt file called `tracks.vtt` containing captioning information

The `metadata.txt` file should contain key: value pairs, thus:

    title: My lovely video!
    date: 2014-10-10

Thanks to
---------

* http://www.videojs.com - Video.js
* http://mojolicio.us - Awesome!
* My wife for inspiring the project - Even more Awesome!
