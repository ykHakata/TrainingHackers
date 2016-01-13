package TrainingHackers::Model::User;
use strict;
use warnings;
use parent qw(TrainingHackers::Model::Base); 
use Digest::SHA qw/sha512_hex/;
use DBIx::Sunny;

sub create {
    my ($self, $params) = @_;

    my $query = 'INSERT INTO users (user_id, username, password) VALUES (?,?,?)';
    my $user_id = $params->{user_id};
    my $username = $params->{username};
    my $password = $params->{password};
    my $password_hash = sha512_hex($password . 'hakata');
    $self->db->query($query, $user_id, $username, $password_hash);
}

sub search_by_user_id_and_password {
    my ($self, $params) = @_;

    my $password_hash = sha512_hex($params->{password} . 'hakata');
    $self->db->select_row('SELECT * FROM users WHERE user_id = ? AND password = ?',
                          $params->{user_id},
                          $password_hash);
}

sub search_by_user_id {
    my ($self, $params) = @_;

    $self->db->select_row('SELECT * FROM users WHERE user_id = ?', $params->{user_id});
}

sub search_by_current_user {
    my ($self, $params) = @_;

    $self->db->select_row('SELECT * FROM users WHERE user_id = ? AND password = ?',
                          $params->{user_id},
                          $params->{password});
}

sub search {
    my ($self, $id) = @_;

    $self->db->select_row('SELECT * FROM users WHERE id = ?', $id);
}

1;
