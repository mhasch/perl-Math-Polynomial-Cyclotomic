# Copyright (c) 2019-2021 by Martin Becker, Blaubeuren.
# This package is free software; you can distribute it and/or modify it
# under the terms of the Artistic License 2.0 (see LICENSE file).

# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl 02_memoized.t'

use strict;
use warnings;
use Math::Polynomial;
use Math::Polynomial::Cyclotomic qw(:all);

use Test::More tests => 17;

my %table = ();

my $p1 = cyclo_poly(1, \%table);
is($p1->as_string, '(x - 1)');

my $p3 = cyclo_poly(3, \%table);
is($p3->as_string, '(x^2 + x + 1)');

my $p6 = cyclo_poly(6, \%table);
is($p6->as_string, '(x^2 - x + 1)');

my $p15 = cyclo_poly(15, \%table);
is($p15->as_string, '(x^8 - x^7 + x^5 - x^4 + x^3 - x + 1)');

my @f15 = cyclo_factors(15, \%table);
ok(4 == @f15 && $f15[3] == $p15);

my $it = cyclo_poly_iterate(undef, \%table);
is($it->()->as_string, '(x - 1)');
is($it->()->as_string, '(x + 1)');
is($it->()->as_string, '(x^2 + x + 1)');
is($it->()->as_string, '(x^2 + 1)');
is($it->()->as_string, '(x^4 + x^3 + x^2 + x + 1)');
is($it->()->as_string, '(x^2 - x + 1)');

my $p27 = $p3->cyclotomic(27, \%table);
ok($p27->degree == 18 && $p27->evaluate(1) == 3);

my $p27a = $p3->cyclotomic(27, \%table);
ok($p27a == $p27);

my @f27 = $p3->cyclo_factors(27, \%table);
ok(4 == @f27 && $f27[3] == $p27);

$it = $p3->cyclo_poly_iterate(20, \%table);
my $p20 = $it->();
is($p20->degree, 8);

my @f20 = $p3->cyclo_factors(20, \%table);
ok(6 == @f20 && $f20[5] == $p20);

my @fp = $p3->cyclo_plusfactors(9, \%table);
ok(3 == @fp && $fp[2]->evaluate(2) == 57);

__END__
