package Spica::Response;
use Mouse;
use Plack::Util ();
use Spica::Cookie;

has status => (
    is => 'rw',
    default => 200
);

has cookies => (
    is => 'rw',
    lazy => 1,
    default => sub {
        +{};
    }
);

has content_type => (
    is => 'rw',
    default => 'text/html;charset=utf8'
);

has headers => (
    is => 'rw',
    lazy => 1,
    default => sub {
        Plack::Util::headers([]);
    }
);

has body => (
    is => 'rw',
    lazy => 1,
    default => sub {
        [];
    }
);

has location => (
    is => 'rw',
);


sub header {
    my $self = shift;

    $self->headers->set(@_);
}

sub add_cookie {
    my $self = shift;
    $self->{cookies}->{$_[0]} = $_[1];
}

sub redirect {
    my $self = shift;
    my ($url, $status) = @_;

    $self->status($status||302);
    $self->headers->set('Location', $url); 
}

sub finalize_cookies {
    my $self = shift;

    return unless %{ $self->cookies };

    my $cookie = Spica::Cookie->new(%{ $self->cookies });
    $cookie->bake(sub {
        my $cookie = shift;
        $self->headers->set("Set-Cookie" => $cookie);
    });
}

sub finalize {
    my $self = shift;

    unless ($self->headers->exists('Content-type')) {
        $self->headers->set('Content-type', $self->content_type); 
    }

    $self->finalize_cookies; 
    [$self->status, $self->headers->headers, [ $self->body ] ];
}

no Mouse;
__PACKAGE__->meta->make_immutable();

1;

