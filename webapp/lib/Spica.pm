package Spica;
use Router::Boom;
use Module::Load;
use Mouse;
use Carp ();
use parent qw(Spica::EventEmitter);

has root_dir => (
    is => 'rw', 
);

has config => (
    is => 'rw',
    lazy => 1,
    default => sub {
        my $self = shift;
        my $config = {};
        my $path = $self->root_dir . '/config/config.pl';
        $config = load_file($path) if -f $path;
        $config;
    }
);

has env => (
    is => 'rw',
);

has stash => (
    is => 'rw',
    lazy => 1,
    default => sub {
        {};
    }
);

has routes => (
    is => 'rw',
);

has router => (
    is => 'rw', 
    lazy => 1,
    default => sub {
        my $self = shift;
        my $router = Router::Boom->new;
        $router;
    }
);

sub psgi_app {
    my $self = shift;

    return sub {
        $self->run(@_);
    };
}

sub startup {}

sub route {
    my $self = shift;
    $self->router->add(@_);
}

sub run {
    my ($self, $env) = @_;

    $self->env($env);
    $self->startup;

    my ($routes, $capture) = $self->router->match($env->{PATH_INFO});
    if (!$routes) {
        $routes->{controller} = 'Spica::Controller';
        $routes->{action} = 'render_404';
    }

    my $sesson = $env->{'psgix.session'};
    $self->routes($routes);
    load $routes->{controller};
    my $package = $routes->{controller};

    my ($res, $c);
    $c = $package->new(
        env => $env, 
        root_dir => $self->root_dir,
        config => $self->config,
        routes => $routes,
        stash => $self->stash
    );
    my $a = $routes->{action};
    if (ref $a eq 'CODE') {
        $res = $a->($c);
        Carp::croak("You must render a template file") unless $c->rendered;
    } elsif ($c->can($a)) {
        my $listeners = $c->listeners('before_action');
        for my $listener (@$listeners) {
            $res = $listener->($c);
            goto SKIP_ACTION if Scalar::Util::blessed($res) && $res->isa('Spica::Response');
        }
        $res = $c->$a($capture);
      SKIP_ACTION:
        $c->emit(after_action => $c, $res);
    } else {
        Carp::croak("Cannot call method ${c}->${a}");
    }
    $res->finalize;
}

sub load_file {
    my $file = shift;

    $file = File::Spec->rel2abs($file);
    my $config = do $file
        or Carp::croak("load error $file");
}

no Mouse;
__PACKAGE__->meta->make_immutable();

1;
