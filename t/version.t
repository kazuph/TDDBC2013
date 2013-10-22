use strict;
use warnings;
use utf8;
use Test::More;
use Test::Exception;
use_ok "JDKVersion";

subtest "validかどうか調べよう" => sub {
    subtest "JDK7u40" => sub {
        is JDKVersion::is_valid("JDK7u40"), 1;
    };
    subtest "hoge" => sub {
        is JDKVersion::is_valid("hoge"), undef;
    };
    subtest "undef" => sub {
        is JDKVersion::is_valid(undef), undef;
    };
    subtest "JDK7u9x" => sub {
        is JDKVersion::is_valid("JDK7u9x"), undef;
    };
    subtest "JDK7u01(0埋めしない)" => sub {
        is JDKVersion::is_valid("JDK7u01"), undef;
    };
    subtest "JDK7u" => sub {
        is JDKVersion::is_valid("JDK7u"), undef;
    };
    subtest "JDK7u100" => sub {
        is JDKVersion::is_valid("JDK7u100"), 1;
    };
    subtest "JDK8u0" => sub {
        is JDKVersion::is_valid("JDK8u0"), 1;
    };
};

subtest "parseする" => sub {
    subtest "不正な値でparseできない" => sub {
        dies_ok {JDKVersion->parse("hoge")};
    };
    subtest "正式な値ならparseできる" => sub {
        lives_ok {JDKVersion->parse("JDK7u40")};
    };
    subtest "familynumberが7" => sub {
        my $v = JDKVersion->parse("JDK7u40");
        is int $v->family_number, "7";
    };
    subtest "updatenumberが40" => sub {
        my $v = JDKVersion->parse("JDK7u40");
        is int $v->update_number, "40";
    };
};

subtest "大小を比較する" => sub {
    subtest "小さい" => sub {
        my $u40 = JDKVersion->parse("JDK7u40");
        my $u51 = JDKVersion->parse("JDK7u51");
        is $u40->lt($u51), 1;
    };
};

done_testing;
