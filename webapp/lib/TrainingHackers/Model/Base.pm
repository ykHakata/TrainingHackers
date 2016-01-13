package TrainingHackers::Model::Base;
use Mouse;
use DBIx::Sunny;

has db => (
    is => 'rw', 
);

no Mouse;
__PACKAGE__->meta->make_immutable();

1;
