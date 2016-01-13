package Spica::Session::Store::DBI;
use parent qw(Spica::DBI);
use Mouse;
use Spica::Util ();
use JSON;

has table => (
    is => 'rw',
    default => sub {
        'sessions'; 
    }  
);

has serializer => (
    is => 'rw',
    lazy => 1,
    default => sub {
        my $self = shift;
        sub { JSON->new->encode(shift||{}); };
    }
);

has deserializer => (
    is => 'rw',
    lazy => 1,
    default => sub {
        my $self = shift;
        sub { JSON->new->decode(shift); }
    }
);

sub fetch {
    my ($self, $session_id) = @_;

    my ($data) = $self->find_by_sql(
        "SELECT * FROM ".$self->table." WHERE session_id = :id AND session_expires > :now",
        {id => $session_id, now => $self->now }
    );
    $data ? $self->deserializer->($data->{session_data}) : ();
}

sub store {
    my ($self, $session_id, $session, $expires) = @_;

    my $table = $self->table;
    
    my $value = {
        session_id => $session_id,
        session_expires => $self->session_expires($expires),
        session_data => $self->serializer->($session),
        created_at => $self->now,
    };
    
    $self->insert(
        $self->table,
        $value
    ); 
}

sub save {
    my ($self, $session_id, $session, $expires) = @_;

    my $table = $self->table;
   
    my $value = {
        session_id => $session_id,
        session_expires => $self->session_expires($expires),
        session_data => $self->serializer->($session),
    };

    if ($self->fetch($session_id)) {
        $value->{updated_at} = $self->now;
        $self->update(
            $self->table,
            $value,
            "session_id = :id AND session_expires > :now",
            {
                id => $session_id,
                now => $self->now
            }
        );
    } else {
        $value->{created_at} = $self->now;
        $self->insert(
            $self->table,
            $value
        ); 
    }
}

sub session_expires {
    my ($self, $expires) = @_;
    Spica::Util::date_format_mysql(time+$expires);
}

sub now {
    Spica::Util::date_format_mysql(time);
}

sub delete {
    my ($self, $session_id) = @_;

    $self->SUPER::delete(
        $self->table,
        "session_id = :id",
        { id => $session_id }
    ); 
}

no Mouse;
__PACKAGE__->meta->make_immutable();
1;
