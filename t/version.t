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
    subtest "JDK7u40 < JDK7u51 は真" => sub {
        my $u40 = JDKVersion->parse("JDK7u40");
        my $u51 = JDKVersion->parse("JDK7u51");
        is $u40->lt($u51), 1;
    };
    subtest "JDK7u40 > JDK7u51 は偽" => sub {
        my $u40 = JDKVersion->parse("JDK7u40");
        my $u51 = JDKVersion->parse("JDK7u51");
        is $u40->gt($u51), 0;
    };
    subtest "JDK7u40はJDK7u40と等しい" => sub {
        my $u40 = JDKVersion->parse("JDK7u40");
        is $u40->eq($u40), 1;
    };
    subtest "JDK7u40はJDK7u51と等しくない" => sub {
        my $u40 = JDKVersion->parse("JDK7u40");
        my $u51 = JDKVersion->parse("JDK7u51");
        is $u40->eq($u51), 0;
    };
    subtest "JDK7u40 < JDK8u0 は真" => sub {
        my $u40 = JDKVersion->parse("JDK7u40");
        my $j8u0 = JDKVersion->parse("JDK8u0");
        is $u40->lt($j8u0), 1;
    };
    subtest "JDK7u40 > JDK8u0 は偽" => sub {
        my $u40 = JDKVersion->parse("JDK7u40");
        my $j8u0 = JDKVersion->parse("JDK8u0");
        is $u40->gt($j8u0), 0;
    };
    subtest "JDK7u40 < JDK8u51 は真" => sub {
        my $u40 = JDKVersion->parse("JDK7u40");
        my $j8u0 = JDKVersion->parse("JDK8u51");
        is $u40->lt($j8u0), 1;
    };
    subtest "JDK7u40 > JDK8u51 は偽" => sub {
        my $u40 = JDKVersion->parse("JDK7u40");
        my $j8u0 = JDKVersion->parse("JDK8u51");
        is $u40->gt($j8u0), 0;
    };
};

subtest "次のVersionを求める" => sub {
    subtest "Limited Update" => sub {
        my $u45 = JDKVersion->parse("JDK7u45");
        my $u60 = $u45->next_limited_udpate;
        is $u60->update_number, 60;
    };
    subtest "Limited Update" => sub {
        my $u60 = JDKVersion->parse("JDK7u60");
        my $u80 = $u60->next_limited_udpate;
        is $u80->update_number, 80;
    };
    subtest "Critical Patch Update" => sub {
        my $u45 = JDKVersion->parse("JDK7u45");
        my $u51 = $u45->next_critical_patch_update;
        is $u51->update_number, 51;
    };
    subtest "Critical Patch Update" => sub {
        my $u44 = JDKVersion->parse("JDK7u44");
        my $u45 = $u44->next_critical_patch_update;
        is $u45->update_number, 45;
    };
    subtest "next security alert" => sub {
        my $u45 = JDKVersion->parse("JDK7u45");
        my $u46 = $u45->next_security_alert;
        is $u46->update_number, 46;
    };
};

done_testing;
