#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Test::More;
use JDKVersion;
# use_ok "JDKVersion";

subtest "validかどうか調べよう" => sub {
    subtest "JDK7u40" => sub {
        is JDKVersion::is_valid("JDK7u40"), 1;
    };
    subtest "hoge" => sub {
        is JDKVersion::is_valid("hoge"), 0;
    };
    subtest "undef" => sub {
        is JDKVersion::is_valid(undef), 0;
    };
    subtest "JDK7u9x" => sub {
        is JDKVersion::is_valid("JDK7u9x"), 0;
    };
    subtest "JDK7u01(0埋めしない)" => sub {
        is JDKVersion::is_valid("JDK7u01"), 0;
    };
    subtest "JDK7u" => sub {
        is JDKVersion::is_valid("JDK7u"), 0;
    };
    subtest "JDK7u100" => sub {
        is JDKVersion::is_valid("JDK7u100"), 1;
    };
    subtest "JDK8u0" => sub {
        is JDKVersion::is_valid("JDK8u0"), 1;
    };
};

done_testing;
