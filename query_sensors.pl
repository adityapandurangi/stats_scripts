#!/usr/bin/perl
use strict;
use warnings;
use English qw( -no_match_vars );
# use charnames ':full'; Needed before 5.16

## config
my $influx_host = '';
my $port = '8086';
my $db = '';
my $measurement = 'sensor_info';
my $measurement_host = '';
## end_config

open (my $fh, '-|', 'sensors')
    or die "could not run command sensors: $ERRNO";

my $post_data;
while (my $line = <$fh>) {
    my $measurement_name;
    my $value;

    if ( $line =~ qr/(Core \s [0-9]): .*? \+ (\d+ \. \d)/xms) {
        $measurement_name = lc $1;
        $value = $2;
        $measurement_name =~ s/\s//g;
    }

    if ( $line =~ qr/Array \s Fan: .*? (\d+) \s/xms) {
        $value = $1;
        $measurement_name = 'array_fan';
    }
    
    if ($measurement_name && $value) {
        $post_data .= "$measurement,host=$measurement_host,sensor=$measurement_name value=$value\n";
    }
}
`curl -s -i -XPOST "http://$influx_host:$port/write?db=$db" --data-binary "$post_data"`;
