use strict;
use warnings;
use Test::More tests => 23;
use Test::Exception;

require_ok ('FarmBalance');
my $obj = FarmBalance->new(
	'farms' => 2,
	'stats' => { 'keyA'=> [10, 10], 'keyB' => [5, 5],},
);
isa_ok ( $obj, "FarmBalance" );


#- array_val_sum
my $data = {
	1 => { 'input' => [1,1], 'result' => 2, },
	2 => { 'input' => [1000,1000], 'result' => 2000, },
	3 => { 'input' => [-1, 100], 'result' => 99, },
	4 => { 'input' => [-10000, -100], 'result' => -10100, },
	5 => { 'input' => [34, -100], 'result' => -66, },
};
foreach my $key ( keys %$data ) {
	my $input = $data->{$key}->{input};
	my $res = $data->{$key}->{resutl};
	ok ( $obj->array_val_sum($input), $res );
}
$data = {
	1 => { 'input' => [1.1,1.1], 'result' => 2.2, },
	2 => { 'input' => [0.001,10], 'result' => 10.001, },
	3 => { 'input' => [-0.77, 100], 'result' => 99.23, },
	4 => { 'input' => [-0.1, -100], 'result' => -100.1, },
	5 => { 'input' => [0.34, -1], 'result' => -0.66, },
};
foreach my $key ( keys %$data ) {
	my $input = $data->{$key}->{input};
	my $res = $data->{$key}->{resutl};
	ok ( $obj->array_val_sum($input), $res );
}

#- check_param -> die
$data = {
	1 => {'farms' => 5, 'stats' => { 'keyA' => [10,10], 'keyB' => [5,5] }, 'res' => qr/Error:/},
	2 => {'farms' => 2, 'stats' => { 'keyA' => [10,10,1], 'keyB' => [5,5] }, 'res' => qr/Error:/},
	3 => {'farms' => 2, 'stats' => { 'keyA' => [10,10,1], 'keyB' => [5,5,7] }, 'res' => qr/Error:/},
	4 => {'farms' => 3, 'stats' => { 'keyA' => [10,10], 'keyB' => [5,5,7] }, 'res' => qr/Error:/},
	5 => {'farms' => 3, 'stats' => { 'keyA' => [10,10,10], 'keyB' => [5,5,7] }, 'res' => 0},
 	6 => {'farms' => 0, 'stats' => { 'keyA' => [1,2], 'keyB' => [7,7] }, 'res' => qr/Error:/},
 	7 => {'farms' => -10, 'stats' => { 'keyA' => [1,2], 'keyB' => [5] }, 'res' => qr/Error:/},
 	8 => {'farms' => 3, 'stats' => { 'keyA' => [1,2,3], 'keyB' => [1] }, 'res' => qr/Error:/},
 	9 => {'farms' => 3, 'stats' => { 'keyA' => [1,2,3], 'keyB' => [0,0.5,1] }, 'res' => 0},
 	10 => {'farms' => 10000000, 'stats' => { 'keyA' => [1,2,3], 'keyB' => [0,0.5,1] }, 'res' => qr/Error:/},
 	11 => {'farms' => 10000001, 'stats' => { 'keyA' => [1,2,3], 'keyB' => [0,0.5,1] }, 'res' => qr/Error:/},
};
foreach my $key ( keys %$data ) {
	my $farms = $data->{$key}->{farms};
	my $stats = $data->{$key}->{stats};
	my $res = $data->{$key}->{res};
	#warn($key, $farms, $stats, $res);
	my $obj = FarmBalance->new( 'farms'=>$farms, 'stats'=>$stats );
	if ( ref $res eq 'Regexp' ) {
		throws_ok { $obj->check_param } $res;
	} else {
		is ( $obj->check_param, 0 );
	}
}
#
