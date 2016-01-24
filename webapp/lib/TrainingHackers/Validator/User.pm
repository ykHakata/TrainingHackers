package TrainingHackers::Validator::User;
use strict;
use warnings;
use Spica::Validator::Rules;

rule user_id => (
    required => 1,
    min => 1,
    max => 50,
    regex => qr/[a-zA-Z\-_]/
);

rule username => (
    required => 1,
    min => 1,
    max => 50,
);

rule password => (
    required => 1,
    min => 1,
    max => 128,
    regex => qr/[a-zA-Z\-_]/
);

1;
