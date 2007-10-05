
use Test::More tests => 2;
BEGIN { use_ok('Catalyst::Plugin::CustomErrorMessage') };

can_ok('Catalyst::Plugin::CustomErrorMessage', 'finalize_error');
