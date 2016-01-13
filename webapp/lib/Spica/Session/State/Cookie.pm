package Spica::Session::State::Cookie;
use Mouse;
use Spica::Cookie;
use Digest::SHA qw(sha512_hex); 
use Time::HiRes qw(gettimeofday);

has env => (
    is => 'ro',
    lazy => 1,
    default => sub {
        {};
    }
);

has name => (
    is => 'rw',
    lazy => 1,
    default =>  sub {
        "session_id";
    }
);

has exists => (
    is => 'rw',
    lazy => 1,
    default => sub {
        0;
    }
);

has session_length => ( 
    is => 'rw',
    default => 32,
);

has id => (
    is => 'rw',
    lazy => 1,
    default => sub {
        my $self = shift;
        if ($self->env->{HTTP_COOKIE}) {
            my $c = Spica::Cookie->eat($self->env->{HTTP_COOKIE});
            my $session_id = $c->{$self->name}->{value};
        }
    }
);

has 'expires' => (
    is => 'rw',
    default => 60*60*24*30
);

has path => (
    is => 'rw',
);

has domain => (
    is => 'rw',
);

has httponly => (
    is => 'rw',
);

has secure => (
    is => 'rw',
);

sub generate_id {
    my $self = shift;
    my $unique = $ENV{UNIQUE_ID} || [] . rand();
    return sha512_hex(gettimeofday . $unique);
}

sub finalize {
    my ($self, $res, $options) = @_;

    $options->{path}     = $self->path || '/' if !exists $options->{path};
    $options->{domain}   = $self->domain      if !exists $options->{domain} && defined $self->domain;
    $options->{secure}   = $self->secure      if !exists $options->{secure} && defined $self->secure;
    $options->{httponly} = $self->httponly    if !exists $options->{httponly} && defined $self->httponly;
    $options->{expires} = time+$self->expires if !exists $options->{expires} && defined $self->expires;

    $res->cookies({
        $self->name => {
            value => $self->id,
            %$options
        }
    });
    $res;
}

no Mouse;
__PACKAGE__->meta->make_immutable();
1;
