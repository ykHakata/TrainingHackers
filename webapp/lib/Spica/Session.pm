package Spica::Session;
use Mouse;
use Digest::SHA qw(sha512_hex); 
use Time::HiRes qw(gettimeofday);

has exists => (
    is => 'rw',
    lazy => 1,
    default => sub {
        0;
    }
);

has store => (
    is => 'rw',
    lazy => 1,
    default => sub {}
);

has state => (
    is => 'rw',
    lazy => 1,
    default => sub {}
);

has data => (
    is => 'rw',
    lazy => 1,
    default => sub {
        {};
    }
);

sub id {
    my ($self, $id) = @_;

    $id ? $self->state->id($id) : $self->state->id;
}

sub regenerate_id {
    my ($self) = @_;

    $self->store->delete($self->state->id);
    $self->state->id($self->state->generate_id);
    $self->store->store($self->state->id, $self->data, $self->state->expires);
}

sub get {
    my ($self, $key) = @_;
    $self->data->{$key};
}

sub set {
    my ($self, $key, $value) = @_;
    $self->data->{$key} = $value;
}

sub start {
    my $self = shift;

    $self->state->id($self->state->generate_id) unless $self->state->id;
    $self->data($self->read);
}

sub write {
    my ($self, $session) = @_;

    $self->store->store($self->state->id, $session, $self->state->expires);
}

sub read {
    my $self = shift;

    my $data = $self->store->fetch($self->state->id);
    if ($data) {
        $self->exists(1);
        return $data;
    } else {
        $self->store->store($self->state->id, {}, $self->state->expires);
        return {};
    }
}

sub save {
    my ($self, $session) = @_;

    $self->store->save($self->state->id, $session, $self->state->expires);
}

sub destroy {
    my ($self, $res) = @_;

    $self->data({});
    $self->store->delete($self->state->id);
}

sub expires {
    my ($self, $expires) = @_;

    defined $expires ? $self->state->expires($expires) : $self->state->expires;
}

sub finalize {
    my ($self, $res, $options) = @_;

    $self->store->save($self->state->id, $self->data, $self->state->expires);
    $self->state->finalize($res, $options);
}

no Mouse;
__PACKAGE__->meta->make_immutable();
1;
