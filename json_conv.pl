#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: json_conv.pl
#
#        USAGE: wget -q -O - http://odata.tn.edu.tw/schoolapi/api/getdata | ./json_conv.pl > schools.json
#
#  DESCRIPTION: 轉換「台南市各級學校查詢JSON」資料
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: SHIE, Li-Yi (lyshie), lyshie@tn.edu.tw
# ORGANIZATION:
#      VERSION: 1.0
#      CREATED: 2016-07-16 11:45:59
#     REVISION: ---
#===============================================================================

use strict;
use warnings;

use JSON qw(decode_json encode_json);

my %latlng = ();

my $data;
do {
    local $/ = undef;
    $data = <STDIN>;
};

my $j = decode_json($data);

foreach my $s ( @{$j} ) {
    $latlng{ $s->{'Edu_code'} } = {
        'LAT' => $s->{'LAT'},
        'LNG' => $s->{'LNG'},
        NAME  => $s->{'SchoolName'},
    };
}

print "var schools = ";
print encode_json( \%latlng );
print ";"
