use strict;
use warnings;
use Data::Dumper;
use Furl;

my $furl = Furl->new;
my $res = $furl->get('http://www13429ui.sakura.ne.jp/questions/1');
print Dumper($res);
