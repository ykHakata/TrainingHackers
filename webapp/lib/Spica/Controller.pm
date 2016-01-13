package Spica::Controller;
use Plack::Request;
use Spica::Response;
use Encode ();
use Module::Load;
use Sub::Data::Recursive;
use Text::Xslate;
use Mouse;
use Carp ();
use parent qw(Spica::EventEmitter);

has session => (
    is => 'rw',
);

has encoding => (
    is => 'rw',
    default => 'utf8'
);

has req => (
    is => 'rw',
    lazy => 1, 
    default => sub { 
        my $self = shift;
        Plack::Request->new($self->env);
    }
);

has res => (
    is => 'rw',
    lazy => 1, 
    default => sub { 
        my $self = shift;
        Spica::Response->new;
    }
);

has status => (
    is => 'rw',
    default => 200 
);

has method => (
    is => 'ro',
    lazy => 1,
    default => sub { 
        my $self = shift;
        $self->req->method;
    }
);

has renderer => (
    is => 'rw',
    lazy => 1,
    default => sub {
        my $self = shift;
        Text::Xslate->new(
            syntax => $self->config->{renderer}->{syntax} || 'Kolon',
            cache => $self->config->{renderer}->{cache} || 0,
            path => $self->config->{renderer}->{path}
                    || [$self->root_dir.'/views'],
            html_builder_module => [ 'HTML::FillInForm::Lite' => [qw(fillinform)] ]
        );
    }
);

has root_dir => (
    is => 'rw', 
);

has config => (
    is => 'rw', 
);

has env => (
    is => 'rw',
);

has parameters => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my $self = shift;
        my $parameters = $self->req->parameters;
        Sub::Data::Recursive->invoke(sub { Encode::decode($self->encoding, shift); }, $parameters);
        $parameters;
    }
);

sub param {
    my $self = shift;
    my $val = $self->req->param(@_);
    Sub::Data::Recursive->invoke(sub { Encode::decode($self->encoding, shift); }, $val);
    $val;
}

sub redirect {
    my $self = shift;

    $self->res->redirect(@_);
    $self->finalize;
}

sub stash {
    my $self = shift;
     
    if (scalar @_ == 0) {
        $self->{stash} ||= {};
    } else {
        my %args = @_;
        for my $k (keys %args) {
            $self->{stash}->{$k} = $args{$k};
        }
    }
}

sub render {
    my $self = shift;

    my $body;
    if ($_[0] eq 'json') {
        load "JSON";
        return JSON::encode_json($_[1]);
    }

    $self->emit(before_render => $self, @_);

    if ($_[0] eq 'text') {
        $body = $self->renderer->render_string($_[1]);
    } else {
        $body = $self->renderer->render(shift, shift||$self->stash);
    }
    $self->emit(after_render => $self, $body);
    $self->res->body($self->encode_html($body));
    return $self->finalize;
}

sub encode_html {
    my ($self, $body) = @_;

    return Encode::encode($self->encoding, $body); 
}

sub finalize {
    my $self = shift;

    $self->session->finalize($self->res) if $self->session;
    return $self->res;
}

sub render_404 {
    my $self = shift;

    $self->render(text => '404 not found');
}


sub load_file {
    my $file = shift;

    $file = File::Spec->rel2abs($file);
    my $config = do $file or Carp::croak("load error $file");
}

no Mouse;
__PACKAGE__->meta->make_immutable();

1;
