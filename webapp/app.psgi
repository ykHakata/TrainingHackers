use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/local/lib/perl5";
use lib "$FindBin::Bin/lib";
use File::Basename;
use Plack::Builder;
use TrainingHackers;

my $root_dir = File::Basename::dirname(__FILE__);

my $app = TrainingHackers->new(root_dir => $root_dir);

$app->route('/', {controller => 'TrainingHackers::Controller::Index', action => 'index'});
$app->route('/users', {controller => 'TrainingHackers::Controller::Users', action => 'index'});
$app->route('/questions/*', {controller => 'TrainingHackers::Controller::Questions', action => 'show'});
$app->route('/questions', {controller => 'TrainingHackers::Controller::Questions', action => 'index'});
$app->route('/sessions', {controller => 'TrainingHackers::Controller::Sessions', action => 'index'});
$app->route('/sessions/logout', {controller => 'TrainingHackers::Controller::Sessions', action => 'logout'});
$app->route('/answers/*', {controller => 'TrainingHackers::Controller::Answers', action => 'index'});
$app->route('/scores', {controller => 'TrainingHackers::Controller::Scores', action => 'index'});
$app->route('/errors', {controller => 'TrainingHackers::Controller::Errors', action => 'index'});
$app->route('/initialize', {controller => 'TrainingHackers::Controller::Initializers', action => 'index'});

my $psgi_app = $app->psgi_app;

builder {
    enable 'ReverseProxy';
    enable 'Static',
        path => qr{^/(images|js|css|fonts)/},
        root => './static/';
    $psgi_app;
};
