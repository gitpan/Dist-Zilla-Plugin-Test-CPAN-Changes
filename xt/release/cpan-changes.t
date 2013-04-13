#!perl

use Test::More;
use_ok('Test::CPAN::Changes');
changes_file_ok('Changes');
done_testing();
