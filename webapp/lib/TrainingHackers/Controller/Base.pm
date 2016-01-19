package TrainingHackers::Controller::Base;
use strict;
use warnings;
use parent qw(Spica::Controller);
use Module::Load;
use DBIx::Sunny;
use Spica::Session;
use Spica::Session::Store::DBI;
use Spica::Session::State::Cookie;
use Mouse;

my $cache = {};

has session => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my $self = shift;
        my $s = Spica::Session->new(
            store => Spica::Session::Store::DBI->new(
                db => $self->db,
                table => 'sessions'
            ),
            state => Spica::Session::State::Cookie->new(
                name => 'hackers_session',
                env => $self->env,
                path => '/'
            ),
        );
        $s->start;
        $s;
    }
);

has db => (
    is => 'rw',
    lazy => 1,
    default => sub {
        my $self = shift;
        my %db = %{$self->config->{connect_info}};

        my $db = DBIx::Sunny->connect(
            "dbi:mysql:database=$db{database};host=$db{host};port=$db{port}", $db{username}, $db{password}, {
                RaiseError => 1,
                PrintError => 0,
                AutoInactiveDestroy => 1,
                mysql_enable_utf8   => 1,
            },
        );
    }
);

sub authenticate {
    my $self = shift;

    return $self->redirect('/sessions') unless $self->session->data->{user}->{id};

    my $entry = $self->model('User')->search_by_current_user(
        {
            user_id => $self->session->data->{user}->{user_id},
            password => $self->session->data->{user}->{password},
        }
    );
    if (!$entry) {
        $self->session->set(user => {});
        $self->stash(q => {});
        return $self->redirect('/sessions');
    }
    $self->session->data->{user} = $entry;
}

sub model {
    my $self = shift;
    my $name = shift;

    return $cache->{$name} if $cache->{$name};

    my $pkg = "TrainingHackers::Model::".$name;
    load $pkg;
    my $model = $pkg->new(db => $self->db);
    $cache->{$name} = $model;
    $model;
}

1;
