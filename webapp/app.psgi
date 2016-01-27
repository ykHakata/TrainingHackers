use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/local/lib/perl5";
use lib "$FindBin::Bin/lib";
use File::Basename;
use Plack::Builder;
use TrainingHackers;
use Log::Dispatch;
use Log::Dispatch::File;
use Log::Dispatch::Screen;

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
$app->route('/cracking', {controller => 'TrainingHackers::Controller::PasswordCracking', action => 'index', id => 'hacker', password => 'hacker'});
$app->route('/cracking_from_list', {controller => 'TrainingHackers::Controller::PasswordCrackingFromList', action => 'index', id => 'Barton', password => 'nRoyhQNv'});
$app->route('/exploits', {controller => 'TrainingHackers::Controller::Exploits', action => 'index'});
$app->route('/rankings', {controller => 'TrainingHackers::Controller::Rankings', action => 'index'});
$app->route('/user_answers', {controller => 'TrainingHackers::Controller::UserAnswers', action => 'index'});

my $psgi_app = $app->psgi_app;

my $logger = Log::Dispatch->new;
$logger->add( 
    Log::Dispatch::File->new(
        name      => 'access_log',
        min_level => 'debug',
        filename  => $root_dir.'/logs/access_log'
    )
);

$logger->add(
    Log::Dispatch::Screen->new(
        name      => 'screen',
        min_level => 'warning',
    )
);

builder {
    enable 'ReverseProxy';
    enable 'LogDispatch', logger => $logger;
    enable 'LogErrors';
    enable 'Static',
      path  => qr{^/static/},
      root  => './public';
    $psgi_app;
};
