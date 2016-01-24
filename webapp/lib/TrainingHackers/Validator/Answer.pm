package TrainingHackers::Validator::Answer;
use strict;
use warnings;
use Spica::Validator::Rules;

rule user_answer => (
    required => 1,
    min => 1,
    max => 255,
);

1;
